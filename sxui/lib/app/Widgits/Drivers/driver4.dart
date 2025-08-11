// Author: Will Soltani
// Version 1.0
// Revised: 30-09-2024

// This widget, BoxX9, provides a dashboard interface for managing Pickup and Delivery sections.
// Users can view, sort, and interact with a list of pickup and delivery items.
// The pickup items can have their statuses toggled between 'Regular' (P) and 'Rushed' (R).
// Delivery times can be modified through a time picker dialog, and any changes made are logged in real-time.
//
// - **PickupItem & DeliveryItem**: These are data classes representing individual pickup and delivery entries.
// - **NoGlowScrollBehavior**: A custom scroll behavior that removes the default overscroll glow effect for a smoother UI.
// - **_logChange**: Logs changes made to the pickup or delivery items into the `logMessages` notifier for tracking.
// - **_sortedPickupItems & _sortedDeliveryItems**: Sort the lists of pickup and delivery items. Pickup items prioritize 'R' (Rushed) over 'P' (Regular), then sort alphabetically. Delivery items are sorted based on time in ascending order.
// - **_showPickupStatusMenu**: Shows a popup menu to change a pickup item's status between 'Regular' (P) and 'Rushed' (R).
// - **_modifyDeliveryTime**: Opens a time picker dialog to allow modification of a delivery item's time.
// - **_buildPickupItem & _buildDeliveryItem**: Build the UI elements for individual pickup and delivery items, with interactions for status change and time modification.
// - **build**: The main build function that constructs the UI, displaying both pickup and delivery sections.

import 'package:flutter/material.dart';

/// Data class representing a Pickup item.
class PickupItem {
  String label;
  String? iconText;
  Color? iconColor;

  PickupItem({
    required this.label,
    this.iconText,
    this.iconColor,
  });
}

/// Data class representing a Delivery item.
class DeliveryItem {
  String label;
  TimeOfDay time;

  DeliveryItem({
    required this.label,
    required this.time,
  });
}

/// Custom ScrollBehavior to remove the overscroll glow.
class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

/// A widget representing BoxX9 with Pickup and Delivery sections.
class BoxX9 extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>>
      logMessages; // For tracking log messages.

  const BoxX9({Key? key, required this.logMessages}) : super(key: key);

  @override
  _BoxX9State createState() => _BoxX9State();
}

class _BoxX9State extends State<BoxX9> {
  // Define text styles for consistency.
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle itemStyle = TextStyle(
    fontSize: 14,
    color: Colors.white60,
  );

  static const TextStyle timeStyle = TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // Initial list of Pickup items.
  List<PickupItem> _pickupItems = [
    PickupItem(label: 'PK1', iconText: 'P', iconColor: Colors.red),
    PickupItem(label: 'PK2', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK3', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK4', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK5', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK6', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK7', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK8', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK9', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK10', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK11', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK12', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK13', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK14', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK15', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK16', iconText: 'P', iconColor: Colors.green),
  ];

  // Initial list of Delivery items.
  List<DeliveryItem> _deliveryItems = [
    DeliveryItem(label: 'DL1', time: TimeOfDay(hour: 6, minute: 15)),
    DeliveryItem(label: 'DL2', time: TimeOfDay(hour: 7, minute: 30)),
    DeliveryItem(label: 'DL3', time: TimeOfDay(hour: 8, minute: 45)),
    DeliveryItem(label: 'DL4', time: TimeOfDay(hour: 9, minute: 10)),
    DeliveryItem(label: 'DL5', time: TimeOfDay(hour: 10, minute: 25)),
    DeliveryItem(label: 'DL6', time: TimeOfDay(hour: 11, minute: 40)),
    DeliveryItem(label: 'DL7', time: TimeOfDay(hour: 12, minute: 55)),
    DeliveryItem(label: 'DL8', time: TimeOfDay(hour: 13, minute: 20)),
    DeliveryItem(label: 'DL9', time: TimeOfDay(hour: 14, minute: 35)),
    DeliveryItem(label: 'DL10', time: TimeOfDay(hour: 15, minute: 50)),
    DeliveryItem(label: 'DL11', time: TimeOfDay(hour: 16, minute: 5)),
    DeliveryItem(label: 'DL12', time: TimeOfDay(hour: 17, minute: 20)),
    DeliveryItem(label: 'DL13', time: TimeOfDay(hour: 18, minute: 45)),
    DeliveryItem(label: 'DL14', time: TimeOfDay(hour: 19, minute: 10)),
    DeliveryItem(label: 'DL15', time: TimeOfDay(hour: 20, minute: 30)),
    DeliveryItem(label: 'DL16', time: TimeOfDay(hour: 21, minute: 0)),
    DeliveryItem(label: 'DL17', time: TimeOfDay(hour: 22, minute: 15)),
    DeliveryItem(label: 'DL18', time: TimeOfDay(hour: 23, minute: 35)),
    DeliveryItem(label: 'DL19', time: TimeOfDay(hour: 0, minute: 45)),
    DeliveryItem(label: 'DL20', time: TimeOfDay(hour: 1, minute: 10)),
    DeliveryItem(label: 'DL21', time: TimeOfDay(hour: 2, minute: 25)),
    DeliveryItem(label: 'DL22', time: TimeOfDay(hour: 3, minute: 50)),
  ];

