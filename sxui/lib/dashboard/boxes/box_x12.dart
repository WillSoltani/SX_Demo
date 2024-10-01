import 'package:flutter/material.dart';
import 'advanced_calendar.dart'; // Import the advanced calendar

class BoxX12 extends StatelessWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages; // Updated type

  const BoxX12({Key? key, required this.logMessages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0), // Apply rounded corners
      child: Container(
        color: Colors.grey[700], // Dark grey background color
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add some padding
          child: AdvancedCalendar(logMessages: logMessages), // Pass logMessages to the calendar
        ),
      ),
    );
  }
}
