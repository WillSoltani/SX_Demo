// Author: Will Soltani
// Version: 1.0
// Revised: 30-09-2024

// This widget, BoxX13, displays a log of messages in a styled container.
// It shows both uncompleted and completed tasks, with a distinction in appearance between them.
//
// - **logMessages**: A ValueNotifier that holds a list of structured log messages.
// - **build**: The main build function that sets up the container and displays the log messages using a ValueListenableBuilder.

import 'package:flutter/material.dart';

class BoxX13 extends StatelessWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;

  BoxX13({Key? key, required this.logMessages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[900]!, width: 1.5),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Log Box',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: logMessages,
              builder: (context, messages, _) {
                // Sort and filter messages based on their completion status.
                final uncompletedTasks =
                    messages.where((message) => !message['completed']).toList();
                final completedTasks =
                    messages.where((message) => message['completed']).toList();
                final sortedMessages = [...uncompletedTasks, ...completedTasks];

                return ListView.builder(
                  itemCount: sortedMessages.length,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: sortedMessages[index]['completed']
                              ? Colors.white70
                              : Colors.white60,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        sortedMessages[index]['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: sortedMessages[index]['completed']
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
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
