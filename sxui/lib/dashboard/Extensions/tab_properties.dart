// File: tab_properties.dart

import 'package:flutter/material.dart';

class TabProperties extends StatefulWidget {
  final Widget child;
  final String title;
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onResize;

  const TabProperties({
    Key? key,
    required this.child,
    required this.title,
    required this.onClose,
    this.onMinimize,
    this.onResize,
  }) : super(key: key);

  @override
  _TabPropertiesState createState() => _TabPropertiesState();
}

class _TabPropertiesState extends State<TabProperties> {
  // Hover state variables for control buttons
  bool _isCloseButtonHovered = false;
  bool _isMinimizeButtonHovered = false;
  bool _isResizeButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
      backgroundColor: Colors.transparent, // Make dialog background transparent
      child: Container(
        width: 1200, // Tab size
        decoration: BoxDecoration(
          color: Colors.grey[900], // Background color
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjust height based on content
          children: [
            // Header with control buttons and title
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  // Control buttons with hover effects
                  Row(
                    children: [
                      // Close button
                      MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _isCloseButtonHovered = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _isCloseButtonHovered = false;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: AnimatedOpacity(
                            opacity: _isCloseButtonHovered ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 14,
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: widget.onClose,
                            ),
                          ),
                        ),
                      ),
                      // Minimize button
                      MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _isMinimizeButtonHovered = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _isMinimizeButtonHovered = false;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: AnimatedOpacity(
                            opacity: _isMinimizeButtonHovered ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 14,
                              icon: Icon(
                                Icons.minimize,
                                color: Colors.white,
                              ),
                              onPressed: widget.onMinimize,
                            ),
                          ),
                        ),
                      ),
                      // Resize button
                      MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _isResizeButtonHovered = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _isResizeButtonHovered = false;
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: AnimatedOpacity(
                            opacity: _isResizeButtonHovered ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 16,
                              icon: Icon(
                                Icons.crop_square,
                                color: Colors.white,
                              ),
                              onPressed: widget.onResize,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Spacer to center the title
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 24, // Slightly larger for better visibility
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Placeholder for alignment
                  SizedBox(width: 36),
                ],
              ),
            ),
            Divider(color: Colors.grey),
            // Child content
            widget.child,
          ],
        ),
      ),
    );
  }
}

