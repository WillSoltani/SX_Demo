// File: lib/dashboard/boxes/box_x2.dart

// Author: Will Soltani
// Version: 1.0
// Revised: 30-09-2024

// This widget, BoxX2, displays the customer section with an option to add new customers.
// Clicking "Add Customer" opens a medium-sized tab for entering customer details.

import 'package:flutter/material.dart';
import 'Subs/add_customer.dart'; // Import the AddCustomer widget
import '../Extensions/dashboard_box.dart';
import '../Extensions/hoverable_text_item.dart';
import '../Extensions/hoverable_expanded_item.dart';
import '../models/sub_item.dart';
import '../constants.dart';
import '../../pages/sub_item_page.dart';

class BoxX2 extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;

  const BoxX2({Key? key, required this.logMessages}) : super(key: key);

  @override
  _BoxX2State createState() => _BoxX2State();
}

class _BoxX2State extends State<BoxX2> with TickerProviderStateMixin {
  String? expandedItem;
  late AnimationController _subItemsController;
  List<Animation<Offset>> _subItemAnimations = [];

  @override
  void initState() {
    super.initState();
    _subItemsController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    expandedItem = null;
  }

  @override
  void dispose() {
    _subItemsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardBox(
      key: ValueKey(expandedItem ?? 'main'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: expandedItem == null
              ? _buildMainItems(context)
              : _buildExpandedItem(context),
        ),
      ),
    );
  }

  /// Builds the main items view containing 'Customers', 'Emails', 'Reports', 'Operations', and 'More'.
  /// Each of these items has hover effects and expands to show sub-items when tapped.
  Widget _buildMainItems(BuildContext context) {
    return Column(
      key: ValueKey('mainItems'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: darkPurple,
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HoverableTextItem(
                text: 'Customers',
                icon: Icons.people,
                onTap: () => _expandItem('Customers'),
                fontSize: 24.0,
                hoverFontSize: 28.0,
              ),
              HoverableTextItem(
                text: 'Emails',
                icon: Icons.email,
                onTap: () => _expandItem('Emails'),
                fontSize: 24.0,
                hoverFontSize: 28.0,
              ),
              HoverableTextItem(
                text: 'Reports',
                icon: Icons.bar_chart,
                onTap: () => _expandItem('Reports'),
                fontSize: 24.0,
                hoverFontSize: 28.0,
              ),
              HoverableTextItem(
                text: 'Operations',
                icon: Icons.settings,
                onTap: () => _expandItem('Operations'),
                fontSize: 24.0,
                hoverFontSize: 28.0,
              ),
              HoverableTextItem(
                text: 'More',
                icon: Icons.more_horiz,
                onTap: () => _expandItem('More'),
                fontSize: 24.0,
                hoverFontSize: 28.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the expanded view of the selected main item, displaying a list of sub-items with hover effects and animations.
  Widget _buildExpandedItem(BuildContext context) {
    List<SubItem> subs = _getSubItems(expandedItem!);

    // Initialize animations for sub-items
    _initializeSubItemAnimations(subs.length);

    return Column(
      key: ValueKey('expandedItem'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HoverableExpandedItem(
          text: expandedItem!,
          onTap: () => _collapseItem(),
          fontSize: 32.0,
          hoverFontSize: 36.0,
        ),
        SizedBox(height: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(subs.length, (index) {
              // Check if the sub-item is 'Add Customer' to handle differently
              if (subs[index].title == 'Add Customer') {
                return SlideTransition(
                  position: _subItemAnimations[index],
                  child: HoverableTextItem(
                    text: subs[index].title,
                    icon: subs[index].icon,
                    onTap: () => _openAddCustomerTab(),
                    fontSize: 20.0,
                    hoverFontSize: 24.0,
                  ),
                );
              } else {
                return SlideTransition(
                  position: _subItemAnimations[index],
                  child: HoverableTextItem(
                    text: subs[index].title,
                    icon: subs[index].icon,
                    onTap: () => _navigateToSub(context, subs[index].title),
                    fontSize: 20.0,
                    hoverFontSize: 24.0,
                  ),
                );
              }
            }),
          ),
        ),
      ],
    );
  }

  /// Expands the selected main item to display its sub-items.
  /// @param item The main item to expand.
  void _expandItem(String item) {
    setState(() {
      expandedItem = item;
    });
    Future.delayed(Duration(milliseconds: 300), () {
      _initializeSubItemAnimations(_getSubItemCount(item));
    });
  }

  /// Collapses back to the main items view.
  void _collapseItem() {
    setState(() {
      expandedItem = null;
    });
    _subItemsController.reset();
  }

  /// Gets the number of sub-items for a given main item.
  /// @param item The main item to get sub-items for.
  int _getSubItemCount(String item) {
    return _getSubItems(item).length;
  }

  /// Retrieves a list of sub-items based on the selected main item.
  /// @param item The main item to retrieve sub-items for.
  List<SubItem> _getSubItems(String item) {
    switch (item) {
      case 'Customers':
        return [
          SubItem('Add Customer', Icons.person_add),
          SubItem('View Customer Profile', Icons.person),
          SubItem('View Customer Activity', Icons.history),
          SubItem('View Customer Summary', Icons.assessment),
          SubItem('Merge Customer', Icons.merge_type),
          SubItem('Customer Payment', Icons.payment),
        ];
      case 'Emails':
        return [
          SubItem('Compose Email', Icons.email),
          SubItem('Inbox', Icons.inbox),
          SubItem('Sent Items', Icons.send),
        ];
      case 'Reports':
        return [
          SubItem('Sales Report', Icons.show_chart),
          SubItem('Staff Report', Icons.people),
          SubItem('Custom Report', Icons.insert_chart),
          SubItem('Flagged Invoices', Icons.flag),
          SubItem('Financial Reports', Icons.account_balance),
        ];
      case 'Operations':
        return [
          SubItem('Inventory Management', Icons.inventory),
          SubItem('Order Management', Icons.shopping_cart),
          SubItem('Production Management', Icons.factory),
          SubItem('Pickup and Delivery', Icons.local_shipping),
          SubItem('Analytics and Reporting', Icons.analytics),
          SubItem('Staff Scheduling', Icons.schedule),
          SubItem('Printers and Devices', Icons.print),
        ];
      case 'More':
        return [
          SubItem('Settings', Icons.settings),
          SubItem('Help', Icons.help),
          SubItem('Feedback', Icons.feedback),
          SubItem('About Us', Icons.info),
          SubItem('Logout', Icons.logout),
        ];
      default:
        return [];
    }
  }

  /// Initializes animations for the sub-items.
  /// @param itemCount The number of sub-items to animate.
  void _initializeSubItemAnimations(int itemCount) {
    _subItemsController.reset();
    _subItemAnimations = [];
    for (int i = 0; i < itemCount; i++) {
      final startDelay = i * 0.1;
      final end = startDelay + 0.5;
      final animation = Tween<Offset>(
        begin: Offset(0, -1),
        end: Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: _subItemsController,
          curve: Interval(
            startDelay,
            end.clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      );
      _subItemAnimations.add(animation);
    }
    _subItemsController.forward();
  }

  /// Handles navigation to the selected sub-item's page.
  /// @param context The build context.
  /// @param subItem The sub-item to navigate to.
  void _navigateToSub(BuildContext context, String subItem) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubItemPage(subItem: subItem)),
    );
  }

  /// Opens the Add Customer tab as a dialog.
void _openAddCustomerTab() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: AddCustomer(
            logMessages: widget.logMessages,
            onClose: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
