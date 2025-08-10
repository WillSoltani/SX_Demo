import 'package:flutter/material.dart';

class FlaggedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flagged'),
      ),
      body: Center(
        child: Text(
          'Flagged Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

