// File: lib/app/features/main_hub/main_hub.dart
// Author: Will (restored Main Hub look/feel)
// Version: 1.3
// Revised: 2025-08-17

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Your existing helpers/visuals
import 'package:sxui/app/shared/constants.dart';
import 'package:sxui/app/Extensions/dashboard_box.dart';
import 'package:sxui/app/Extensions/hoverable_text_item.dart';

// Pages/tabs used by the hub (same as your old wiring)
import 'package:sxui/app/pages/sub_item_page.dart';
import 'package:sxui/app/shared/models/tab_item.dart';

// Sub features (same as your old imports, just package paths)
import 'package:sxui/app/features/customers/add_customer.dart';
import 'package:sxui/app/features/customers/view_customer_profile.dart';
import 'package:sxui/app/features/operations/add_product.dart';
import 'package:sxui/app/features/operations/inventory.dart';


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
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ---------- BUILD ----------

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
          duration: const Duration(milliseconds: 500),
          child: selectedMainItem == null ? _buildMainItems() : _buildSubItems(),
        ),
      ),
    );
  }

  Widget _buildMainItems() {
    return Column(
      key: const ValueKey('mainItems'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            // color set via copyWith to use your brand color
          ),
        ),
        const SizedBox(height: 24),
        Expanded(child: _buildMainItemList()),
      ],
    );
  }

  Widget _buildMainItemList() {
    final mainItems = _getMainItems();
    return ListView.builder(
      key: const ValueKey('mainItemList'),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
      key: const ValueKey('subItems'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Text(
          selectedMainItem!,
          style: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ).copyWith(color: darkPurple),
        ),
        const SizedBox(height: 24),
        Expanded(child: _buildSubItemList()),
      ],
    );
  }

  Widget _buildSubItemList() {
    final subItems = _getSubItems(selectedMainItem!);
    return ListView.builder(
      key: const ValueKey('subItemList'),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        child: _HoverableIconButton(
          icon: Icons.arrow_back,
          onPressed: _onBackButtonPressed,
        ),
      ),
    );
  }

  // ---------- INTERACTIONS ----------

  void _onMainItemTap(String itemTitle) {
    setState(() {
      selectedMainItem = itemTitle;
      _animationController
        ..reset()
        ..forward();
    });
  }

  void _onBackButtonPressed() {
    setState(() {
      selectedMainItem = null;
      _animationController
        ..reset()
        ..forward();
    });
  }

  void _onSubItemTap(_SubItem item) {
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

  // ---------- TAB OPENERS (same behavior as your original) ----------

  void _openInventoryManagementTab() {
    final String tabId = const Uuid().v4();
    final TabItem newTab = TabItem(
      id: tabId,
      title: 'Inventory Management',
      content: InventoryManagement(
        logMessages: widget.logMessages,
        onClose: () => widget.onCloseTab(tabId),
        onOpenTab: _openProductDetailTab,
        onAddProduct: _openAddProductTab,
      ),
    );
    widget.onOpenTab(newTab);
  }

  void _openAddProductTab() {
    final String tabId = const Uuid().v4();
    final TabItem newTab = TabItem(
      id: tabId,
      title: 'Add Product',
      content: AddProduct(
        logMessages: widget.logMessages,
        onClose: () => widget.onCloseTab(tabId),
      ),
    );
    widget.onOpenTab(newTab);
  }

  void _openProductDetailTab(String productId) {
    final String tabId = const Uuid().v4();
    final TabItem newTab = TabItem(
      id: tabId,
      title: productId,
      content: Center(
        child: Text(
          'Product ID: $productId',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    widget.onOpenTab(newTab);
  }

  void _openViewCustomerProfileTab() {
    final String tabId = const Uuid().v4();
    final TabItem newTab = TabItem(
      id: tabId,
      title: 'View Customer Profile',
      content: ViewCustomerProfile(
        logMessages: widget.logMessages,
        onClose: () => widget.onCloseTab(tabId),
        onOpenTab: _openCustomerDetailTab,
      ),
    );
    widget.onOpenTab(newTab);
  }

  void _openAddCustomerTab() {
    final String tabId = const Uuid().v4();
    final TabItem newTab = TabItem(
      id: tabId,
      title: 'Add Customer',
      content: AddCustomer(
        logMessages: widget.logMessages,
        onClose: () => widget.onCloseTab(tabId),
      ),
    );
    widget.onOpenTab(newTab);
  }

  void _navigateToSubItemPage(_SubItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubItemPage(subItem: item.title),
      ),
    );
  }

  void _openCustomerDetailTab(String customerName) {
    final String tabId = const Uuid().v4();
    final TabItem newTab = TabItem(
      id: tabId,
      title: customerName,
      content: Center(
        child: Text(
          customerName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    widget.onOpenTab(newTab);
  }

  // ---------- DATA (identical lists) ----------

  List<_SubItem> _getMainItems() {
    return const [
      _SubItem('Customers', Icons.people),
      _SubItem('Emails', Icons.email),
      _SubItem('Reports', Icons.bar_chart),
      _SubItem('Operations', Icons.settings),
      _SubItem('More', Icons.more_horiz),
    ];
  }

  List<_SubItem> _getSubItems(String mainItem) {
    switch (mainItem) {
      case 'Customers':
        return const [
          _SubItem('Add Customer', Icons.person_add),
          _SubItem('View Customer Profile', Icons.person),
          _SubItem('View Customer Activity', Icons.history),
          _SubItem('View Customer Summary', Icons.assessment),
          _SubItem('Merge Customer', Icons.merge_type),
          _SubItem('Customer Payment', Icons.payment),
        ];
      case 'Emails':
        return const [
          _SubItem('Compose Email', Icons.create),
          _SubItem('Inbox', Icons.inbox),
          _SubItem('Sent Items', Icons.send),
        ];
      case 'Reports':
        return const [
          _SubItem('Sales Report', Icons.show_chart),
          _SubItem('Staff Report', Icons.people_outline),
          _SubItem('Custom Report', Icons.insert_chart),
          _SubItem('Flagged Invoices', Icons.flag),
          _SubItem('Financial Reports', Icons.account_balance),
        ];
      case 'Operations':
        return const [
          _SubItem('Inventory Management', Icons.inventory),
          _SubItem('Order Management', Icons.shopping_cart),
          _SubItem('Production Management', Icons.factory),
          _SubItem('Pickup and Delivery', Icons.local_shipping),
          _SubItem('Analytics and Reporting', Icons.analytics),
          _SubItem('Staff Scheduling', Icons.schedule),
          _SubItem('Printers and Devices', Icons.print),
        ];
      case 'More':
        return const [
          _SubItem('Settings', Icons.settings),
          _SubItem('Help', Icons.help),
          _SubItem('Feedback', Icons.feedback),
          _SubItem('About Us', Icons.info),
          _SubItem('Logout', Icons.logout),
        ];
      default:
        return const [];
    }
  }
}

// Simple local model (to avoid external deps for the hub)
class _SubItem {
  final String title;
  final IconData icon;
  const _SubItem(this.title, this.icon);
}

// Hoverable back icon (exact same feel)
class _HoverableIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HoverableIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  _HoverableIconButtonState createState() => _HoverableIconButtonState();
}

class _HoverableIconButtonState extends State<_HoverableIconButton> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: _isHovered ? darkPurple.withOpacity(0.1) : Colors.transparent,
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
