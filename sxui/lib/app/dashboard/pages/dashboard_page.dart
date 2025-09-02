import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/rendering.dart' show RenderAbstractViewport;

import 'package:sxui/app/theme/app_theme.dart'; // NEW

// shared + dashboard models
import 'package:sxui/app/shared/models/tab_item.dart';
import 'package:sxui/app/dashboard/models/tile_models.dart';
import 'package:sxui/app/dashboard/models/widget_kind.dart';

// data + dialogs
import 'package:sxui/app/dashboard/data/widget_registry.dart';
import 'package:sxui/app/dashboard/dialogs/widget_picker_dialog.dart';
import 'package:sxui/app/dashboard/dialogs/driver_name_dialog.dart';
import 'package:sxui/app/dashboard/dialogs/size_picker.dart';

// widgets
import 'package:sxui/app/dashboard/widgets/animated_backdrop.dart';
import 'package:sxui/app/dashboard/widgets/glass_bar.dart';
import 'package:sxui/app/dashboard/widgets/tile_chrome.dart';
import 'package:sxui/app/dashboard/widgets/minimized_tabs_bar.dart';

// features
import 'package:sxui/app/features/main_hub/main_hub.dart';
import 'package:sxui/app/features/drivers/driver.dart' show DriverWidget;

/// Stable drag payload to avoid index drift during masonry layout
class _TileDrag {
  final String id;
  final TileSize size;
  const _TileDrag(this.id, this.size);
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  // tiles on the grid
  late List<TileData> _tiles;

  // stable keys per tile id (for scroll-to)
  final Map<String, GlobalKey> _tileKeys = {};

  // transient highlight for scroll-to
  final Set<String> _highlighted = {};

  // used by some tiles (Log etc.)
  final ValueNotifier<List<Map<String, dynamic>>> logMessages =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  // theme mode
  ThemeMode _themeMode = ThemeMode.dark; // default to dark

  // CMD anchor (reliable dropdown positioning)
  final GlobalKey _cmdAnchorKey = GlobalKey();

  // drag state + background
  int? _draggingIndex;
  Offset _pointer = Offset.zero;
  late final AnimationController _bgCtl;
  Color _accent = Colors.blueAccent;

  // list labels (for Cmd menu)
  final Map<String, String> _labels = {};

  // scroll controller for the grid
  final ScrollController _scrollCtl = ScrollController();

  // track which indexes are currently built to guide offscreen scroll
  int _minBuiltIndex = 1 << 30;
  int _maxBuiltIndex = -1;

  // tabs (kept for compatibility; you can open tabs from tiles)
  final List<TabItem> openTabs = [];

  @override
  void initState() {
    super.initState();

    // Always seed the main hub (pinned top-left)
    final hub = TileData(
      id: 'main-hub',
      size: TileSize.large,
      builder: (ctx) => MainDashWidget(
        logMessages: logMessages,
        onOpenTab: _openTab,
        onCloseTab: _closeTab,
      ),
    );
    _tiles = [hub];
    _tileKeys[hub.id] = GlobalKey();
    _labels[hub.id] = 'Dashboard';

    _bgCtl =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();
  }

  @override
  void dispose() {
    _bgCtl.dispose();
    _scrollCtl.dispose();
    super.dispose();
  }

  // =================== CMD DROPDOWN (anchored to button) ===================

