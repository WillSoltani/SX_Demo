import 'package:flutter/material.dart';
import 'package:sxui/app/MainDashboard/data/widget_registry.dart';
import 'package:sxui/app/models/tile_size.dart';

class WidgetSizeView extends StatelessWidget {
  final WidgetOption option;
  final ValueChanged<TileSize> onSelect;

  const WidgetSizeView({super.key, required this.option, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B0F1A),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(option.icon, color: Colors.white70),
            const SizedBox(width: 8),
            Text('Add ${option.label}',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 16),
          const Text('Choose a size', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SizeCard(
                label: 'Small',
                subtitle: '1 × 1 tile',
                sizePreview: const Size(120, 90),
                onTap: () => onSelect(TileSize.small),
              ),
              _SizeCard(
                label: 'Medium',
                subtitle: '2 × 1 tiles',
                sizePreview: const Size(200, 90),
                onTap: () => onSelect(TileSize.medium),
              ),
              _SizeCard(
                label: 'Large',
                subtitle: '2 × 2 tiles',
                sizePreview: const Size(200, 180),
                onTap: () => onSelect(TileSize.large),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SizeCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final Size sizePreview;
  final VoidCallback onTap;
  const _SizeCard({
    required this.label,
    required this.subtitle,
    required this.sizePreview,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF111827),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 10),
            Container(
              width: sizePreview.width,
              height: sizePreview.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF0B0F1A),
                border: Border.all(color: Colors.white12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
