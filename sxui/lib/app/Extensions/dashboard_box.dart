// sxui/lib/app/Extensions/dashboard_box.dart
import 'package:flutter/material.dart';
import 'package:sxui/app/theme/app_theme.dart'; // for AppPalette

class DashboardBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const DashboardBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.margin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<AppPalette>()!;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.cardColor,                         // was Colors.grey[900] / etc.
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),      // subtle divider
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.25)
                : Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: DefaultTextStyle.merge(
        style: theme.textTheme.bodyMedium!,             // text adopts Light/Dark roles
        child: child,
      ),
    );
  }
}