  @override
  void initState() {
    super.initState();
    // Sorts the initial lists on startup.
    _pickupItems = _sortedPickupItems();
    _deliveryItems = _sortedDeliveryItems();
  }

  /// Logs changes to the `logMessages` notifier.
  void _logChange(String message) {
    Map<String, dynamic> logEntry = {
      'description': message,
      'completed': false, // Adjust based on your logic.
    };
    widget.logMessages.value = [...widget.logMessages.value, logEntry];
  }

  /// Sorts the Pickup items, prioritizing 'R' over 'P', then alphabetically by label.
  List<PickupItem> _sortedPickupItems() {
    List<PickupItem> sortedList = List.from(_pickupItems);
    sortedList.sort((a, b) {
      if (a.iconText == 'R' && b.iconText != 'R') {
        return -1;
      } else if (a.iconText != 'R' && b.iconText == 'R') {
        return 1;
      } else {
        return a.label.compareTo(b.label);
      }
    });
    return sortedList;
  }

  /// Sorts the Delivery items in ascending order based on time.
  List<DeliveryItem> _sortedDeliveryItems() {
    List<DeliveryItem> sortedList = List.from(_deliveryItems);
    sortedList.sort((a, b) {
      final aMinutes = a.time.hour * 60 + a.time.minute;
      final bMinutes = b.time.hour * 60 + b.time.minute;
      return aMinutes.compareTo(bMinutes);
    });
    return sortedList;
  }

  /// Shows a popup menu to toggle Pickup status between 'P' and 'R'.
  void _showPickupStatusMenu(PickupItem item, Offset position) async {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    String? selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(position, position),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'P',
          child: Text(
            'P - Regular',
            style: TextStyle(
                color: item.iconText == 'P' ? Colors.blue : Colors.black),
          ),
        ),
        PopupMenuItem<String>(
          value: 'R',
          child: Text(
            'R - Rushed',
            style: TextStyle(
                color: item.iconText == 'R' ? Colors.blue : Colors.black),
          ),
        ),
      ],
    );

    if (selected != null && selected != item.iconText) {
      setState(() {
        item.iconText = selected;
        item.iconColor = selected == 'R' ? Colors.red : Colors.green;
        _pickupItems = _sortedPickupItems();
      });

      // Log the change.
      _logChange('🌟 USER 1 changed ${item.label} status to $selected');

      // Optional: Provide user feedback.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🌟 USER 1 changed ${item.label} status to $selected'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Modifies the Delivery time using a TimePicker dialog.
  Future<void> _modifyDeliveryTime(DeliveryItem item, Offset position) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: item.time,
    );

    if (pickedTime != null && pickedTime != item.time) {
      setState(() {
        item.time = pickedTime;
        _deliveryItems = _sortedDeliveryItems();
      });

      // Log the change.
      _logChange(
          '🌟 USER 1 updated ${item.label} time to ${pickedTime.format(context)}');

      // Optional: Provide user feedback.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '🌟 USER 1 updated ${item.label} time to ${pickedTime.format(context)}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// Builds a Pickup item row with an optional icon.
  Widget _buildPickupItem(PickupItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(item.label, style: itemStyle),
          ),
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              _showPickupStatusMenu(item, details.globalPosition);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 8.0),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: item.iconColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  item.iconText ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a Delivery item row with time display.
  Widget _buildDeliveryItem(DeliveryItem item) {
    final String formattedTime =
        '${item.time.hourOfPeriod == 0 ? 12 : item.time.hourOfPeriod}:${item.time.minute.toString().padLeft(2, '0')} ${item.time.period == DayPeriod.am ? 'AM' : 'PM'}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(item.label, style: itemStyle),
          ),
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              _modifyDeliveryTime(item, details.globalPosition);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                border: Border.all(color: Colors.deepPurple, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                formattedTime,
                style: timeStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalPickups = _pickupItems.length;
    final int totalDeliveries = _deliveryItems.length;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Driver1',
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('Pickup', style: subtitleStyle),
                      ),
                      const SizedBox(height: 8),
                      ScrollConfiguration(
                        behavior: NoGlowScrollBehavior(),
                        child: _pickupItems.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _pickupItems.length,
                                itemBuilder: (context, index) {
                                  return _buildPickupItem(
                                      _pickupItems[index]);
                                },
                              )
                            : Center(
                                child: Text('No pickups available',
                                    style: itemStyle),
                              ),
                      ),
                      const SizedBox(height: 8),
                      Center(child: Text('$totalPickups', style: titleStyle)),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  color: Colors.grey[800],
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('Delivery', style: subtitleStyle),
                      ),
                      const SizedBox(height: 8),
                      ScrollConfiguration(
                        behavior: NoGlowScrollBehavior(),
                        child: _deliveryItems.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _deliveryItems.length,
                                itemBuilder: (context, index) {
                                  return _buildDeliveryItem(
                                      _deliveryItems[index]);
                                },
                              )
                            : Center(
                                child: Text('No deliveries available',
                                    style: itemStyle),
                              ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                          child: Text('$totalDeliveries', style: titleStyle)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
