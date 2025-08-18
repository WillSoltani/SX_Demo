// Author: Will Soltani
// Version: 1.0
// Revised: 30-09-2024

// This widget, BoxX10, displays a 3D Cases dashboard with a grid of API platforms.
// Users can interact with each API platform tile, which changes its appearance on hover and navigates to a specified route when clicked.

import 'package:flutter/material.dart';

class Integrations extends StatefulWidget {
  @override
  _BoxX10State createState() => _BoxX10State();
}

class _BoxX10State extends State<Integrations> {
  // Store hover states for each API platform.
  final List<bool> _isHovered = [false, false, false, false];

  /// Builds the main layout of the widget, including the title and a 2x2 grid of API platform tiles.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '3D Cases',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 7,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _buildApiPlatformTile(
                    context, 'APIPlatform1', '/platform1', Icons.api, 0),
                _buildApiPlatformTile(
                    context, 'APIPlatform2', '/platform2', Icons.cloud, 1),
                _buildApiPlatformTile(context, 'APIPlatform3', '/platform3',
                    Icons.network_check, 2),
                _buildApiPlatformTile(context, 'APIPlatform4', '/platform4',
                    Icons.settings_input_antenna, 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build each API platform tile with hover effects and navigation.
  ///
  /// - **context**: The build context for rendering.
  /// - **title**: The text label of the API platform.
  /// - **route**: The route to navigate to when the tile is clicked.
  /// - **icon**: The icon to display next to the text.
  /// - **index**: The index used to track the hover state in `_isHovered`.
  Widget _buildApiPlatformTile(
    BuildContext context,
    String title,
    String route,
    IconData icon,
    int index,
  ) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Color(0xFF4B0082),
          ),
          SizedBox(width: 8.0),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, route);
            },
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovered[index] = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovered[index] = false;
                });
              },
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: _isHovered[index] ? 24.0 : 18.4,
                    color: _isHovered[index] ? Color(0xFF4B0082) : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
