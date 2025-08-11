import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Your widgets
import 'package:sxui/app/MainDashboard/mainDash_Widget.dart';
import 'package:sxui/app/Extensions/tab_properties.dart';
import 'Extensions/dashboard_box.dart';
import 'package:sxui/app/models/tab_item.dart';
import 'Widgits/Billing/Billing.dart';
import 'Widgits/Setting/setting.dart';
import 'Widgits/SalesSummary/salesSum.dart';
import 'Widgits/Search/search.dart';
import 'Widgits/Drivers/driver1.dart';
import 'Widgits/Drivers/driver2.dart';
import 'Widgits/Drivers/driver3.dart';
import 'Widgits/Drivers/driver4.dart';
import 'Widgits/Drivers/driverSum.dart';
import 'Widgits/Integrations/Integrations.dart';
import 'Widgits/Calendar/calendar.dart';
import 'Widgits/Log/log.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SX Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

enum TileSize { small, medium, large }

class TileData {
  final String id;
  final TileSize size;
  final Widget Function(BuildContext) builder;
  const TileData({required this.id, required this.size, required this.builder});
  TileData copyWith({TileSize? size}) =>
      TileData(id: id, size: size ?? this.size, builder: builder);
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  // tiles (kept minimal = known-good widgets)
  late List<TileData> _tiles;

  // for your tiles that log
  final ValueNotifier<List<Map<String, dynamic>>> logMessages =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  // drag state
  int? _draggingIndex;

  // measured tile heights by id
  final Map<String, double> _tileHeights = {};

  // background + accent
  Offset _pointer = Offset.zero;
  late final AnimationController _bgCtl;
  Color _accent = Colors.blueAccent;

  // command palette
  final TextEditingController _paletteController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _paletteVisible = false;
  String? _highlightedTileId;

  // tabs (as before)
  final List<TabItem> openTabs = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    _tiles = [
      TileData(id: 'x1',  size: TileSize.small,  builder: (_) => BoxX1()),
      TileData(
        id: 'mainDash',
        size: TileSize.large,
        builder: (_) => MainDashWidget(
          logMessages: logMessages,
          onOpenTab: _openTab,
          onCloseTab: _closeTab,
        ),
      ),
      TileData(id: 'x3',  size: TileSize.small,  builder: (_) => BoxX3()),
      TileData(id: 'x4',  size: TileSize.small,  builder: (_) => BoxX4()),
      TileData(id: 'x5',  size: TileSize.small,  builder: (_) => BoxX5()),
      TileData(id: 'x6',  size: TileSize.medium, builder: (_) => BoxX6(logMessages: logMessages)),
      TileData(id: 'x7',  size: TileSize.medium, builder: (_) => BoxX7(logMessages: logMessages)),
      TileData(id: 'x8',  size: TileSize.medium, builder: (_) => BoxX8(logMessages: logMessages)),
      TileData(id: 'x9',  size: TileSize.medium, builder: (_) => BoxX9(logMessages: logMessages)),
      TileData(id: 'x10', size: TileSize.small,  builder: (_) => BoxX10()),
      TileData(id: 'x11', size: TileSize.small,  builder: (_) => BoxX11()),
      TileData(id: 'x12', size: TileSize.medium, builder: (_) => BoxX12(logMessages: logMessages)),
      TileData(id: 'x13', size: TileSize.large,  builder: (_) => BoxX13(logMessages: logMessages)),
    ];

    // animated ambient bg
    _bgCtl = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();

