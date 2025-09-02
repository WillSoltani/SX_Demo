// sxui/lib/app/Extensions/tab_properties.dart
import 'package:flutter/material.dart';
import 'package:sxui/app/theme/app_theme.dart'; // for AppPalette (success/warning/error/panels/border)

class TabProperties extends StatefulWidget {
  final String title;
  final Widget child;

  /// Close the tab/window.
  final VoidCallback? onClose;

  /// Minimize the tab/window (used by your MinimizedTabsBar).
  final VoidCallback? onMinimize;

  /// Optional: external maximize toggle. If not provided, an internal toggle is used.
  final VoidCallback? onToggleMaximize;

  const TabProperties({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
    this.onMinimize,
    this.onToggleMaximize,
  });

  @override
  State<TabProperties> createState() => _TabPropertiesState();
}

class _TabPropertiesState extends State<TabProperties> {
  bool _isMaximized = false;

  bool _hoverClose = false;
  bool _hoverMin = false;
  bool _hoverMax = false;

  void _toggleMax() {
    if (widget.onToggleMaximize != null) {
      widget.onToggleMaximize!();
    } else {
      setState(() => _isMaximized = !_isMaximized);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<AppPalette>()!;
    final cs = theme.colorScheme;

    // Root chrome (panel) uses theme panels & border — no hard-coded greys.
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.cardColor, // panel color (light: #F3F4F6, dark: #1E293B)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border), // subtle divider (#E5E7EB / #334155)
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.28)
                : Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header bar
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: palette.panelAlt, // layered panel (light: #E5E7EB, dark: #334155)
              border: Border(
                bottom: BorderSide(color: palette.border),
              ),
            ),
            child: Row(
              children: [
                // Traffic-light controls (semantic colors from palette)
                _ControlDot(
                  color: palette.error, // close
                  icon: Icons.close_rounded,
                  hovered: _hoverClose,
                  onEnter: () => setState(() => _hoverClose = true),
                  onExit: () => setState(() => _hoverClose = false),
                  onTap: widget.onClose,
                  tooltip: 'Close',
                ),
                const SizedBox(width: 6),
                _ControlDot(
                  color: palette.warning, // minimize
                  icon: Icons.remove_rounded,
                  hovered: _hoverMin,
                  onEnter: () => setState(() => _hoverMin = true),
                  onExit: () => setState(() => _hoverMin = false),
                  onTap: widget.onMinimize,
                  tooltip: 'Minimize',
                ),
                const SizedBox(width: 6),
                _ControlDot(
                  color: palette.success, // maximize / restore
                  icon: _isMaximized ? Icons.filter_none : Icons.crop_square_rounded,
                  hovered: _hoverMax,
                  onEnter: () => setState(() => _hoverMax = true),
                  onExit: () => setState(() => _hoverMax = false),
                  onTap: _toggleMax,
                  tooltip: _isMaximized ? 'Restore' : 'Maximize',
                ),

                const SizedBox(width: 12),
                // Title — uses header typography (Light: #111827, Dark: #F9FAFB)
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Optional affordance on the right (e.g., link color uses primary)
                Icon(Icons.drag_indicator, size: 16, color: cs.primary.withOpacity(0.66)),
              ],
            ),
          ),

          // Content area
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            color: theme.cardColor,
            constraints: _isMaximized
                ? const BoxConstraints(minHeight: 420) // give it more breathing room when "maximized"
                : const BoxConstraints(),
            child: DefaultTextStyle.merge(
              style: theme.textTheme.bodyMedium!, // Light body: #374151, Dark body: #94A3B8
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlDot extends StatelessWidget {
  final Color color;
  final IconData icon;
  final bool hovered;
  final VoidCallback? onTap;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;
  final String tooltip;

  const _ControlDot({
    required this.color,
    required this.icon,
    required this.hovered,
    required this.onTap,
    this.onEnter,
    this.onExit,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dot = AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: hovered
            ? [
                BoxShadow(
                  color: color.withOpacity(0.55),
                  blurRadius: 10,
                  spreadRadius: 0.5,
                ),
              ]
            : const [],
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? Colors.black.withOpacity(0.25)
              : Colors.white.withOpacity(0.65),
          width: hovered ? 1.6 : 1.0,
        ),
      ),
      child: AnimatedOpacity(
        opacity: hovered ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 120),
        child: Icon(icon, size: 12, color: Colors.white),
      ),
    );

    return MouseRegion(
      onEnter: (_) => onEnter?.call(),
      onExit: (_) => onExit?.call(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Tooltip(message: tooltip, child: dot),
      ),
    );
  }
}
