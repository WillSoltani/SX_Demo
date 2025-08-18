import 'package:flutter/material.dart';

Future<String?> promptDriverName(BuildContext context) async {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF0F1422),
      title: const Text('New Driver', style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: controller,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Enter driver name',
          hintStyle: TextStyle(color: Colors.white54),
        ),
        onSubmitted: (_) => Navigator.pop(ctx, controller.text.trim()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text('Create')),
      ],
    ),
  );
}
