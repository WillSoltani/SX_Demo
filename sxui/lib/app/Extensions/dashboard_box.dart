// Author: Will
// Version: 1.0
// Revised: 06-10-2024
import 'package:flutter/material.dart';

class DashboardBox extends StatelessWidget {
  final Widget child;

  const DashboardBox({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
