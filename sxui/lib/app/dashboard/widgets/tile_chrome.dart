import 'package:flutter/material.dart';

class TileChrome extends StatelessWidget {
  final double height;
  final Widget child;
  final bool highlight;
  const TileChrome({super.key, required this.height, required this.child, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: height,
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
          boxShadow: highlight
              ? [BoxShadow(color: Colors.amberAccent.withOpacity(0.6), blurRadius: 20, spreadRadius: 2)]
              : [],
        ),
        child: Material(color: Colors.transparent, child: child),
      ),
    );
  }
}
