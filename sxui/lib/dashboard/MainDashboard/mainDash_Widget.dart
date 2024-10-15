// File: lib/MainDashboard/mainDash_widget.dart

// Author: Will
// Version: 1.3
// Revised: 07-10-2024

// This widget, MainDashWidget, displays the main dashboard section with options like 'Customers', 'Emails',
// 'Reports', 'Operations', and 'More'. It maintains the original title and logo design, adds improved animations,
// and includes a back button with hover effects when sub-items are displayed.

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs
import 'Subs/Customers/add_customer.dart';
import 'Subs/Customers/view_customer_profile.dart';
import '../Extensions/dashboard_box.dart';
import '../Extensions/hoverable_text_item.dart';
import '../models/sub_item.dart';
import '../constants.dart';
import '../../pages/sub_item_page.dart';
import '../models/tab_item.dart';
// Import your updated InventoryManagement widget
import 'Subs/Operations/inventory.dart';
import 'Subs/Operations/add_product.dart'; // Adjust the path as necessary


class MainDashWidget extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;
  final Function(TabItem tab) onOpenTab;
  final Function(String tabId) onCloseTab;

  const MainDashWidget({
    Key? key,
    required this.logMessages,
    required this.onOpenTab,
    required this.onCloseTab,
  }) : super(key: key);

  @override
  _MainDashWidgetState createState() => _MainDashWidgetState();
}

