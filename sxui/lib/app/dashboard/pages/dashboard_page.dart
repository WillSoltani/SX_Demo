import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:uuid/uuid.dart';

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

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  // tiles on the grid
  late List<TileData> _tiles;

  // used by some tiles (Log etc.)
  final ValueNotifier<List<Map<String, dynamic>>> logMessages =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  // drag state + background
  int? _draggingIndex;
  Offset _pointer = Offset.zero;
  late final AnimationController _bgCtl;
  Color _accent = Colors.blueAccent;

  // tabs (kept for compatibility; you can open tabs from tiles)
  final List<TabItem> openTabs = [];

  @override
  void initState() {
    super.initState();

    // Always seed the main hub (your original dashboard with Customers/Emails/Reports/Operations/More)
    _tiles = [
      TileData(
        id: 'main-hub',
        size: TileSize.large,
          builder: (ctx) => MainDashWidget(
            logMessages: logMessages,
            onOpenTab: _openTab,
            onCloseTab: _closeTab,
          ),

      ),
    ];

    _bgCtl =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();
  }

  @override
  void dispose() {
    _bgCtl.dispose();
    super.dispose();
  }

  // ---------------- grid helpers ----------------

  void _swap(int from, int to) {
    if (from == to || from < 0 || to < 0) return;
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

  // ---------------- tabs helpers ----------------

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

  // ---------------- sizing ----------------

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

  // ---------------- add widget flows ----------------

  /// Full picker flow (SX Dashboard click): pick widget -> (ask name if Driver) -> pick size -> add
  Future<void> _onOpenPicker() async {
    final options = buildWidgetOptions(logMessages);
    final choice =
        await showWidgetPickerDialog(context, options: options); // user picks
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

  /// Quick add from hub by kind (skips the big picker UI)
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

    // Build widget: if Driver, inject the name here; otherwise use registry builder.
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
      _tiles.insert(0, TileData(id: id, size: size, builder: tileBuilder));
    });
  }

  // ---------------- UI ----------------

  void _togglePalette() {
    // optional: hook a command palette here if you want
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final width = c.maxWidth;
            const gap = 12.0;

            final cols = ((width / 320).floor()).clamp(3, 8).toInt(); // 3..8
            final colW = (width - gap * (cols + 1)) / cols;

            final hasMiniBar = openTabs.any((t) => t.isMinimized);

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
                      onLogoTap: _onOpenPicker, // SX Dashboard click
                      onOpenPalette: _togglePalette,
                    ),
                  ),

                  // GRID
                  Positioned.fill(
                    top: 72,
                    child: MasonryGridView.count(
                      padding: const EdgeInsets.all(gap),
                      crossAxisCount: cols,
                      mainAxisSpacing: gap,
                      crossAxisSpacing: gap,
                      itemCount: _tiles.length,
                      itemBuilder: (context, index) {
                        final tile = _tiles[index];
                        final h = _baseHeight(tile.size, colW);

                        final card = GestureDetector(
                          onDoubleTap: () => _cycleSize(index),
                          child: TileChrome(
                            height: h,
                            child: tile.builder(context),
                          ),
                        );

                        return LongPressDraggable<int>(
                          data: index,
                          onDragStarted: () =>
                              setState(() => _draggingIndex = index),
                          onDragEnd: (_) =>
                              setState(() => _draggingIndex = null),
                          feedback: Material(
                            color: Colors.transparent,
                            child: Opacity(opacity: 0.9, child: card),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.25,
                            child: card,
                          ),
                          child: DragTarget<int>(
                            onWillAccept: (from) => from != index,
                            onAccept: (from) => _swap(from!, index),
                            builder: (context, candidate, _) {
                              final hovering = candidate.isNotEmpty;
                              return AnimatedScale(
                                scale: hovering ? 0.98 : 1.0,
                                duration: const Duration(milliseconds: 120),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 120),
                                  decoration: BoxDecoration(
                                    boxShadow: hovering
                                        ? [
                                            BoxShadow(
                                              color: _accent
                                                  .withOpacity(0.25),
                                              blurRadius: 12,
                                              spreadRadius: 2,
                                            )
                                          ]
                                        : [],
                                  ),
                                  child: card,
                                ),
                              );
                            },
                          ),
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
    );
  }
}
