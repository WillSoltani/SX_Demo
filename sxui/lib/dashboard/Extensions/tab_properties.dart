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
  // Hover state variables for control buttons
  bool _isCloseButtonHovered = false;
  bool _isMinimizeButtonHovered = false;
  bool _isResizeButtonHovered = false;

  // State variable for maximize
  bool _isMaximized = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: _isMaximized
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.45,
        height: _isMaximized
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.grey[900], // Background color
          borderRadius: _isMaximized ? null : BorderRadius.circular(12.0),
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
                        child: GestureDetector(
                          onTap: widget.onClose,
                          child: Container(
                            width: 20,
                            height: 20,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: _isCloseButtonHovered
                                ? Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : SizedBox(),
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
                        child: GestureDetector(
                          onTap: widget.onMinimize,
                          child: Container(
                            width: 20,
                            height: 20,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              shape: BoxShape.circle,
                            ),
                            child: _isMinimizeButtonHovered
                                ? Icon(
                                    Icons.minimize,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : SizedBox(),
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
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isMaximized = !_isMaximized;
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: _isResizeButtonHovered
                                ? Icon(
                                    _isMaximized
                                        ? Icons.crop_square // Restore icon
                                        : Icons.crop_din, // Maximize icon
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Spacer
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
            Expanded(
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
