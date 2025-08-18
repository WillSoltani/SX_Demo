// File: lib/Extensions/hoverable_expanded_item.dart

// Author: Will
// Version: 1.1
// Revised: 07-10-2024

import 'package:flutter/material.dart';
import 'package:sxui/app/shared/constants.dart';

class HoverableExpandedItem extends StatefulWidget {
  final String text;
  final IconData? icon; // Added optional icon parameter
  final VoidCallback onTap;
  final double fontSize;
  final double hoverFontSize;
  final Color normalColor;
  final Color hoverColor;
  final FontWeight fontWeight;
  final FontWeight hoverFontWeight;
  final Duration animationDuration;
  final EdgeInsets padding;
  final TextAlign textAlign;
  final Color hoverBackgroundColor;
  final Color splashColor;
  final bool autofocus;
  final FocusNode? focusNode;

  const HoverableExpandedItem({
    Key? key,
    required this.text,
    this.icon, // Accept icon
    required this.onTap,
    this.fontSize = 32.0,
    this.hoverFontSize = 36.0,
    this.normalColor = darkPurple,
    this.hoverColor = Colors.white,
    this.fontWeight = FontWeight.bold,
    this.hoverFontWeight = FontWeight.bold,
    this.animationDuration = const Duration(milliseconds: 200),
    this.padding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
    this.textAlign = TextAlign.center,
    this.hoverBackgroundColor = Colors.transparent,
    this.splashColor = Colors.grey,
    this.autofocus = false,
    this.focusNode,
  }) : super(key: key);

  @override
  _HoverableExpandedItemState createState() => _HoverableExpandedItemState();
}

class _HoverableExpandedItemState extends State<HoverableExpandedItem> {
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
    final fontWeight = _isHovered ? widget.hoverFontWeight : widget.fontWeight;

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
            child: AnimatedDefaultTextStyle(
              duration: widget.animationDuration,
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: color,
                      size: fontSize,
                    ),
                    SizedBox(width: 8.0),
                  ],
                  Text(
                    widget.text,
                    textAlign: widget.textAlign,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
