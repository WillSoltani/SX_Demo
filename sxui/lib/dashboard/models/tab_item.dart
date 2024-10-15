// File: lib/models/tab_item.dart
// Author: Will
// Version: 1.0
// Revised: 06-10-2024

import 'package:flutter/material.dart';

class TabItem {
  final String id;
  final String title;
  final Widget content;
  bool isMinimized;
  bool isMaximized;
  bool isHovered;

  TabItem({
    required this.id,
    required this.title,
    required this.content,
    this.isMinimized = false,
    this.isMaximized = false,
    this.isHovered = false,
  });
}
