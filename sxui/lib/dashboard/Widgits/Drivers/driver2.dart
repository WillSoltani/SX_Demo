// Author: Will Soltani
// Version 1.0
// Revised: 30-09-2024

// This widget, BoxX7, is a dashboard that displays Pickup and Delivery sections.
// It lets the user view and manage pickup and delivery items. The pickup items
// can be toggled between 'Regular' and 'Rushed' statuses, and delivery times
// can be modified through a time picker. Changes are logged and notifications
// are shown to provide feedback to the user.
//
// Here's a breakdown of the main components and functions:
//
// - **PickupItem & DeliveryItem**: Data classes that represent individual pickup and delivery entries.
// - **NoGlowScrollBehavior**: A custom scroll behavior that removes the overscroll glow effect for a smoother UI.
// - **_logChange**: This function logs changes made to pickup and delivery items in the logMessages notifier.
// - **_sortedPickupItems & _sortedDeliveryItems**: Functions to sort pickup and delivery items. Pickup items prioritize 'R' (Rushed) and are then sorted alphabetically. Delivery items are sorted based on time.
// - **_showPickupStatusMenu**: Shows a popup menu to change a pickup item's status between 'P' (Regular) and 'R' (Rushed).
// - **_modifyDeliveryTime**: Opens a time picker to allow modification of a delivery item's time.
// - **_buildPickupItem & _buildDeliveryItem**: Build the UI components for each pickup and delivery item respectively, with interactions and styling.
// - **build**: The main build function that assembles the UI, showing both pickup and delivery sections.

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

/// A widget representing BoxX7 with Pickup and Delivery sections.
class BoxX7 extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>>
      logMessages; // Keeps track of log messages

  const BoxX7({Key? key, required this.logMessages}) : super(key: key);

  @override
  _BoxX7State createState() => _BoxX7State();
}

class _BoxX7State extends State<BoxX7> {
  // Define text styles
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

  // Randomized list of Pickup Items
  List<PickupItem> _pickupItems = [
    PickupItem(label: 'PK1', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK3', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK5', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK7', iconText: 'P', iconColor: Colors.green),
  ];

  // Randomized list of Delivery Items
  List<DeliveryItem> _deliveryItems = [
    DeliveryItem(label: 'DL2', time: TimeOfDay(hour: 6, minute: 30)),
    DeliveryItem(label: 'DL4', time: TimeOfDay(hour: 10, minute: 15)),
    DeliveryItem(label: 'DL6', time: TimeOfDay(hour: 14, minute: 50)),
    DeliveryItem(label: 'DL8', time: TimeOfDay(hour: 19, minute: 5)),
  ];

  @override
  void initState() {
    super.initState();
    // Sorts the initial lists on startup
    _pickupItems = _sortedPickupItems();
    _deliveryItems = _sortedDeliveryItems();
  }

  /// Logs changes to the `logMessages` notifier. Keeps track of any modifications made to items.
  void _logChange(String description, bool completed) {
    widget.logMessages.value = [
      ...widget.logMessages.value,
      {
        'description': description,
        'completed': completed,
      },
    ];
    widget.logMessages.notifyListeners();
  }

  /// Sorts the Pickup items. 'R' (Rushed) items are given priority, then sorts the rest alphabetically.
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

  /// Sorts the Delivery items in ascending order based on their time.
  List<DeliveryItem> _sortedDeliveryItems() {
    List<DeliveryItem> sortedList = List.from(_deliveryItems);
    sortedList.sort((a, b) {
      final aMinutes = a.time.hour * 60 + a.time.minute;
      final bMinutes = b.time.hour * 60 + b.time.minute;
      return aMinutes.compareTo(bMinutes);
    });
    return sortedList;
  }

  /// Displays a popup menu to toggle the status of a Pickup item between 'P' (Regular) and 'R' (Rushed).
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

      // Log the change and show feedback
      _logChange('🌟 USER 1 changed ${item.label} status to $selected', false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🌟 USER 1 changed ${item.label} status to $selected'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Opens a TimePicker dialog to modify the time of a Delivery item.
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

      // Log the change and show feedback
      _logChange(
          '🌟 USER 1 updated ${item.label} time to ${pickedTime.format(context)}',
          false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '🌟 USER 1 updated ${item.label} time to ${pickedTime.format(context)}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// Builds a row widget for a Pickup item, including its icon and status toggle.
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

  /// Builds a row widget for a Delivery item, displaying its label and time.
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

    return Container(
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
              'Driver2',
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
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
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: NoGlowScrollBehavior(),
                          child: _pickupItems.isNotEmpty
                              ? ListView.builder(
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
                      ),
                      const SizedBox(height: 8),
                      Center(child: Text('$totalPickups', style: titleStyle)),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: double.infinity,
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
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: NoGlowScrollBehavior(),
                          child: _deliveryItems.isNotEmpty
                              ? ListView.builder(
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
                      ),
                      const SizedBox(height: 8),
                      Center(
                          child: Text('$totalDeliveries', style: titleStyle)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
