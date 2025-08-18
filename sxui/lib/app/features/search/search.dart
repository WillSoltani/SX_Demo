// Author: Will Soltani
// Version: 1.1
// Revised: 2025-08-17

import 'package:flutter/material.dart';
import 'package:sxui/app/Extensions/dashboard_box.dart';
import 'package:sxui/app/shared/constants.dart';

/// A responsive search box for Customers and Patients with autocomplete.
/// - Two columns (Customers / Patient)
/// - Hoverable dropdown options
/// - Scales fonts/padding to fit the tile
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // Sample data for customers and patients
  final List<String> _customers = const [
    'Alice Johnson', 'Aaron Smith', 'Amanda Davis', 'Albert Wilson', 'Amy Brown',
    'Andrew Taylor', 'Angela Martinez', 'Arthur Anderson', 'Ava Thomas',
    'Anthony Moore', 'Alexandra Scott', 'Austin Harris', 'Abigail Clark',
    'Adam Lewis', 'Amber Walker',
  ];

  final List<String> _patients = const [
    'Brian Lee', 'Bella Garcia', 'Benjamin Harris', 'Bianca Clark', 'Blake Lewis',
    'Brooke Robinson', 'Bryan Walker', 'Bailey Young', 'Brandon King',
    'Brianna Wright', 'Bridget Adams', 'Bruno Nelson', 'Barbara Baker',
    'Brandon Hill', 'Belinda Ramirez',
  ];

  // Controllers
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _patientController = TextEditingController();

  @override
  void dispose() {
    _customerController.dispose();
    _patientController.dispose();
    super.dispose();
  }

  /// Filters and sorts names prioritizing first-name matches, then last-name matches.
  List<String> _filterAndSort(List<String> names, String query) {
    final lower = query.toLowerCase();
    final first = <String>[];
    final last = <String>[];

    for (final name in names) {
      final parts = name.toLowerCase().split(' ');
      if (parts.isNotEmpty && parts[0].startsWith(lower)) {
        first.add(name);
      } else if (parts.length > 1 && parts[1].startsWith(lower)) {
        last.add(name);
      }
    }
    return [...first, ...last];
  }

  @override
  Widget build(BuildContext context) {
    return DashboardBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double boxWidth = constraints.maxWidth;

          // Base dimensions for scaling
          const baseWidth = 600.0;
          const baseHeight = 200.0;

          // Use height if you want more precise scaling later; for now width is primary
          final widthScale = boxWidth / baseWidth;
          double scaleFactor = widthScale.clamp(0.8, 1.2);

          // Scaled sizes with clamping
          final double titleFontSize = (18.0 * scaleFactor).clamp(16.0, 24.0);
          final double inputFontSize = (14.0 * scaleFactor).clamp(12.0, 18.0);
          final double padding = (16.0 * scaleFactor).clamp(12.0, 24.0);
          final double spacing = (8.0 * scaleFactor).clamp(4.0, 12.0);

          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Customers
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Customers',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue v) {
                            if (v.text.isEmpty) return const Iterable<String>.empty();
                            return _filterAndSort(_customers, v.text);
                          },
                          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                            // Keep our local controller in sync (optional)
                            _customerController.value = controller.value;
                            controller.addListener(() {
                              _customerController.value = controller.value;
                            });
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              style: TextStyle(color: Colors.white, fontSize: inputFontSize),
                              decoration: InputDecoration(
                                hintText: 'Search Customer',
                                hintStyle: const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                                contentPadding: EdgeInsets.symmetric(vertical: padding / 2),
                              ),
                            );
                          },
                          onSelected: (selection) => _customerController.text = selection,
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4.0,
                                color: Colors.grey[800],
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxHeight: 250.0),
                                  child: SizedBox(
                                    width: boxWidth * 0.45,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length > 10 ? 10 : options.length,
                                      itemBuilder: (context, i) {
                                        final option = options.elementAt(i);
                                        return DropdownOption(option: option, onSelected: onSelected);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: spacing * 2),

                // Patient
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Patient',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue v) {
                            if (v.text.isEmpty) return const Iterable<String>.empty();
                            return _filterAndSort(_patients, v.text);
                          },
                          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                            _patientController.value = controller.value;
                            controller.addListener(() {
                              _patientController.value = controller.value;
                            });
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              style: TextStyle(color: Colors.white, fontSize: inputFontSize),
                              decoration: InputDecoration(
                                hintText: 'Search Patient',
                                hintStyle: const TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                                contentPadding: EdgeInsets.symmetric(vertical: padding / 2),
                              ),
                            );
                          },
                          onSelected: (selection) => _patientController.text = selection,
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4.0,
                                color: Colors.grey[800],
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxHeight: 250.0),
                                  child: SizedBox(
                                    width: boxWidth * 0.45,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length > 10 ? 10 : options.length,
                                      itemBuilder: (context, i) {
                                        final option = options.elementAt(i);
                                        return DropdownOption(option: option, onSelected: onSelected);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DropdownOption extends StatefulWidget {
  final String option;
  final AutocompleteOnSelected<String> onSelected;

  const DropdownOption({
    Key? key,
    required this.option,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<DropdownOption> createState() => _DropdownOptionState();
}

class _DropdownOptionState extends State<DropdownOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit:  (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onSelected(widget.option),
        child: Container(
          color: _isHovered ? darkPurple.withOpacity(0.8) : Colors.grey[800],
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            widget.option,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: _isHovered ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
