import 'package:flutter/material.dart';

class SubItemPage extends StatelessWidget {
  final String subItem;

  const SubItemPage({required this.subItem, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subItem),
      ),
      body: Center(
        child: Text(
          '$subItem Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