  Future<void> _showCmdMenuAtAnchor() async {
    final ctx = _cmdAnchorKey.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (box == null || overlay == null) return;

    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlay);
    final bottomRight =
        box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay);
    final rect = Rect.fromPoints(topLeft, bottomRight);

    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(rect.left, rect.bottom, rect.width, 0),
        Offset.zero & overlay.size,
      ),
      items: _tiles.map((t) {
        return PopupMenuItem<String>(
          value: t.id,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(_labelFor(t), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              Text(
                t.size.name[0].toUpperCase() + t.size.name.substring(1),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        );
      }).toList(),
    );

    if (choice != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollTo(choice);
      });
    }
  }

  // keep signature for compatibility (GlassBar expects it)
  void _togglePalette() => _showCmdMenuAtAnchor();

  // =================== grid helpers ===================

  void _swap(int from, int to) {
    if (from == to || from < 0 || to < 0) return;
    if (from == 0 || to == 0) return;               // keep main hub pinned
    if (_tiles[from].size != _tiles[to].size) return; // same-size-only swap
    setState(() {
      final item = _tiles.removeAt(from);
      _tiles.insert(to, item);
    });
  }

  void _cycleSize(int index) {
    final t = _tiles[index];
    final next = switch (t.size) {
      TileSize.small => TileSize.medium,
      TileSize.medium => TileSize.large,
      TileSize.large => TileSize.small,
    };
    setState(() => _tiles[index] = t.copyWith(size: next));
  }

  // =================== delete menu ===================

  Future<void> _showDeleteMenuAt(Offset global, String id) async {
    if (id == 'main-hub') return; // do not delete pinned hub
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final rect = Rect.fromLTWH(global.dx, global.dy, 0, 0);

    final action = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(rect, Offset.zero & overlay.size),
      items: const [
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );

    if (action == 'delete') {
      setState(() {
        _tiles.removeWhere((t) => t.id == id);
        _tileKeys.remove(id);
        _labels.remove(id);
        _highlighted.remove(id);
      });
    }
  }

  // =================== robust CENTERED scroll-to (up/down + offscreen) ===================

  Future<void> _scrollTo(String id, {int attempt = 0}) async {
    if (attempt > 20) return;

    final key = _tileKeys[id];
    final ctx = key?.currentContext;

    if (ctx == null) {
      final targetIndex = _tiles.indexWhere((t) => t.id == id);
      if (targetIndex < 0) return;

      final pos = _scrollCtl.position;
      final step = pos.viewportDimension * 0.90;

      if (_maxBuiltIndex >= 0 && targetIndex > _maxBuiltIndex) {
        final to =
            (pos.pixels + step).clamp(pos.minScrollExtent, pos.maxScrollExtent);
        await _scrollCtl.animateTo(to,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic);
      } else if (_minBuiltIndex < (1 << 30) && targetIndex < _minBuiltIndex) {
        final to =
            (pos.pixels - step).clamp(pos.minScrollExtent, pos.maxScrollExtent);
        await _scrollCtl.animateTo(to,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic);
      } else {
        final to = (pos.pixels + step * 0.5)
            .clamp(pos.minScrollExtent, pos.maxScrollExtent);
        await _scrollCtl.animateTo(to,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic);
      }

      await Future.delayed(const Duration(milliseconds: 16));
      if (!mounted) return;
      return _scrollTo(id, attempt: attempt + 1);
    }

    final renderObject = ctx.findRenderObject();
    if (renderObject == null) return;

    final viewport = RenderAbstractViewport.of(renderObject);
    final position = _scrollCtl.position;

    final centerReveal = viewport.getOffsetToReveal(renderObject, 0.5).offset;

    final target =
        centerReveal.clamp(position.minScrollExtent, position.maxScrollExtent);

    if ((target - position.pixels).abs() > 0.5) {
      await _scrollCtl.animateTo(
        target,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      setState(() => _highlighted.add(id));
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) setState(() => _highlighted.remove(id));
    });
  }

  // =================== tabs helpers ===================

  void _openTab(TabItem tab) {
    setState(() {
      for (var t in openTabs) {
        t.isMinimized = true;
      }
      openTabs.add(tab);
    });
  }

  void _closeTab(String id) =>
      setState(() => openTabs.removeWhere((t) => t.id == id));

  void _minimizeTab(String id) =>
      setState(() => openTabs.firstWhere((t) => t.id == id).isMinimized = true);

  void _restoreTab(String id) => setState(
      () => openTabs.firstWhere((t) => t.id == id).isMinimized = false);

  // =================== sizing ===================

  double _baseHeight(TileSize s, double colW) {
    switch (s) {
      case TileSize.small:
        return colW * 0.75;
      case TileSize.medium:
        return colW * 1.20;
      case TileSize.large:
        return colW * 1.85;
    }
  }

  // =================== add widget flows ===================

  Future<void> _onOpenPicker() async {
    final options = buildWidgetOptions(logMessages);
    final choice =
        await showWidgetPickerDialog(context, options: options);
    if (choice == null) return;

    String? driverName;
    if (choice.kind == WidgetKind.driver) {
      driverName = await promptDriverName(context);
      if (driverName == null || driverName.trim().isEmpty) return;
    }

    final size = await pickTileSize(context);
    if (size == null) return;

    await _addTile(choice, size, driverName: driverName?.trim());
  }

  Future<void> _addWidgetOfKindFlow(WidgetKind kind) async {
    final opt = _optionForKind(kind);
    if (opt == null) return;

    String? driverName;
    if (kind == WidgetKind.driver) {
      driverName = await promptDriverName(context);
      if (driverName == null || driverName.trim().isEmpty) return;
    }

    final size = await pickTileSize(context);
    if (size == null) return;

    await _addTile(opt, size, driverName: driverName?.trim());
  }

  WidgetOption? _optionForKind(WidgetKind kind) {
    for (final o in buildWidgetOptions(logMessages)) {
      if (o.kind == kind) return o;
    }
    return null;
  }

  Future<void> _addTile(WidgetOption opt, TileSize size,
      {String? driverName}) async {
    final id = const Uuid().v4();

    final tileBuilder = (BuildContext ctx) {
      if (opt.kind == WidgetKind.driver) {
        return DriverWidget(
          driverId: id,
          initialName: driverName ?? 'Driver',
          logMessages: logMessages,
        );
      }
      return opt.builder(ctx, id);
    };

    setState(() {
      _tiles.add(TileData(id: id, size: size, builder: tileBuilder)); // append -> right side
      _tileKeys[id] = GlobalKey();
      _labels[id] = switch (opt.kind) {
        WidgetKind.driver => 'Driver: ${driverName ?? 'Driver'}',
        _ => _kindPretty(opt.kind),
      };
    });
  }

  // =================== helpers ===================

  String _labelFor(TileData t) {
    return _labels[t.id] ??
        (t.id == 'main-hub' ? 'Dashboard' : t.id.substring(0, 8));
  }

  String _enumName(Object e) => e.toString().split('.').last;

  String _toTitleCase(String s) =>
      s.split('_').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  String _kindPretty(WidgetKind k) => _toTitleCase(_enumName(k));

  // =================== UI ===================

  @override
  Widget build(BuildContext context) {
    // Apply the selected theme to this page subtree
    final theme = AppTheme.forMode(_themeMode);
    // Keep the animated backdrop accent synced with theme primary
    _accent = theme.colorScheme.primary;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              final width = c.maxWidth;
              const gap = 12.0;

              final cols = ((width / 320).floor()).clamp(3, 8).toInt(); // 3..8
              final colW = (width - gap * (cols + 1)) / cols;

              final hasMiniBar = openTabs.any((t) => t.isMinimized);

              // reset built range tracking for this frame
              _minBuiltIndex = 1 << 30;
              _maxBuiltIndex = -1;

              return MouseRegion(
                onHover: (e) => setState(() => _pointer = e.localPosition),
                child: Stack(
                  children: [
                    // animated ambient background
                    Positioned.fill(
                      child: AnimatedBackdrop(
                        accent: _accent,
                        controller: _bgCtl,
                        pointer: _pointer,
                      ),
                    ),

                    // glassy top bar
                    Positioned(
                      left: 12,
                      right: 12,
                      top: 8,
                      child: GlassBar(
                        accent: _accent,
                        onAccentChanged: (c) => setState(() => _accent = c),
                        onLogoTap: _onOpenPicker,
                        onOpenPalette: _togglePalette,     // opens anchored dropdown
                        cmdAnchorKey: _cmdAnchorKey,        // anchor for dropdown
                        themeMode: _themeMode,              // NEW
                        onThemeModeChanged: (mode) {        // NEW
                          setState(() => _themeMode = mode);
                        },
                      ),
                    ),

                    // GRID
                    Positioned.fill(
                      top: 72,
                      child: MasonryGridView.count(
                        controller: _scrollCtl,
                        padding: const EdgeInsets.all(gap),
                        crossAxisCount: cols,
                        mainAxisSpacing: gap,
                        crossAxisSpacing: gap,
                        cacheExtent: 800,
                        itemCount: _tiles.length,
                        itemBuilder: (context, index) {
                          // track built range
                          if (index < _minBuiltIndex) _minBuiltIndex = index;
                          if (index > _maxBuiltIndex) _maxBuiltIndex = index;

                          final tile = _tiles[index];
                          final h = _baseHeight(tile.size, colW);

                          // Base card body
                          final coreCard = TileChrome(
                            height: h,
                            child: tile.builder(context),
                          );

                          // Top-edge resize handle: double-tap to cycle size
                          final withResizeHandle = Stack(
                            children: [
                              coreCard,
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: 14,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onDoubleTap: () => _cycleSize(index),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.resizeUpDown,
                                    child: const SizedBox.expand(),
                                  ),
                                ),
                              ),
                            ],
                          );

                          // Scroll-to highlight overlay (no layout shift)
                          final isHighlighted = _highlighted.contains(tile.id);
                          final highlightedCard = Stack(
                            children: [
                              withResizeHandle,
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isHighlighted ? _accent : Colors.transparent,
                                        width: 1.5,
                                      ),
                                      boxShadow: isHighlighted
                                          ? [
                                              BoxShadow(
                                                color: _accent.withOpacity(0.35),
                                                blurRadius: 28,
                                                spreadRadius: 1,
                                              ),
                                            ]
                                          : const [],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );

                          final keyed = Container(
                            key: _tileKeys[tile.id] ??= GlobalKey(debugLabel: tile.id),
                            child: highlightedCard,
                          );

                          // Key-less ghost to avoid GlobalKey duplication in overlay
                          final feedbackGhost = SizedBox(
                            width: colW,
                            child: Material(
                              color: Colors.transparent,
                              child: Opacity(opacity: 0.9, child: withResizeHandle),
                            ),
                          );

                          // ===== Hold-to-delete timer wiring =====
                          Timer? holdTimer;
                          void _cancelHoldTimer() {
                            holdTimer?.cancel();
                            holdTimer = null;
                          }
                          void _startHoldTimer(TapDownDetails d) {
                            if (tile.id == 'main-hub') return; // never delete hub
                            _cancelHoldTimer();
                            final pos = d.globalPosition;
                            holdTimer = Timer(const Duration(seconds: 2), () {
                              if (mounted) _showDeleteMenuAt(pos, tile.id);
                            });
                          }

                          if (index == 0) {
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTapDown: _startHoldTimer,
                              onTapUp: (_) => _cancelHoldTimer(),
                              onTapCancel: _cancelHoldTimer,
                              onPanStart: (_) => _cancelHoldTimer(),
                              child: keyed,
                            );
                          }

                          final draggable = Draggable<_TileDrag>(
                            data: _TileDrag(tile.id, tile.size),
                            onDragStarted: () {
                              _cancelHoldTimer();
                              setState(() => _draggingIndex = index);
                            },
                            onDragEnd: (_) => setState(() => _draggingIndex = null),
                            feedback: feedbackGhost,
                            childWhenDragging: Opacity(opacity: 0.25, child: keyed),
                            child: DragTarget<_TileDrag>(
                              onWillAccept: (from) {
                                if (from == null) return false;
                                if (from.id == tile.id) return false;
                                if (from.size != tile.size) return false;
                                final fromIdx = _tiles.indexWhere((t) => t.id == from.id);
                                if (fromIdx == 0 || index == 0) return false;
                                return true;
                              },
                              onAccept: (from) {
                                final fromIdx = _tiles.indexWhere((t) => t.id == from.id);
                                final toIdx   = _tiles.indexWhere((t) => t.id == tile.id);
                                if (fromIdx <= 0 || toIdx <= 0) return;
                                if (_tiles[fromIdx].size != _tiles[toIdx].size) return;
                                _swap(fromIdx, toIdx);
                              },
                              builder: (context, candidate, _) {
                                final _TileDrag? drag = candidate.isNotEmpty ? candidate.first : null;
                                final bool eligible = drag != null && drag.size == tile.size;

                                return AnimatedScale(
                                  scale: eligible ? 0.98 : 1.0,
                                  duration: const Duration(milliseconds: 120),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 120),
                                    decoration: BoxDecoration(
                                      boxShadow: eligible
                                          ? [
                                              BoxShadow(
                                                color: _accent.withOpacity(0.25),
                                                blurRadius: 12,
                                                spreadRadius: 2,
                                              )
                                            ]
                                          : const [],
                                    ),
                                    child: keyed,
                                  ),
                                );
                              },
                            ),
                          );

                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTapDown: _startHoldTimer,
                            onTapUp: (_) => _cancelHoldTimer(),
                            onTapCancel: _cancelHoldTimer,
                            onPanStart: (_) => _cancelHoldTimer(),
                            child: draggable,
                          );
                        },
                      ),
                    ),

                    if (hasMiniBar)
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: MinimizedTabsBar(
                          tabs: openTabs,
                          onClose: _closeTab,
                          onRestore: _restoreTab,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
