// lib/app/dashboard/widgets/minimized_tabs_bar.dart
import 'package:flutter/material.dart';
import 'package:sxui/app/shared/models/tab_item.dart';

class MinimizedTabsBar extends StatelessWidget {
  final List<TabItem> tabs;
  final ValueChanged<String> onClose;
  final ValueChanged<String> onRestore;

  const MinimizedTabsBar({
    super.key,
    required this.tabs,
    required this.onClose,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final minimized = tabs.where((t) => t.isMinimized).toList();
    if (minimized.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, -2))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: minimized
              .map((tab) => _Btn(tab: tab, onClose: onClose, onRestore: onRestore))
              .toList(),
        ),
      ),
    );
  }
}

class _Btn extends StatefulWidget {
  final TabItem tab;
  final ValueChanged<String> onClose;
  final ValueChanged<String> onRestore;

  const _Btn({required this.tab, required this.onClose, required this.onRestore});

  @override
  State<_Btn> createState() => _BtnState();
}

class _BtnState extends State<_Btn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final tab = widget.tab;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => widget.onRestore(tab.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _hover ? Colors.grey[600] : Colors.grey[700],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tab.title, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => widget.onClose(tab.id),
                child: const Icon(Icons.close, size: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
