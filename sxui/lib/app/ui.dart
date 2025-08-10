import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// Your existing widgets (keep these imports)
import 'package:sxui/app/Widgits/Billing/Billing.dart';
import 'package:sxui/app/MainDashboard/mainDash_Widget.dart';
import 'package:sxui/app/Widgits/Setting/setting.dart';
import 'package:sxui/app/Widgits/SalesSummary/salesSum.dart';
import 'package:sxui/app/Widgits/Search/search.dart';
import 'package:sxui/app/Widgits/Drivers/driver1.dart';
import 'package:sxui/app/Widgits/Drivers/driver2.dart';
import 'package:sxui/app/Widgits/Drivers/driver3.dart';
import 'package:sxui/app/Widgits/Drivers/driver4.dart';
import 'package:sxui/app/Widgits/Drivers/driverSum.dart';
import 'package:sxui/app/Widgits/Integrations/Integrations.dart';
import 'package:sxui/app/Widgits/Calendar/calendar.dart';
import 'package:sxui/app/Widgits/Log/log.dart';
import 'package:sxui/app/MainDashboard/Subs/Customers/add_customer.dart';
import 'package:sxui/app/Extensions/tab_properties.dart';
import 'package:sxui/app/Extensions/dashboard_box.dart';
import 'package:sxui/app/models/tab_item.dart';

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

class _DashboardPageState extends State<DashboardPage> {
  // Used by some of your tiles
  final ValueNotifier<List<Map<String, dynamic>>> logMessages =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  // Reorderable tiles
  late List<TileData> _tiles;
  int? _draggingIndex;

  @override
  void initState() {
    super.initState();
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
  }

  // ---- Reordering helpers ----
  void _swap(int from, int to) {
    if (from == to || from < 0 || to < 0) return;
    final item = _tiles.removeAt(from);
    _tiles.insert(to, item);
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

  // ---- Optional: use your existing Tab API as-is ----
  final List<TabItem> openTabs = [];
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

  // ---------- Fit-to-viewport helpers (no overflow, auto-rescale) ----------
  double _baseHeight(TileSize s, double colW) {
    switch (s) {
      case TileSize.small:  return colW * 0.75;
      case TileSize.medium: return colW * 1.20;
      case TileSize.large:  return colW * 1.85;
    }
  }

  int _minIndex(List<double> a) {
    var mi = 0; var mv = a[0];
    for (var i = 1; i < a.length; i++) { if (a[i] < mv) { mi = i; mv = a[i]; } }
    return mi;
  }

  // predict tallest column height for current tiles
  double _predictedTallest({
    required int cols,
    required double gridWidth,
    required double gap,
    required double reserveBottom,
  }) {
    final colW = (gridWidth - gap * (cols + 1)) / cols;
    final heights = List<double>.filled(cols, 0);
    for (final t in _tiles) {
      final h = _baseHeight(t.size, colW) + gap;
      heights[_minIndex(heights)] += h;
    }
    final tallest = heights.reduce((a, b) => a > b ? a : b);
    return tallest + gap + reserveBottom; // top/bottom padding + reserved bar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width  = constraints.maxWidth;
            final height = constraints.maxHeight;
            const gap = 12.0;

            // Dynamic column count based on screen width
            final cols = (width / 320).floor().clamp(3, 8);

            // If minimized tabs bar is visible, reserve some space
            final hasMiniBar   = openTabs.any((t) => t.isMinimized);
            final reserveBottom = hasMiniBar ? 70.0 : 0.0;

            // compute required height and scale to fit viewport
            final needed = _predictedTallest(
              cols: cols, gridWidth: width, gap: gap, reserveBottom: reserveBottom,
            );
            final scale = (height / needed).clamp(0.5, 1.0);

            final columnWidth = (width - gap * (cols + 1)) / cols;

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(gap),
                  child: MasonryGridView.count(
                    // lock to one screen; we do our own scaling to avoid overflow
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,

                    crossAxisCount: cols,
                    mainAxisSpacing: gap,
                    crossAxisSpacing: gap,
                    itemCount: _tiles.length,
                    itemBuilder: (context, index) {
                      final tile   = _tiles[index];
                      final height = _baseHeight(tile.size, columnWidth) * scale;

                      final chrome = _TileChrome(
                        height: height,
                        // unify icon/text scale with tile width and global scale
                        child: IconTheme(
                          data: IconThemeData(size: (columnWidth * 0.08 * scale).clamp(12, 28)),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: (columnWidth * 0.05 * scale).clamp(11, 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                            child: tile.builder(context),
                          ),
                        ),
                      );

                      final widgetCard = GestureDetector(
                        onDoubleTap: () => _cycleSize(index), // resize on double tap (S/M/L)
                        child: chrome,
                      );

                      // drag & drop to swap tiles
                      return LongPressDraggable<int>(
                        data: index,
                        onDragStarted: () => setState(() => _draggingIndex = index),
                        onDragEnd: (_)   => setState(() => _draggingIndex = null),
                        feedback: Material(
                          color: Colors.transparent,
                          child: Opacity(opacity: 0.9, child: widgetCard),
                        ),
                        childWhenDragging: Opacity(opacity: 0.25, child: widgetCard),
                        child: DragTarget<int>(
                          onWillAccept: (from) => from != index,
                          onAccept:    (from) => setState(() => _swap(from!, index)),
                          builder: (context, candidate, rejected) {
                            final hovering = candidate.isNotEmpty;
                            return AnimatedScale(
                              scale: hovering ? 0.98 : 1.0,
                              duration: const Duration(milliseconds: 120),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 120),
                                decoration: BoxDecoration(
                                  boxShadow: hovering
                                      ? [BoxShadow(
                                          color: Colors.blue.withOpacity(0.25),
                                          blurRadius: 12, spreadRadius: 2)]
                                      : [],
                                ),
                                child: widgetCard,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Minimized tabs bar (kept from your original UI)
                if (hasMiniBar)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: _buildMinimizedTabsBar(context),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --------- Minimized tabs bar (as in your original) ----------
  Widget _buildMinimizedTabsBar(BuildContext context) {
    final minimizedTabs = openTabs.where((t) => t.isMinimized).toList();
    if (minimizedTabs.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, -2)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.5,
      ),
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

// Simple chrome wrapper for tiles (rounded corners, background)
class _TileChrome extends StatelessWidget {
  final double height;
  final Widget child;
  const _TileChrome({required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0B0F1A), Color(0xFF111827)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white12),
        ),
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}
