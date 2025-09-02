// lib/app/dashboard/widgets/glass_bar.dart
import 'package:flutter/material.dart';

class GlassBar extends StatelessWidget {
  final Color accent;
  final ValueChanged<Color> onAccentChanged; // kept for compatibility (unused now)
  final VoidCallback onOpenPalette;          // opens Cmd dropdown
  final VoidCallback onLogoTap;              // widget picker
  final GlobalKey? cmdAnchorKey;             // to anchor the Cmd menu
  final ThemeMode themeMode;                 // NEW
  final ValueChanged<ThemeMode> onThemeModeChanged; // NEW

  const GlassBar({
    super.key,
    required this.accent,
    required this.onAccentChanged,
    required this.onOpenPalette,
    required this.onLogoTap,
    this.cmdAnchorKey,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final palette = Theme.of(context).extension<ThemeExtension>() as Object?;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: cs.surface.withOpacity(0.6),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.6)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // Clickable SX logo + title
            GestureDetector(
              onTap: onLogoTap,
              child: Row(
                children: [
                  Icon(Icons.dashboard_customize, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    'SX Dashboard',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineMedium?.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // === Theme toggle (replaces the 4 colored dots) ===
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _ThemeChip(
                    label: 'Light',
                    icon: Icons.wb_sunny_outlined,
                    selected: themeMode == ThemeMode.light,
                    onTap: () => onThemeModeChanged(ThemeMode.light),
                  ),
                  _ThemeChip(
                    label: 'Dark',
                    icon: Icons.nights_stay_outlined,
                    selected: themeMode == ThemeMode.dark,
                    onTap: () => onThemeModeChanged(ThemeMode.dark),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Cmd button (anchors popup at this key)
            SizedBox(
              key: cmdAnchorKey,
              height: 36,
              child: TextButton.icon(
                onPressed: onOpenPalette,
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Cmd'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ThemeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? cs.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: selected ? cs.primary : Theme.of(context).textTheme.bodyMedium?.color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? cs.primary : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
