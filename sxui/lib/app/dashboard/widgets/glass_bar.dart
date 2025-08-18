// lib/app/dashboard/widgets/glass_bar.dart
import 'package:flutter/material.dart';

class GlassBar extends StatelessWidget {
  final Color accent;
  final ValueChanged<Color> onAccentChanged;
  final VoidCallback onOpenPalette;
  final VoidCallback onLogoTap;

  const GlassBar({
    super.key,
    required this.accent,
    required this.onAccentChanged,
    required this.onOpenPalette,
    required this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // Clickable SX logo + title
            GestureDetector(
              onTap: onLogoTap,
              child: Row(
                children: [
                  Icon(Icons.dashboard_customize, color: accent),
                  const SizedBox(width: 8),
                  const Text(
                    'SX Dashboard',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Accent color dots
            Row(
              children: [
                _AccentDot(
                  color: Colors.blueAccent,
                  selected: accent == Colors.blueAccent,
                  onTap: onAccentChanged,
                ),
                _AccentDot(
                  color: Colors.tealAccent.shade400,
                  selected: accent == Colors.tealAccent.shade400,
                  onTap: onAccentChanged,
                ),
                _AccentDot(
                  color: Colors.amberAccent,
                  selected: accent == Colors.amberAccent,
                  onTap: onAccentChanged,
                ),
                _AccentDot(
                  color: Colors.pinkAccent,
                  selected: accent == Colors.pinkAccent,
                  onTap: onAccentChanged,
                ),
              ],
            ),
            const SizedBox(width: 12),
            TextButton.icon(
              onPressed: onOpenPalette,
              icon: const Icon(Icons.search, color: Colors.white70, size: 18),
              label: const Text('Cmd', style: TextStyle(color: Colors.white70)),
              style: TextButton.styleFrom(foregroundColor: Colors.white70),
            ),
          ],
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
        width: 18,
        height: 18,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: selected
              ? [BoxShadow(color: color.withOpacity(0.7), blurRadius: 12, spreadRadius: 1)]
              : null,
          border: Border.all(color: Colors.white.withOpacity(0.6), width: selected ? 2 : 1),
        ),
      ),
    );
  }
}
