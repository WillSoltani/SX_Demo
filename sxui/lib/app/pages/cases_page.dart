import 'package:flutter/material.dart';

class CasesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cases'),
      ),
      body: Center(
        child: Text(
          'Cases Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

