// lib/app/dashboard/dialogs/widget_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:sxui/app/dashboard/data/widget_registry.dart';

/// Opens the picker dialog and returns the chosen WidgetOption (or null if cancelled).
Future<WidgetOption?> showWidgetPickerDialog(
  BuildContext context, {
  required List<WidgetOption> options,
}) {
  return showDialog<WidgetOption>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _WidgetPickerDialog(options: options),
  );
}

class _WidgetPickerDialog extends StatefulWidget {
  final List<WidgetOption> options;
  const _WidgetPickerDialog({Key? key, required this.options}) : super(key: key);

  @override
  State<_WidgetPickerDialog> createState() => _WidgetPickerDialogState();
}

class _WidgetPickerDialogState extends State<_WidgetPickerDialog> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = widget.options
        .where((o) => o.label.toLowerCase().contains(_search.text.toLowerCase()))
        .toList();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title row
              Row(
                children: [
                  const Icon(Icons.widgets, color: Colors.white70),
                  const SizedBox(width: 8),
                  const Text('Add a Widget',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white54),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Search
              TextField(
                controller: _search,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search widgets…',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Results
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, i) {
                      final opt = filtered[i];
                      return ListTile(
                        leading: Icon(opt.icon, color: theme.colorScheme.secondary),
                        title: Text(opt.label, style: const TextStyle(color: Colors.white)),
                        hoverColor: Colors.white10,
                        onTap: () => Navigator.pop(context, opt),
                      );
                    },
                  ),
                ),
              ),

              // Footer buttons
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
