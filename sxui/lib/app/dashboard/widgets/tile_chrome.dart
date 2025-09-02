// lib/app/dashboard/widgets/tile_chrome.dart
import 'package:flutter/material.dart';
import 'package:sxui/app/theme/app_theme.dart'; // for AppPalette

class TileChrome extends StatelessWidget {
  final double height;
  final Widget child;

  const TileChrome({
    super.key,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<AppPalette>()!;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.cardColor,                 // panel color per mode
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border.withOpacity(0.8)), // subtle dividers
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.25)
                : Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: DefaultTextStyle.merge(
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.textTheme.bodyMedium!.color ?? cs.onSurface,
        ),
        child: child,
      ),
    );
  }
}
