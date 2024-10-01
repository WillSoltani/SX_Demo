import 'package:flutter/material.dart';
import '../constants.dart';

class HoverableStatItem extends StatefulWidget {
  final String number;
  final String label;
  final VoidCallback onTap;
  final Color numberColor;
  final Color hoverNumberColor;
  final Color labelColor;
  final Color hoverLabelColor;
  final double numberFontSize;
  final double hoverNumberFontSize;
  final double labelFontSize;
  final double hoverLabelFontSize;

  const HoverableStatItem({
    required this.number,
    required this.label,
    required this.onTap,
    required this.numberColor,
    required this.hoverNumberColor,
    required this.labelColor,
    required this.hoverLabelColor,
    required this.numberFontSize,
    required this.hoverNumberFontSize,
    required this.labelFontSize,
    required this.hoverLabelFontSize,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableStatItemState createState() => _HoverableStatItemState();
}

class _HoverableStatItemState extends State<HoverableStatItem> {
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
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: _isHovered ? widget.hoverNumberColor : widget.numberColor,
                fontSize: _isHovered ? widget.hoverNumberFontSize : widget.numberFontSize,
                fontWeight: FontWeight.bold,
              ),
              child: Text(widget.number),
            ),
            SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: _isHovered ? widget.hoverLabelColor : widget.labelColor,
                fontSize: _isHovered ? widget.hoverLabelFontSize : widget.labelFontSize,
              ),
              child: Text(widget.label),
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

