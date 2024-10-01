import 'package:flutter/material.dart';

class BoxX10 extends StatefulWidget {
  @override
  _BoxX10State createState() => _BoxX10State();
}

class _BoxX10State extends State<BoxX10> {
  // Store hover states for each API platform
  final List<bool> _isHovered = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[700], // Updated background color
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
        children: [
          // Centered Title for Box X10
          Text(
            '3D Cases',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          // 2x2 Grid for API Platforms
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 7, // Adjust aspect ratio to fit the items properly
              physics: NeverScrollableScrollPhysics(), // Prevent scrolling
              padding: EdgeInsets.zero, // Remove padding around GridView
              children: [
                // API Platform 1
                _buildApiPlatformTile(
                  context,
                  'APIPlatform1',
                  '/platform1',
                  Icons.api,
                  0, // Index for hover state tracking
                ),
                // API Platform 2
                _buildApiPlatformTile(
                  context,
                  'APIPlatform2',
                  '/platform2',
                  Icons.cloud,
                  1, // Index for hover state tracking
                ),
                // API Platform 3
                _buildApiPlatformTile(
                  context,
                  'APIPlatform3',
                  '/platform3',
                  Icons.network_check,
                  2, // Index for hover state tracking
                ),
                // API Platform 4
                _buildApiPlatformTile(
                  context,
                  'APIPlatform4',
                  '/platform4',
                  Icons.settings_input_antenna,
                  3, // Index for hover state tracking
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each API platform tile
  Widget _buildApiPlatformTile(
    BuildContext context,
    String title,
    String route,
    IconData icon,
    int index,
  ) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min, // Center the contents in the row
        children: [
          Icon(
            icon,
            color: Color(0xFF4B0082), // Darker purple color
          ),
          SizedBox(width: 8.0), // Spacing between icon and text
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
              cursor: SystemMouseCursors.click, // Change cursor to clickable
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: _isHovered[index] ? 24.0 : 18.4, // Increase font size on hover
                    color: _isHovered[index] ? Color(0xFF4B0082) : Colors.white, // Change color on hover
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
