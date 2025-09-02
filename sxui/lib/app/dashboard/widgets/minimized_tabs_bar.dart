// lib/app/dashboard/widgets/minimized_tabs_bar.dart
import 'package:flutter/material.dart';
import 'package:sxui/app/shared/models/tab_item.dart';
import 'package:sxui/app/theme/app_theme.dart';

class MinimizedTabsBar extends StatelessWidget {
  final List<TabItem> tabs;
  final ValueChanged<String> onClose;
  final ValueChanged<String> onRestore;

  const MinimizedTabsBar({
    super.key,
    required this.tabs,
    required this.onClose,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final palette = theme.extension<AppPalette>()!;

    if (tabs.isEmpty) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.panel,
        border: Border.all(color: palette.border),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.25)
                : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: tabs.map((t) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: palette.panelAlt,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: palette.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tab, size: 14, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    t.title,
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => onRestore(t.id),
                    child: Icon(Icons.open_in_new, size: 14, color: theme.textTheme.labelSmall?.color),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => onClose(t.id),
                    child: Icon(Icons.close, size: 14, color: palette.textMuted),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
