// Author: Will Soltani
// Version: 1.1
// Revised: 2025-08-17

// This widget displays a log of messages in a styled container.
// It shows uncompleted tasks first, then completed ones.
// Expects each log item to be a Map with:
//   'description': String
//   'completed'  : bool
//
// Example ValueNotifier payload:
// logMessages.value = [
//   {'description': 'Created order #123', 'completed': false},
//   {'description': 'Emailed invoice', 'completed': true},
// ];

import 'package:flutter/material.dart';

class Log extends StatelessWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;

  const Log({Key? key, required this.logMessages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[900]!, width: 1.5),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Log Box',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: logMessages,
              builder: (context, messages, _) {
                // Defensive copies + safe parsing
                final items = List<Map<String, dynamic>>.from(messages);

                // Partition into uncompleted/completed
                final uncompleted = <Map<String, dynamic>>[];
                final completed = <Map<String, dynamic>>[];

                for (final m in items) {
                  final bool isDone = (m['completed'] is bool) ? m['completed'] as bool : false;
                  (isDone ? completed : uncompleted).add(m);
                }

                final sorted = [...uncompleted, ...completed];

                if (sorted.isEmpty) {
                  return Center(
                    child: Text(
                      'No log messages yet',
                      style: TextStyle(color: Colors.white.withOpacity(0.75)),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: sorted.length,
                  itemBuilder: (context, index) {
                    final m = sorted[index];
                    final String desc = (m['description']?.toString() ?? '').trim();
                    final bool isDone = (m['completed'] is bool) ? m['completed'] as bool : false;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDone ? Colors.white70 : Colors.white60,
                          width: 1.5,
                        ),
                        color: isDone ? Colors.white.withOpacity(0.02) : Colors.transparent,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 16,
                            color: isDone ? Colors.greenAccent : Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              desc.isEmpty ? '(no description)' : desc,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: isDone ? FontWeight.normal : FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
