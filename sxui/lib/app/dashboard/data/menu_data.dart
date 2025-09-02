import 'package:flutter/material.dart';
import 'package:sxui/app/shared/models/sub_item.dart';

List<SubItem> getMainItems() {
  return [
    SubItem('Customers', Icons.people),
    SubItem('Emails', Icons.email),
    SubItem('Reports', Icons.bar_chart),
    SubItem('Operations', Icons.settings),
    SubItem('More', Icons.more_horiz),
  ];
}

List<SubItem> getSubItems(String mainItem) {
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
