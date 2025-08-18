// lib/app/dashboard/dialogs/size_picker.dart
import 'package:flutter/material.dart';
import '../models/tile_models.dart'; // contains TileSize

Future<TileSize?> pickTileSize(BuildContext context) async {
  return showDialog<TileSize>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Choose widget size',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SizeBtn(label: 'Small',  onTap: () => Navigator.pop(ctx, TileSize.small)),
                    _SizeBtn(label: 'Medium', onTap: () => Navigator.pop(ctx, TileSize.medium)),
                    _SizeBtn(label: 'Large',  onTap: () => Navigator.pop(ctx, TileSize.large)),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, null),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// Backward-compat wrapper if some code still calls showSizePickerDialog
Future<TileSize?> showSizePickerDialog(BuildContext context) => pickTileSize(context);

class _SizeBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SizeBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF182235),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
