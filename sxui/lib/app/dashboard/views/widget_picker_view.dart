import 'package:flutter/material.dart';
import 'package:sxui/app/MainDashboard/data/widget_registry.dart';

Future<void> showWidgetPicker({
  required BuildContext context,
  required List<WidgetOption> options,
  required ValueChanged<WidgetOption> onSelect,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        backgroundColor: const Color(0xFF0F1422),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 560),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add a widget',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (_, i) {
                      final opt = options[i];
                      return ListTile(
                        leading: Icon(opt.icon, color: Colors.white70),
                        title: Text(opt.label, style: const TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.of(ctx).pop();
                          onSelect(opt);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
