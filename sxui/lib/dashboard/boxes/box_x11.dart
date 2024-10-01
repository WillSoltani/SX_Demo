import 'package:flutter/material.dart';

class BoxX11 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[700], // Background color
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space out the children vertically
        children: [
          // Title: "Incoming"
          Text(
            'Incoming',
            style: TextStyle(
              fontSize: 28, // Larger font size for the title
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0), // Adjusted spacing

          // Incoming Cases Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center row content horizontally
            children: [
              Icon(
                Icons.inbox, // Incoming cases icon
                color: Color(0xFF4B0082), // Dark purple color for the icon
                size: 40.0, // Increased icon size
              ),
              SizedBox(width: 12.0), // Adjusted spacing between icon and number
              Text(
                '36', // Number of incoming cases
                style: TextStyle(
                  fontSize: 32, // Increased font size for the number
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0), // Adjusted spacing between incoming and outgoing sections

          // Outgoing Section Title
          Text(
            'Outgoing',
            style: TextStyle(
              fontSize: 28, // Larger font size for the title
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0), // Adjusted spacing

          // Outgoing Cases Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center row content horizontally
            children: [
              Icon(
                Icons.outbox, // Outgoing cases icon
                color: Color(0xFF4B0082), // Dark purple color for the icon
                size: 40.0, // Increased icon size
              ),
              SizedBox(width: 12.0), // Adjusted spacing between icon and number
              Text(
                '48', // Number of outgoing cases
                style: TextStyle(
                  fontSize: 32, // Increased font size for the number
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
