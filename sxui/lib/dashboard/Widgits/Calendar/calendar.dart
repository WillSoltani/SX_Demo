// Author: Will Soltani
// Version: 1.0
// Revised: 30-09-2024

// This widget, BoxX12, displays an "Advanced Calendar" within a stylized container.
// The calendar functionality is provided by the `AdvancedCalendar` widget, which receives log messages to display or interact with.

import 'package:flutter/material.dart';
import '../../Extensions/advanced_calendar.dart'; // Import the advanced calendar.

class BoxX12 extends StatelessWidget {
  final ValueNotifier<List<Map<String, dynamic>>>
      logMessages; // A notifier for log messages.

  const BoxX12({Key? key, required this.logMessages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: Colors.grey[700],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AdvancedCalendar(logMessages: logMessages),
        ),
      ),
    );
  }
}
