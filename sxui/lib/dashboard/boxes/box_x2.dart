import 'package:flutter/material.dart';
import '../widgets/dashboard_box.dart';
import '../widgets/hoverable_text_item.dart';
import '../widgets/hoverable_expanded_item.dart';
import '../models/sub_item.dart';
import '../../pages/sub_item_page.dart';
import '../constants.dart';

class BoxX2 extends StatefulWidget {
  const BoxX2({Key? key}) : super(key: key);

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
          child: expandedItem == null ? _buildMainItems(context) : _buildExpandedItem(context),
        ),
      ),
    );
  }

  // Build the list of main items
  Widget _buildMainItems(BuildContext context) {
    return Column(
      key: ValueKey('mainItems'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Dashboard at the top center
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
        // Other main items
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

  // Build the expanded main item with sub-items
  Widget _buildExpandedItem(BuildContext context) {
    List<SubItem> subs = _getSubItems(expandedItem!);

    // Initialize animations for sub-items
    _initializeSubItemAnimations(subs.length);

    return Column(
      key: ValueKey('expandedItem'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main item at the top with hover effect
        HoverableExpandedItem(
          text: expandedItem!,
          onTap: () => _collapseItem(),
          fontSize: 32.0,
          hoverFontSize: 36.0,
        ),
        SizedBox(height: 8),
        // Sub-items with animations
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(subs.length, (index) {
              return Expanded(
                child: SlideTransition(
                  position: _subItemAnimations[index],
                  child: HoverableTextItem(
                    text: subs[index].title,
                    icon: subs[index].icon,
                    onTap: () => _navigateToSub(context, subs[index].title),
                    fontSize: 20.0,
                    hoverFontSize: 24.0,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Expand the selected main item
  void _expandItem(String item) {
    setState(() {
      expandedItem = item;
    });
    // Start the sub-items animation after a short delay
    Future.delayed(Duration(milliseconds: 300), () {
      _initializeSubItemAnimations(_getSubItemCount(item));
    });
  }

  // Collapse back to main items
  void _collapseItem() {
    setState(() {
      expandedItem = null;
    });
    _subItemsController.reset();
  }

  int _getSubItemCount(String item) {
    return _getSubItems(item).length;
  }

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

  // Initialize animations for sub-items
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

  // Navigation handler for sub-items
  void _navigateToSub(BuildContext context, String subItem) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubItemPage(subItem: subItem)),
    );
  }
}