class _MainDashWidgetState extends State<MainDashWidget>
    with TickerProviderStateMixin {
  String? selectedMainItem;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Start the animation controller for the initial view
    _animationController.forward();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardBox(
      child: Stack(
        children: [
          _buildMainContent(),
          if (selectedMainItem != null) _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child:
              selectedMainItem == null ? _buildMainItems() : _buildSubItems(),
        ),
      ),
    );
  }

  Widget _buildMainItems() {
    return Column(
      key: ValueKey('mainItems'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16), // Add spacing from the top
        // Title
        Text(
          'Dashboard',
          style: TextStyle(
            color: darkPurple,
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 24),
        // Main Items List
        Expanded(
          child: _buildMainItemList(),
        ),
      ],
    );
  }

  Widget _buildMainItemList() {
    final mainItems = _getMainItems();
    return ListView.builder(
      key: ValueKey('mainItemList'),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: mainItems.length,
      itemBuilder: (context, index) {
        final item = mainItems[index];
        return HoverableTextItem(
          text: item.title,
          icon: item.icon,
          onTap: () => _onMainItemTap(item.title),
          fontSize: 24.0,
          hoverFontSize: 28.0,
        );
      },
    );
  }

  Widget _buildSubItems() {
    return Column(
      key: ValueKey('subItems'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16), // Add spacing from the top
        // Title of Selected Main Item
        Text(
          selectedMainItem!,
          style: TextStyle(
            color: darkPurple,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 24),
        // Sub-Items List
        Expanded(
          child: _buildSubItemList(),
        ),
      ],
    );
  }

  Widget _buildSubItemList() {
    final subItems = _getSubItems(selectedMainItem!);
    return ListView.builder(
      key: ValueKey('subItemList'),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: subItems.length,
      itemBuilder: (context, index) {
        final item = subItems[index];
        return HoverableTextItem(
          text: item.title,
          icon: item.icon,
          onTap: () => _onSubItemTap(item),
          fontSize: 20.0,
          hoverFontSize: 24.0,
        );
      },
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 8.0,
      left: 8.0,
      child: Tooltip(
        message: 'Back',
        child: HoverableIconButton(
          icon: Icons.arrow_back,
          onPressed: _onBackButtonPressed,
        ),
      ),
    );
  }

  void _onMainItemTap(String itemTitle) {
    setState(() {
      selectedMainItem = itemTitle;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _onBackButtonPressed() {
    setState(() {
      selectedMainItem = null;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _onSubItemTap(SubItem item) {
    if (item.title == 'Add Customer' && selectedMainItem == 'Customers') {
      _openAddCustomerTab();
    } else if (item.title == 'View Customer Profile' &&
        selectedMainItem == 'Customers') {
      _openViewCustomerProfileTab();
    } else if (item.title == 'Inventory Management' &&
        selectedMainItem == 'Operations') {
      _openInventoryManagementTab();
    } else {
      _navigateToSubItemPage(item);
    }
  }

void _openInventoryManagementTab() {
    String tabId = Uuid().v4();
    TabItem newTab = TabItem(
      id: tabId,
      title: 'Inventory Management',
      content: InventoryManagement(
        logMessages: widget.logMessages,
        onClose: () {
          widget.onCloseTab(tabId); // Notify the parent to close the tab
        },
        onOpenTab: _openProductDetailTab, // Existing callback
        onAddProduct: _openAddProductTab, // New callback
      ),
    );

    // Use the callback to open the tab
    widget.onOpenTab(newTab);
  }

  void _openAddProductTab() {
    String tabId = Uuid().v4();
    TabItem newTab = TabItem(
      id: tabId,
      title: 'Add Product',
      content: AddProduct(
        logMessages: widget.logMessages,
        onClose: () {
          widget.onCloseTab(tabId); // Notify the parent to close the tab
        },
      ),
    );

    // Use the callback to open the tab
    widget.onOpenTab(newTab);
  }



  void _openProductDetailTab(String productId) {
    String tabId = Uuid().v4();
    TabItem newTab = TabItem(
      id: tabId,
      title: productId,
      content: Center(
        child: Text(
          'Product ID: $productId',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Use the callback to open the tab
    widget.onOpenTab(newTab);
  }

  void _openViewCustomerProfileTab() {
    String tabId = Uuid().v4();
    TabItem newTab = TabItem(
      id: tabId,
      title: 'View Customer Profile',
      content: ViewCustomerProfile(
        logMessages: widget.logMessages,
        onClose: () {
          widget.onCloseTab(tabId); // Notify the parent to close the tab
        },
        onOpenTab: _openCustomerDetailTab, // Pass the callback here
      ),
    );

    // Use the callback to open the tab
    widget.onOpenTab(newTab);
  }

  void _openAddCustomerTab() {
    String tabId = Uuid().v4();
    TabItem newTab = TabItem(
      id: tabId,
      title: 'Add Customer',
      content: AddCustomer(
        logMessages: widget.logMessages,
        onClose: () {
          widget.onCloseTab(tabId); // Notify the parent to close the tab
        },
      ),
    );

    // Use the callback to open the tab
    widget.onOpenTab(newTab);
  }

  void _navigateToSubItemPage(SubItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubItemPage(subItem: item.title),
      ),
    );
  }

  /// Callback function to open a new tab with the customer's name centered
  void _openCustomerDetailTab(String customerName) {
    String tabId = Uuid().v4();
    TabItem newTab = TabItem(
      id: tabId,
      title: customerName,
      content: Center(
        child: Text(
          customerName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Use the callback to open the tab
    widget.onOpenTab(newTab);
  }

  List<SubItem> _getMainItems() {
    return [
      SubItem('Customers', Icons.people),
      SubItem('Emails', Icons.email),
      SubItem('Reports', Icons.bar_chart),
      SubItem('Operations', Icons.settings),
      SubItem('More', Icons.more_horiz),
    ];
  }

  List<SubItem> _getSubItems(String mainItem) {
    switch (mainItem) {
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
          SubItem('Compose Email', Icons.create),
          SubItem('Inbox', Icons.inbox),
          SubItem('Sent Items', Icons.send),
        ];
      case 'Reports':
        return [
          SubItem('Sales Report', Icons.show_chart),
          SubItem('Staff Report', Icons.people_outline),
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
}

/// Custom hoverable icon button used for the back button.
class HoverableIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const HoverableIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  _HoverableIconButtonState createState() => _HoverableIconButtonState();
}

class _HoverableIconButtonState extends State<HoverableIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color:
                _isHovered ? darkPurple.withOpacity(0.1) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            color: _isHovered ? darkPurple : Colors.black,
            size: 28.0,
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}
