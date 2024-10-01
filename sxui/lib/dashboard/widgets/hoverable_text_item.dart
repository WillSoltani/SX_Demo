import 'package:flutter/material.dart';
import '../constants.dart';

class HoverableTextItem extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final double fontSize;
  final double hoverFontSize;

  const HoverableTextItem({
    required this.text,
    required this.onTap,
    this.icon,
    this.fontSize = 18.0,
    this.hoverFontSize = 22.0,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableTextItemState createState() => _HoverableTextItemState();
}

class _HoverableTextItemState extends State<HoverableTextItem> {
  bool _isHovered = false;

  static const Color normalColor = Colors.white;
  static const Color hoverColor = darkPurple; // Imported from constants.dart

  @override
  Widget build(BuildContext context) {
    final color = _isHovered ? hoverColor : normalColor;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            color: _isHovered ? Colors.grey[600] : Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null)
                  Icon(
                    widget.icon,
                    color: color,
                    size: widget.fontSize + 4,
                  ),
                if (widget.icon != null) SizedBox(width: 12),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: color,
                      fontSize: _isHovered ? widget.hoverFontSize : widget.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
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

