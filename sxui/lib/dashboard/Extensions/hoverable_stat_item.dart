// File: lib/Extensions/hoverable_stat_item.dart
// Author: Will
// Version: 1.1
// Revised: 06-10-2024
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
  final FontWeight numberFontWeight;
  final FontWeight labelFontWeight;
  final Duration animationDuration;
  final EdgeInsets padding;
  final Alignment alignment;
  final Color hoverBackgroundColor;
  final Color splashColor;
  final bool autofocus;
  final FocusNode? focusNode;

  const HoverableStatItem({
    Key? key,
    required this.number,
    required this.label,
    required this.onTap,
    this.numberColor = Colors.white,
    this.hoverNumberColor =
        darkPurple, // Assuming darkPurple is defined in constants.dart
    this.labelColor = Colors.white70,
    this.hoverLabelColor = darkPurple,
    this.numberFontSize = 24.0,
    this.hoverNumberFontSize = 28.0,
    this.labelFontSize = 16.0,
    this.hoverLabelFontSize = 18.0,
    this.numberFontWeight = FontWeight.bold,
    this.labelFontWeight = FontWeight.normal,
    this.animationDuration = const Duration(milliseconds: 200),
    this.padding = const EdgeInsets.all(8.0),
    this.alignment = Alignment.center,
    this.hoverBackgroundColor = Colors.grey,
    this.splashColor = Colors.grey,
    this.autofocus = false,
    this.focusNode,
  }) : super(key: key);

  @override
  _HoverableStatItemState createState() => _HoverableStatItemState();
}

class _HoverableStatItemState extends State<HoverableStatItem> {
  bool _isHovered = false;

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final numberColor =
        _isHovered ? widget.hoverNumberColor : widget.numberColor;
    final labelColor = _isHovered ? widget.hoverLabelColor : widget.labelColor;
    final numberFontSize =
        _isHovered ? widget.hoverNumberFontSize : widget.numberFontSize;
    final labelFontSize =
        _isHovered ? widget.hoverLabelFontSize : widget.labelFontSize;

    return Semantics(
      button: true,
      label: '${widget.number} ${widget.label}',
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
            alignment: widget.alignment,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: widget.animationDuration,
                  style: TextStyle(
                    color: numberColor,
                    fontSize: numberFontSize,
                    fontWeight: widget.numberFontWeight,
                  ),
                  child: Text(widget.number),
                ),
                SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: widget.animationDuration,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: labelFontSize,
                    fontWeight: widget.labelFontWeight,
                  ),
                  child: Text(widget.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
