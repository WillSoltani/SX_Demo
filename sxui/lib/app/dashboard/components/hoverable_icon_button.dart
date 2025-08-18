import 'package:flutter/material.dart';
import 'package:sxui/app/constants.dart';


class HoverableIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const HoverableIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<HoverableIconButton> createState() => _HoverableIconButtonState();
}

class _HoverableIconButtonState extends State<HoverableIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered ? darkPurple.withOpacity(0.1) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? darkPurple : Colors.black,
            size: 28,
          ),
        ),
      ),
    );
  }

  void _setHover(bool v) => setState(() => _isHovered = v);
}