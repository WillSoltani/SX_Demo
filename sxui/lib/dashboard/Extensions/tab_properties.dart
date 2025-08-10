// File: lib/Extensions/tab_properties.dart
// Author: Will
// Version: 1.1
// Revised: 06-10-2024
import 'package:flutter/material.dart';

class TabProperties extends StatefulWidget {
  final Widget child;
  final String title;
  final VoidCallback onClose;
  final VoidCallback onMinimize;

  const TabProperties({
    Key? key,
    required this.title,
    required this.onClose,
    required this.onMinimize,
    required this.child,
  }) : super(key: key);

  @override
  _TabPropertiesState createState() => _TabPropertiesState();
}

class _TabPropertiesState extends State<TabProperties> {
  bool _isCloseButtonHovered = false;
  bool _isMinimizeButtonHovered = false;
  bool _isResizeButtonHovered = false;
  bool _isMaximized = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(12.0), // Apply rounding to all corners
        child: Container(
          width: _isMaximized
              ? MediaQuery.of(context)
                  .size
                  .width // Make it full-screen horizontally
              : MediaQuery.of(context).size.width * 0.45, // Default width
          height: _isMaximized
              ? MediaQuery.of(context)
                  .size
                  .height // Make it full-screen vertically
              : _getTabHeight(), // Adjust height dynamically
          decoration: BoxDecoration(
            color: Colors.grey[900], // Background color
            borderRadius:
                BorderRadius.circular(12.0), // Rounded edges including bottom
            boxShadow: [
              if (!_isMaximized)
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            children: [
              // Header with control buttons and title
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    _buildControlButtons(),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize:
                                24, // Slightly larger for better visibility
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 36), // Spacer for alignment
                  ],
                ),
              ),
              Divider(color: Colors.grey),
              // Child content
              Expanded(
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Adjust height based on the tab title (20% smaller for Add Customer and Add Product)
  double _getTabHeight() {
    if (widget.title == 'Add Customer' || widget.title == 'Add Product') {
      return MediaQuery.of(context).size.height * 0.62; // 20% smaller height
    }
    return MediaQuery.of(context).size.height * 0.75; // Default height
  }

  // Build control buttons (close, minimize, resize)
  Widget _buildControlButtons() {
    return Row(
      children: [
        _buildControlButton(
          isHovered: _isCloseButtonHovered,
          onTap: widget.onClose,
          color: Colors.red,
          icon: Icons.close,
          onHoverChange: (hovered) {
            setState(() {
              _isCloseButtonHovered = hovered;
            });
          },
        ),
        _buildControlButton(
          isHovered: _isMinimizeButtonHovered,
          onTap: widget.onMinimize,
          color: Colors.yellow[700]!,
          icon: Icons.minimize,
          onHoverChange: (hovered) {
            setState(() {
              _isMinimizeButtonHovered = hovered;
            });
          },
        ),
        _buildControlButton(
          isHovered: _isResizeButtonHovered,
          onTap: () {
            setState(() {
              _isMaximized = !_isMaximized;
            });
          },
          color: Colors.green,
          icon: _isMaximized ? Icons.crop_square : Icons.crop_din,
          onHoverChange: (hovered) {
            setState(() {
              _isResizeButtonHovered = hovered;
            });
          },
        ),
      ],
    );
  }

  // Utility function to build a control button with hover effects
  Widget _buildControlButton({
    required bool isHovered,
    required VoidCallback onTap,
    required Color color,
    required IconData icon,
    required Function(bool) onHoverChange,
  }) {
    return MouseRegion(
      onEnter: (_) => onHoverChange(true),
      onExit: (_) => onHoverChange(false),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: isHovered
              ? Icon(
                  icon,
                  color: Colors.white,
                  size: 14,
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
