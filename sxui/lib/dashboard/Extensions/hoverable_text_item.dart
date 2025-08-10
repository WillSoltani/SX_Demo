// File: lib/Extensions/hoverable_text_item.dart
// Author: Will
// Version: 1.1
// Revised: 06-10-2024
import 'package:flutter/material.dart';
import '../constants.dart';

class HoverableTextItem extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final double fontSize;
  final double hoverFontSize;
  final Color normalColor;
  final Color hoverColor;
  final Color hoverBackgroundColor;
  final Color splashColor;
  final EdgeInsets padding;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final Duration animationDuration;
  final bool autofocus;
  final FocusNode? focusNode;

  const HoverableTextItem({
    Key? key,
    required this.text,
    required this.onTap,
    this.icon,
    this.fontSize = 18.0,
    this.hoverFontSize = 22.0,
    this.normalColor = Colors.white,
    this.hoverColor =
        darkPurple, // Assuming darkPurple is defined in constants.dart
    this.hoverBackgroundColor = Colors.grey,
    this.splashColor = Colors.grey,
    this.padding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
    this.textAlign = TextAlign.left,
    this.fontWeight = FontWeight.bold,
    this.animationDuration = const Duration(milliseconds: 200),
    this.autofocus = false,
    this.focusNode,
  }) : super(key: key);

  @override
  _HoverableTextItemState createState() => _HoverableTextItemState();
}

class _HoverableTextItemState extends State<HoverableTextItem> {
  bool _isHovered = false;

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = _isHovered ? widget.hoverColor : widget.normalColor;
    final fontSize = _isHovered ? widget.hoverFontSize : widget.fontSize;

    return Semantics(
      button: true,
      label: widget.text,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHover: _handleHover,
          hoverColor: widget.hoverBackgroundColor.withOpacity(0.1),
          splashColor: widget.splashColor.withOpacity(0.2),
          focusColor: widget.hoverBackgroundColor.withOpacity(0.1),
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          child: AnimatedContainer(
            duration: widget.animationDuration,
            padding: widget.padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: Directionality.of(context),
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: color,
                    size: fontSize + 4,
                  ),
                  SizedBox(width: 12),
                ],
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: widget.animationDuration,
                    style: TextStyle(
                      color: color,
                      fontSize: fontSize,
                      fontWeight: widget.fontWeight,
                    ),
                    child: Text(
                      widget.text,
                      textAlign: widget.textAlign,
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
}
