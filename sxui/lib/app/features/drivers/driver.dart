// Author: Will Soltani
// Version: 1.1 (single reusable driver instance)
// Revised: 2025-08-17

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

/// Modern no-glow scroll behavior.
class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

/// Reusable Driver widget. Each instance is separated by a unique driverId.
/// You can pass an optional ValueNotifier for logging.
class DriverWidget extends StatefulWidget {
  final String driverId; // unique per instance (we pass this from the picker)
  final String? initialName;
  final ValueNotifier<List<Map<String, dynamic>>>? logMessages;

  const DriverWidget({
    Key? key,
    required this.driverId,
    this.initialName,
    this.logMessages,
  }) : super(key: key);

  @override
  State<DriverWidget> createState() => _DriverWidgetState();
}

class _DriverWidgetState extends State<DriverWidget> {
  // Text styles
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

  late String _name;

  // Instance-local lists for pickups/deliveries
  List<PickupItem> _pickupItems = [
    PickupItem(label: 'PK1', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK2', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK3', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK4', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK5', iconText: 'P', iconColor: Colors.green),
    PickupItem(label: 'PK6', iconText: 'P', iconColor: Colors.green),
  ];

  List<DeliveryItem> _deliveryItems = [
    DeliveryItem(label: 'DL1', time: TimeOfDay(hour: 7, minute: 15)),
    DeliveryItem(label: 'DL2', time: TimeOfDay(hour: 8, minute: 45)),
    DeliveryItem(label: 'DL3', time: TimeOfDay(hour: 9, minute: 0)),
    DeliveryItem(label: 'DL4', time: TimeOfDay(hour: 10, minute: 30)),
    DeliveryItem(label: 'DL5', time: TimeOfDay(hour: 11, minute: 20)),
    DeliveryItem(label: 'DL6', time: TimeOfDay(hour: 12, minute: 10)),
    DeliveryItem(label: 'DL7', time: TimeOfDay(hour: 13, minute: 50)),
    DeliveryItem(label: 'DL8', time: TimeOfDay(hour: 14, minute: 25)),
    DeliveryItem(label: 'DL9', time: TimeOfDay(hour: 15, minute: 40)),
  ];

  @override
  void initState() {
    super.initState();
    // Derive a friendly default name if not provided
    final suffix = widget.driverId.length >= 4
        ? widget.driverId.substring(widget.driverId.length - 4)
        : widget.driverId;
    _name = widget.initialName ?? 'Driver $suffix';

    _pickupItems = _sortedPickupItems();
    _deliveryItems = _sortedDeliveryItems();
  }

  // ---- helpers ----

  void _logChange(String description, bool completed) {
    final log = widget.logMessages;
    if (log == null) return;
    log.value = [
      ...log.value,
      {'description': description, 'completed': completed},
    ];
    log.notifyListeners();
  }

  List<PickupItem> _sortedPickupItems() {
    final sortedList = List<PickupItem>.from(_pickupItems);
    sortedList.sort((a, b) {
      if (a.iconText == 'R' && b.iconText != 'R') return -1;
      if (a.iconText != 'R' && b.iconText == 'R') return 1;
      return a.label.compareTo(b.label);
    });
    return sortedList;
  }

  List<DeliveryItem> _sortedDeliveryItems() {
    final sortedList = List<DeliveryItem>.from(_deliveryItems);
    sortedList.sort((a, b) {
      final aMinutes = a.time.hour * 60 + a.time.minute;
      final bMinutes = b.time.hour * 60 + b.time.minute;
      return aMinutes.compareTo(bMinutes);
    });
    return sortedList;
  }

  void _showPickupStatusMenu(PickupItem item, Offset position) async {
    final overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    final selected = await showMenu<String>(
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
            style: TextStyle(color: item.iconText == 'P' ? Colors.blue : Colors.black),
          ),
        ),
        PopupMenuItem<String>(
          value: 'R',
          child: Text(
            'R - Rushed',
            style: TextStyle(color: item.iconText == 'R' ? Colors.blue : Colors.black),
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

      _logChange('🌟 changed ${item.label} status to $selected', false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🌟 changed ${item.label} status to $selected'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _modifyDeliveryTime(DeliveryItem item) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: item.time,
    );

    if (pickedTime != null && pickedTime != item.time) {
      setState(() {
        item.time = pickedTime;
        _deliveryItems = _sortedDeliveryItems();
      });

      _logChange('🌟 updated ${item.label} time to ${pickedTime.format(context)}', false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🌟 updated ${item.label} time to ${pickedTime.format(context)}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _rename() async {
    final controller = TextEditingController(text: _name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F1422),
        title: const Text('Rename driver', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Driver name',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text('Save')),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() => _name = newName);
    }
  }

  // ---- row builders ----

  Widget _buildPickupItem(PickupItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text(item.label, style: itemStyle)),
          GestureDetector(
            onTapDown: (details) => _showPickupStatusMenu(item, details.globalPosition),
            child: Container(
              margin: const EdgeInsets.only(left: 8.0),
              width: 20, height: 20,
              decoration: BoxDecoration(
                color: item.iconColor, shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(item.iconText ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryItem(DeliveryItem item) {
    final h = item.time.hourOfPeriod == 0 ? 12 : item.time.hourOfPeriod;
    final m = item.time.minute.toString().padLeft(2, '0');
    final ap = item.time.period == DayPeriod.am ? 'AM' : 'PM';
    final formattedTime = '$h:$m $ap';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text(item.label, style: itemStyle)),
          GestureDetector(
            onTap: () => _modifyDeliveryTime(item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                border: Border.all(color: Colors.deepPurple, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(formattedTime, style: timeStyle),
            ),
          ),
        ],
      ),
    );
  }

  // ---- UI ----

  @override
  Widget build(BuildContext context) {
    final int totalPickups = _pickupItems.length;
    final int totalDeliveries = _deliveryItems.length;

    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
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
            // Header with rename
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_name, style: titleStyle),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Rename',
                  icon: const Icon(Icons.edit, color: Colors.white70, size: 18),
                  onPressed: _rename,
                ),
              ],
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Row(
                children: [
                  // Pickups
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: double.infinity, alignment: Alignment.center, child: Text('Pickup', style: subtitleStyle)),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _pickupItems.isNotEmpty
                              ? ListView.builder(
                                  itemCount: _pickupItems.length,
                                  itemBuilder: (context, index) => _buildPickupItem(_pickupItems[index]),
                                )
                              : Center(child: Text('No pickups available', style: itemStyle)),
                        ),
                        const SizedBox(height: 8),
                        Center(child: Text('$totalPickups', style: titleStyle)),
                      ],
                    ),
                  ),

                  // Divider
                  Container(width: 1, height: double.infinity, color: Colors.grey[800], margin: const EdgeInsets.symmetric(horizontal: 8.0)),

                  // Deliveries
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: double.infinity, alignment: Alignment.center, child: Text('Delivery', style: subtitleStyle)),
                        const SizedBox(height: 8),
                        Expanded(
                          child: _deliveryItems.isNotEmpty
                              ? ListView.builder(
                                  itemCount: _deliveryItems.length,
                                  itemBuilder: (context, index) => _buildDeliveryItem(_deliveryItems[index]),
                                )
                              : Center(child: Text('No deliveries available', style: itemStyle)),
                        ),
                        const SizedBox(height: 8),
                        Center(child: Text('$totalDeliveries', style: titleStyle)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
