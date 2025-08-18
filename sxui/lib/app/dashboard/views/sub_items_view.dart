import 'package:flutter/material.dart';
import 'package:sxui/app/constants.dart';
import 'package:sxui/app/Extensions/hoverable_text_item.dart';
import 'package:sxui/app/models/sub_item.dart';


class SubItemsView extends StatelessWidget {
  final String title;
  final List<SubItem> items;
  final void Function(SubItem) onItemTap;

  const SubItemsView({
    super.key,
    required this.title,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            color: darkPurple,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            key: const ValueKey('subItemList'),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              return HoverableTextItem(
                text: item.title,
                icon: item.icon,
                onTap: () => onItemTap(item),
                fontSize: 20,
                hoverFontSize: 24,
              );
            },
          ),
        ),
      ],
    );
  }
}
