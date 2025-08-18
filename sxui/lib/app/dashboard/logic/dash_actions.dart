import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:sxui/app/shared/models/tab_item.dart';
import 'package:sxui/app/shared/models/sub_item.dart';
import 'package:sxui/app/pages/sub_item_page.dart';

// Feature tabs
import 'package:sxui/app/features/customers/add_customer.dart';
import 'package:sxui/app/features/customers/view_customer_profile.dart';
import 'package:sxui/app/features/operations/inventory.dart';
import 'package:sxui/app/features/operations/add_product.dart';

class DashActions {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;
  final Function(TabItem) onOpenTab;
  final Function(String) onCloseTab;

  BuildContext? _context;

  DashActions({
    required this.logMessages,
    required this.onOpenTab,
    required this.onCloseTab,
  });

  void attachContext(BuildContext context) => _context = context;

  // ---------- Customers ----------
  void openAddCustomerTab() {
    final tabId = const Uuid().v4();
    onOpenTab(TabItem(
      id: tabId,
      title: 'Add Customer',
      content: AddCustomer(
        logMessages: logMessages,
        onClose: () => onCloseTab(tabId),
      ),
    ));
  }

  void openViewCustomerProfileTab({
    required void Function(String customerName) onOpenCustomer,
  }) {
    final tabId = const Uuid().v4();
    onOpenTab(TabItem(
      id: tabId,
      title: 'View Customer Profile',
      content: ViewCustomerProfile(
        logMessages: logMessages,
        onClose: () => onCloseTab(tabId),
        onOpenTab: onOpenCustomer,
      ),
    ));
  }

  // ---------- Operations ----------
  void openInventoryManagementTab({
    required void Function(String productId) onOpenProduct,
  }) {
    final tabId = const Uuid().v4();
    onOpenTab(TabItem(
      id: tabId,
      title: 'Inventory Management',
      content: InventoryManagement(
        logMessages: logMessages,
        onClose: () => onCloseTab(tabId),
        onOpenTab: onOpenProduct,
        onAddProduct: openAddProductTab,
      ),
    ));
  }

  void openAddProductTab() {
    final tabId = const Uuid().v4();
    onOpenTab(TabItem(
      id: tabId,
      title: 'Add Product',
      content: AddProduct(
        logMessages: logMessages,
        onClose: () => onCloseTab(tabId),
      ),
    ));
  }

  // ---------- Generic nav ----------
  void navigateToSubItemPage(SubItem item) {
    final ctx = _context;
    if (ctx == null) return;
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (_) => SubItemPage(subItem: item.title),
      ),
    );
  }
}