    // load saved layout after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLayout());
  }

  @override
  void dispose() {
    _bgCtl.dispose();
    _paletteController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ----- persistence -----
  Future<void> _saveLayout() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _tiles
        .map((t) => {'id': t.id, 'size': t.size.index})
        .toList(growable: false);
    await prefs.setString('sx_layout', jsonEncode(data));
  }

  Future<void> _loadLayout() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('sx_layout');
    if (s == null) return;
    try {
      final List<dynamic> arr = jsonDecode(s);
      final map = {for (final t in _tiles) t.id: t};
      final restored = <TileData>[];
      for (final e in arr) {
        final id = e['id'] as String?;
        final sz = e['size'] as int?;
        if (id != null && map.containsKey(id)) {
          final base = map.remove(id)!;
          final clamped = (sz ?? base.size.index).clamp(0, 2);
          restored.add(base.copyWith(size: TileSize.values[clamped]));
        }
      }
      restored.addAll(map.values); // any new tiles not in saved layout
      setState(() => _tiles = restored);
    } catch (_) {
      // ignore bad JSON
    }
  }

  // ----- drag + resize -----
  void _swap(int from, int to) {
    if (from == to || from < 0 || to < 0) return;
    setState(() {
      final item = _tiles.removeAt(from);
      _tiles.insert(to, item);
    });
    _saveLayout();
  }

  void _cycleSize(int index) {
    final t = _tiles[index];
    final next = switch (t.size) {
      TileSize.small => TileSize.medium,
      TileSize.medium => TileSize.large,
      TileSize.large => TileSize.small,
    };
    setState(() => _tiles[index] = t.copyWith(size: next));
    _saveLayout();
  }

  // ----- tabs -----
  void _openTab(TabItem tab) {
    setState(() {
      for (var t in openTabs) t.isMinimized = true;
      openTabs.add(tab);
    });
  }
  void _closeTab(String id) => setState(() => openTabs.removeWhere((t) => t.id == id));
  void _minimizeTab(String id) =>
      setState(() => openTabs.firstWhere((t) => t.id == id).isMinimized = true);
  void _restoreTab(String id) =>
      setState(() => openTabs.firstWhere((t) => t.id == id).isMinimized = false);

  // ----- command palette -----
  void _togglePalette() {
    setState(() {
      _paletteVisible = !_paletteVisible;
      if (_paletteVisible) _paletteController.clear();
    });
  }

  void _highlightTile(String id) {
    setState(() => _highlightedTileId = id);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _highlightedTileId == id) setState(() => _highlightedTileId = null);
    });
  }

  // ----- sizing & fit-to-viewport -----
  double _baseH(TileSize s, double colW) {
    switch (s) {
      case TileSize.small:  return colW * 0.75;
      case TileSize.medium: return colW * 1.20;
      case TileSize.large:  return colW * 1.85;
    }
  }
  int _minIndex(List<double> a) {
    var mi = 0, mv = a[0];
    for (var i = 1; i < a.length; i++) { if (a[i] < mv) { mi = i; mv = a[i]; } }
    return mi;
  }
  double _predictTallest(int cols, double gridW, double gap, double reserveBottom) {
    final colW = (gridW - gap * (cols + 1)) / cols;
    final heights = List<double>.filled(cols, 0);
    for (final t in _tiles) {
      final h = _tileHeights[t.id] ?? _baseH(t.size, colW);
      heights[_minIndex(heights)] += h + gap;
    }
    return heights.reduce((a, b) => a > b ? a : b) + gap + reserveBottom;
  }

  // ----- context menu -----
  Future<void> _showTileMenu(Offset pos, int index) async {
    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(pos.dx, pos.dy, pos.dx, pos.dy),
      items: const [
        PopupMenuItem(value: 's', child: Text('Resize: Small')),
        PopupMenuItem(value: 'm', child: Text('Resize: Medium')),
        PopupMenuItem(value: 'l', child: Text('Resize: Large')),
        PopupMenuDivider(),
        PopupMenuItem(value: 'highlight', child: Text('Highlight')),
      ],
    );
    if (choice == null) return;
    switch (choice) {
      case 's': setState(() => _tiles[index] = _tiles[index].copyWith(size: TileSize.small)); _saveLayout(); break;
      case 'm': setState(() => _tiles[index] = _tiles[index].copyWith(size: TileSize.medium)); _saveLayout(); break;
      case 'l': setState(() => _tiles[index] = _tiles[index].copyWith(size: TileSize.large)); _saveLayout(); break;
      case 'highlight': _highlightTile(_tiles[index].id); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.isControlPressed && event.logicalKey == LogicalKeyboardKey.keyK) {
            _togglePalette();
          } else if (event.logicalKey == LogicalKeyboardKey.escape && _paletteVisible) {
            _togglePalette();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              final width  = c.maxWidth;
              const gap = 12.0;

              final cols = (width / 320).floor().clamp(3, 8);
              final hasMiniBar = openTabs.any((t) => t.isMinimized);
              final reserveBottom = hasMiniBar ? 70.0 : 0.0;
              final _ = _predictTallest(cols, width, gap, reserveBottom);
              final colW = (width - gap * (cols + 1)) / cols;

              return MouseRegion(
                onHover: (e) => setState(() => _pointer = e.localPosition),
                child: Stack(
                  children: [
                    // animated ambient glow + pointer halo
                    Positioned.fill(child: _AnimatedBackdrop(accent: _accent, controller: _bgCtl, pointer: _pointer)),

                    // glassy top bar
                    Positioned(
                      left: 12, right: 12, top: 8,
                      child: _GlassBar(
                        accent: _accent,
                        onAccentChanged: (c) => setState(() => _accent = c),
                        onOpenPalette: _togglePalette,
                      ),
                    ),

                    // grid
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(gap),
                        child: MasonryGridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          crossAxisCount: cols,
                          mainAxisSpacing: gap,
                          crossAxisSpacing: gap,
                          itemCount: _tiles.length,
                          itemBuilder: (context, index) {
                              final tile = _tiles[index];

                              final chrome = _TileChrome(
                                accent: _accent,
                                highlight: tile.id == _highlightedTileId,
                                child: IconTheme(
                                  data: IconThemeData(size: (colW * 0.08).clamp(12, 28)),
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: (colW * 0.05).clamp(11, 18),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    child: tile.builder(context),
                                  ),
                                ),
                              );

                              final card = _InteractiveTileShell(
                                child: GestureDetector(
                                  onDoubleTap: () => _cycleSize(index),
                                  onSecondaryTapDown: (d) => _showTileMenu(d.globalPosition, index),
                                  child: chrome,
                                ),
                              );

                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    final render = context.findRenderObject();
                                    if (render is RenderBox) {
                                      final h = render.size.height;
                                      if (_tileHeights[tile.id] != h) {
                                        setState(() => _tileHeights[tile.id] = h);
                                      }
                                    }
                                  });

                                  return RepaintBoundary(
                                    child: LongPressDraggable<int>(
                                      data: index,
                                      onDragStarted: () => setState(() => _draggingIndex = index),
                                      onDragEnd: (_)   => setState(() => _draggingIndex = null),
                                      feedback: Material(color: Colors.transparent, child: Opacity(opacity: 0.9, child: card)),
                                      childWhenDragging: Opacity(opacity: 0.25, child: card),
                                      child: DragTarget<int>(
                                        onWillAccept: (from) => from != index,
                                        onAccept: (from) => _swap(from!, index),
                                        builder: (context, candidate, _) {
                                          final hovering = candidate.isNotEmpty;
                                          return AnimatedScale(
                                            scale: hovering ? 0.98 : 1.0,
                                            duration: const Duration(milliseconds: 120),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 120),
                                              decoration: BoxDecoration(
                                                boxShadow: hovering
                                                    ? [BoxShadow(color: _accent.withOpacity(0.25), blurRadius: 12, spreadRadius: 2)]
                                                    : [],
                                              ),
                                              child: card,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    if (hasMiniBar)
                      Positioned(bottom: 10, left: 10, child: _buildMinimizedTabsBar(context)),

                    if (_paletteVisible)
                      Positioned.fill(child: _buildCommandPalette(width)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ---- command palette UI ----
  Widget _buildCommandPalette(double width) {
    final results = _tiles
        .where((t) => t.id.toLowerCase().contains(_paletteController.text.toLowerCase()))
        .toList();
    final panelWidth = math.min(width * 0.6, 520.0);

    return GestureDetector(
      onTap: _togglePalette,
      child: Container(
        color: Colors.black54,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // stop tap-through
            child: Container(
              width: panelWidth,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _paletteController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search tiles...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 220,
                    child: ListView(
                      children: results.map((t) {
                        return ListTile(
                          title: Text(t.id, style: const TextStyle(color: Colors.white)),
                          onTap: () {
                            _highlightTile(t.id);
                            _togglePalette();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---- minimized tabs bar ----
  Widget _buildMinimizedTabsBar(BuildContext context) {
    final minimizedTabs = openTabs.where((t) => t.isMinimized).toList();
    if (minimizedTabs.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, -2))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: minimizedTabs.map((tab) => _minimizedTabButton(tab)).toList(),
        ),
      ),
    );
  }

  Widget _minimizedTabButton(TabItem tab) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => tab.isHovered = true),
      onExit:  (_) => setState(() => tab.isHovered = false),
      child: GestureDetector(
        onTap: () => _restoreTab(tab.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: tab.isHovered ? Colors.grey[600] : Colors.grey[700],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tab.title, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _closeTab(tab.id),
                child: const Icon(Icons.close, size: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- components ----------

class _AnimatedBackdrop extends StatelessWidget {
  final Color accent;
  final AnimationController controller;
  final Offset pointer;
  const _AnimatedBackdrop({required this.accent, required this.controller, required this.pointer});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value * 2 * math.pi;
        final blob1 = Offset(math.cos(t) * 0.25, math.sin(t) * 0.2);
        final blob2 = Offset(math.cos(-t * 0.7) * -0.3, math.sin(-t * 0.7) * 0.25);
        final size = MediaQuery.of(context).size;

        return Stack(
          children: [
            // ambient blobs
            Positioned.fill(
              child: CustomPaint(
                painter: _GlowPainter(accent, blob1, blob2),
              ),
            ),
            // pointer halo
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      (size.width == 0) ? 0 : (pointer.dx / size.width) * 2 - 1,
                      (size.height == 0) ? 0 : (pointer.dy / size.height) * 2 - 1,
                    ),
                    radius: 1.1,
                    colors: [accent.withOpacity(0.14), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlowPainter extends CustomPainter {
  final Color accent;
  final Offset blob1;
  final Offset blob2;
  _GlowPainter(this.accent, this.blob1, this.blob2);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
    p.color = accent.withOpacity(0.10);
    canvas.drawCircle(Offset(size.width * (0.5 + blob1.dx), size.height * (0.4 + blob1.dy)), size.width * 0.35, p);
    p.color = Colors.purpleAccent.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width * (0.4 + blob2.dx), size.height * (0.6 + blob2.dy)), size.width * 0.30, p);
  }
  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) => true;
}

class _GlassBar extends StatelessWidget {
  final Color accent;
  final ValueChanged<Color> onAccentChanged;
  final VoidCallback onOpenPalette;
  const _GlassBar({required this.accent, required this.onAccentChanged, required this.onOpenPalette});

  @override
  Widget build(BuildContext context) {
    final now = ValueNotifier<DateTime>(DateTime.now());
    // lightweight clock updater
    Future.microtask(() async {
      while (true) {
        await Future<void>.delayed(const Duration(seconds: 1));
        now.value = DateTime.now();
      }
    });

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(Icons.dashboard_customize, color: accent),
              const SizedBox(width: 8),
              const Text('SX Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              const Spacer(),
              // quick accent picker
              Row(
                children: [
                  _AccentDot(color: Colors.blueAccent, selected: accent == Colors.blueAccent, onTap: onAccentChanged),
                  _AccentDot(color: Colors.tealAccent.shade400, selected: accent == Colors.tealAccent.shade400, onTap: onAccentChanged),
                  _AccentDot(color: Colors.amberAccent, selected: accent == Colors.amberAccent, onTap: onAccentChanged),
                  _AccentDot(color: Colors.pinkAccent, selected: accent == Colors.pinkAccent, onTap: onAccentChanged),
                ],
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: onOpenPalette,
                icon: const Icon(Icons.search, color: Colors.white70, size: 18),
                label: const Text('Cmd', style: TextStyle(color: Colors.white70)),
                style: TextButton.styleFrom(foregroundColor: Colors.white70),
              ),
              const SizedBox(width: 12),
              ValueListenableBuilder<DateTime>(
                valueListenable: now,
                builder: (_, d, __) => Text(
                  '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white70, fontFeatures: [ui.FontFeature.tabularFigures()]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccentDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final ValueChanged<Color> onTap;
  const _AccentDot({required this.color, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        width: 18, height: 18, margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color, shape: BoxShape.circle,
          boxShadow: selected ? [BoxShadow(color: color.withOpacity(0.7), blurRadius: 12, spreadRadius: 1)] : null,
          border: Border.all(color: Colors.white.withOpacity(0.6), width: selected ? 2 : 1),
        ),
      ),
    );
  }
}

// 3D hover/tilt wrapper
class _InteractiveTileShell extends StatefulWidget {
  final Widget child;
  const _InteractiveTileShell({required this.child});
  @override
  State<_InteractiveTileShell> createState() => _InteractiveTileShellState();
}
class _InteractiveTileShellState extends State<_InteractiveTileShell> {
  bool _hover = false;
  double _x = 0.5, _y = 0.5;
  @override
  Widget build(BuildContext context) {
    final tiltX = _hover ? (_y - 0.5) * 0.06 : 0.0;
    final tiltY = _hover ? -(_x - 0.5) * 0.06 : 0.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      onHover: (e) {
        final size = context.size;
        if (size != null) {
          setState(() {
            _x = (e.localPosition.dx / size.width).clamp(0, 1);
            _y = (e.localPosition.dy / size.height).clamp(0, 1);
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(tiltX)
            ..rotateY(tiltY)
            ..scale(_hover ? 1.015 : 1.0),
          child: widget.child,
        ),
      ),
    );
  }
}

// Tile chrome with accent + highlight support
class _TileChrome extends StatelessWidget {
  final double? height;
  final Widget child;
  final bool highlight;
  final Color accent;
  const _TileChrome({this.height, required this.child, required this.accent, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0B0F1A), Color(0xFF111827)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: highlight ? Colors.amberAccent : Colors.white12,
            width: highlight ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(color: accent.withOpacity(0.15), blurRadius: 20, spreadRadius: 1),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );
  }
}
