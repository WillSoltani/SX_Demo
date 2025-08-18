// ================================
// File: lib/MainDashboard/main_dash_widget.dart
// Author: Will
// Version: 1.4 (refactor-split)
// Revised: 2025-08-17
// Notes: Slim stateful shell; delegates UI to views and actions to DashActions
// ================================

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:sxui/app/shared/constants.dart';
import 'package:sxui/app/shared/models/sub_item.dart';
import 'package:sxui/app/shared/models/tab_item.dart';
import 'package:sxui/app/Extensions/dashboard_box.dart';

import 'package:sxui/app/dashboard/components/hoverable_icon_button.dart';
import 'package:sxui/app/dashboard/data/menu_data.dart';
import 'package:sxui/app/dashboard/logic/dash_actions.dart';
import 'package:sxui/app/dashboard/views/main_items_view.dart';
import 'package:sxui/app/dashboard/views/sub_items_view.dart';

class MainDashWidget extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;
  final Function(TabItem tab) onOpenTab;
  final Function(String tabId) onCloseTab;

  const MainDashWidget({
    super.key,
    required this.logMessages,
    required this.onOpenTab,
    required this.onCloseTab,
  });

  @override
  State<MainDashWidget> createState() => _MainDashWidgetState();
}

class _MainDashWidgetState extends State<MainDashWidget>
    with TickerProviderStateMixin {
  String? selectedMainItem;
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late DashActions _actions;

  @override
  void initState() {
    super.initState();
    _actions = DashActions(
      logMessages: widget.logMessages,
      onOpenTab: widget.onOpenTab,
      onCloseTab: widget.onCloseTab,
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide context to actions that need Navigator
    _actions.attachContext(context);

    return DashboardBox(
      child: Stack(
        children: [
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: selectedMainItem == null
                    ? MainItemsView(
                        key: const ValueKey('mainItems'),
                        title: 'Dashboard',
                        items: getMainItems(),
                        onItemTap: (item) {
                          setState(() {
                            selectedMainItem = item.title;
                            _controller
                              ..reset()
                              ..forward();
                          });
                        },
                      )
                    : SubItemsView(
                        key: const ValueKey('subItems'),
                        title: selectedMainItem!,
                        items: getSubItems(selectedMainItem!),
                        onItemTap: _onSubItemTap,
                      ),
              ),
            ),
          ),
          if (selectedMainItem != null)
            Positioned(
              top: 8,
              left: 8,
              child: Tooltip(
                message: 'Back',
                child: HoverableIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () {
                    setState(() {
                      selectedMainItem = null;
                      _controller
                        ..reset()
                        ..forward();
                    });
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onSubItemTap(SubItem item) {
    final main = selectedMainItem;
    if (main == 'Customers' && item.title == 'Add Customer') {
      _actions.openAddCustomerTab();
    } else if (main == 'Customers' && item.title == 'View Customer Profile') {
      _actions.openViewCustomerProfileTab(onOpenCustomer: (name) {
        final tabId = const Uuid().v4();
        widget.onOpenTab(TabItem(
          id: tabId,
          title: name,
          content: Center(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
      });
    } else if (main == 'Operations' && item.title == 'Inventory Management') {
      _actions.openInventoryManagementTab(
        onOpenProduct: (productId) {
          final tabId = const Uuid().v4();
          widget.onOpenTab(TabItem(
            id: tabId,
            title: productId,
            content: Center(
              child: Text(
                'Product ID: $productId',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ));
        },
      );
    } else {
      _actions.navigateToSubItemPage(item);
    }
  }
}