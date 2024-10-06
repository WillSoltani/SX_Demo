import 'package:flutter/material.dart';
import '../constants.dart';

class HoverableExpandedItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double fontSize;
  final double hoverFontSize;

  const HoverableExpandedItem({
    required this.text,
    required this.onTap,
    this.fontSize = 32.0,
    this.hoverFontSize = 36.0,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableExpandedItemState createState() => _HoverableExpandedItemState();
}

class _HoverableExpandedItemState extends State<HoverableExpandedItem> {
  bool _isHovered = false;

  static const Color normalColor = darkPurple; // Imported from constants.dart
  static const Color hoverColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final color = _isHovered ? hoverColor : normalColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: color,
            fontSize: _isHovered ? widget.hoverFontSize : widget.fontSize,
            fontWeight: FontWeight.bold,
          ),
          child: Center(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}

