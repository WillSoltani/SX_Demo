import 'package:flutter/material.dart';
import '../constants.dart';

class HoverableIconTextItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color iconColor;
  final Color hoverIconColor;
  final double iconSize;
  final double hoverIconSize;
  final Color textColor;
  final Color hoverTextColor;
  final double textFontSize;
  final double hoverTextFontSize;

  const HoverableIconTextItem({
    required this.icon,
    required this.text,
    required this.onTap,
    required this.iconColor,
    required this.hoverIconColor,
    required this.iconSize,
    required this.hoverIconSize,
    required this.textColor,
    required this.hoverTextColor,
    required this.textFontSize,
    required this.hoverTextFontSize,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableIconTextItemState createState() => _HoverableIconTextItemState();
}

class _HoverableIconTextItemState extends State<HoverableIconTextItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                widget.icon,
                color: _isHovered ? widget.hoverIconColor : widget.iconColor,
                size: _isHovered ? widget.hoverIconSize : widget.iconSize,
              ),
            ),
            SizedBox(height: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: _isHovered ? widget.hoverTextColor : widget.textColor,
                fontSize: _isHovered ? widget.hoverTextFontSize : widget.textFontSize,
                fontWeight: FontWeight.bold,
              ),
              child: Text(widget.text),
            ),
          ],
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

