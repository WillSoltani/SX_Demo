// box_x5.dart

import 'package:flutter/material.dart';
import '../widgets/dashboard_box.dart';
import '../constants.dart';

class BoxX5 extends StatefulWidget {
  const BoxX5({Key? key}) : super(key: key);

  @override
  _BoxX5State createState() => _BoxX5State();
}

class _BoxX5State extends State<BoxX5> {
  // Sample data for customers and patients
  final List<String> _customers = [
    'Alice Johnson',
    'Aaron Smith',
    'Amanda Davis',
    'Albert Wilson',
    'Amy Brown',
    'Andrew Taylor',
    'Angela Martinez',
    'Arthur Anderson',
    'Ava Thomas',
    'Anthony Moore',
    'Alexandra Scott',
    'Austin Harris',
    'Abigail Clark',
    'Adam Lewis',
    'Amber Walker',
  ];

  final List<String> _patients = [
    'Brian Lee',
    'Bella Garcia',
    'Benjamin Harris',
    'Bianca Clark',
    'Blake Lewis',
    'Brooke Robinson',
    'Bryan Walker',
    'Bailey Young',
    'Brandon King',
    'Brianna Wright',
    'Bridget Adams',
    'Bruno Nelson',
    'Barbara Baker',
    'Brandon Hill',
    'Belinda Ramirez',
  ];

  // Controllers for the search fields
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _patientController = TextEditingController();

  @override
  void dispose() {
    _customerController.dispose();
    _patientController.dispose();
    super.dispose();
  }

  // Helper function to filter and sort names based on query
  List<String> _filterAndSort(List<String> names, String query) {
    final lowerQuery = query.toLowerCase();

    // Split names into first and last names
    final List<String> firstNameMatches = [];
    final List<String> lastNameMatches = [];

    for (var name in names) {
      final parts = name.toLowerCase().split(' ');
      if (parts.isNotEmpty && parts[0].startsWith(lowerQuery)) {
        firstNameMatches.add(name);
      } else if (parts.length > 1 && parts[1].startsWith(lowerQuery)) {
        lastNameMatches.add(name);
      }
    }

    // Combine the lists with first name matches first
    return [...firstNameMatches, ...lastNameMatches];
  }

  @override
  Widget build(BuildContext context) {
    return DashboardBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double boxWidth = constraints.maxWidth;
          final double boxHeight = constraints.maxHeight;

          // Define base dimensions for scaling
          const double baseWidth = 600.0;
          const double baseHeight = 200.0;

          // Calculate scaling factors based on available space
          double widthScale = boxWidth / baseWidth;
          double heightScale = boxHeight / baseHeight;
          double scaleFactor = widthScale < heightScale ? widthScale : heightScale;

          // Clamp the scaleFactor to prevent excessive scaling
          scaleFactor = scaleFactor.clamp(0.8, 1.2);

          // Define scaled sizes with clamping for readability
          double titleFontSize = (18.0 * scaleFactor).clamp(16.0, 24.0); // Increased title font size
          double inputFontSize = (14.0 * scaleFactor).clamp(12.0, 18.0);
          double padding = (16.0 * scaleFactor).clamp(12.0, 24.0);
          double spacing = (8.0 * scaleFactor).clamp(4.0, 12.0);

          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left Side: Customers
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title: Customers
                      Text(
                        "Customers",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      // Search Box: Search Customer
                      FractionallySizedBox(
                        widthFactor: 0.9, // 90% width of the parent (10% narrower)
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            }
                            return _filterAndSort(
                                _customers, textEditingValue.text);
                          },
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            // Assign the controller
                            _customerController.text =
                                fieldTextEditingController.text;
                            fieldTextEditingController.addListener(() {
                              _customerController.text =
                                  fieldTextEditingController.text;
                            });
                            return TextField(
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              style: TextStyle(
                                color: Colors.white, // White input text
                                fontSize: inputFontSize,
                              ),
                              decoration: InputDecoration(
                                hintText: "Search Customer",
                                hintStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.white70),
                              ),
                            );
                          },
                          onSelected: (String selection) {
                            _customerController.text = selection;
                          },
                          optionsViewBuilder: (BuildContext context,
                              AutocompleteOnSelected<String> onSelected,
                              Iterable<String> options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4.0,
                                color: Colors.grey[800],
                                child: Container(
                                  width: boxWidth * 0.45, // Match parent width
                                  constraints: BoxConstraints(
                                    maxHeight: 250.0, // Approx. 10 items
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount:
                                        options.length > 10 ? 10 : options.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final String option =
                                          options.elementAt(index);
                                      return DropdownOption(
                                        option: option,
                                        onSelected: onSelected,
                                      );
                                    },
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
                SizedBox(width: spacing * 2), // Space between the two sections
                // Right Side: Patient
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title: Patient
                      Text(
                        "Patient",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      // Search Box: Search Patient
                      FractionallySizedBox(
                        widthFactor: 0.9, // 90% width of the parent (10% narrower)
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            }
                            return _filterAndSort(
                                _patients, textEditingValue.text);
                          },
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            // Assign the controller
                            _patientController.text =
                                fieldTextEditingController.text;
                            fieldTextEditingController.addListener(() {
                              _patientController.text =
                                  fieldTextEditingController.text;
                            });
                            return TextField(
                              controller: fieldTextEditingController,
                              focusNode: fieldFocusNode,
                              style: TextStyle(
                                color: Colors.white, // White input text
                                fontSize: inputFontSize,
                              ),
                              decoration: InputDecoration(
                                hintText: "Search Patient",
                                hintStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.white70),
                              ),
                            );
                          },
                          onSelected: (String selection) {
                            _patientController.text = selection;
                          },
                          optionsViewBuilder: (BuildContext context,
                              AutocompleteOnSelected<String> onSelected,
                              Iterable<String> options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                elevation: 4.0,
                                color: Colors.grey[800],
                                child: Container(
                                  width: boxWidth * 0.45, // Match parent width
                                  constraints: BoxConstraints(
                                    maxHeight: 250.0, // Approx. 10 items
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount:
                                        options.length > 10 ? 10 : options.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final String option =
                                          options.elementAt(index);
                                      return DropdownOption(
                                        option: option,
                                        onSelected: onSelected,
                                      );
                                    },
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
  _DropdownOptionState createState() => _DropdownOptionState();
}

class _DropdownOptionState extends State<DropdownOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.onSelected(widget.option);
        },
        child: Container(
          color: _isHovered
              ? darkPurple.withOpacity(0.8)
              : Colors.grey[800],
          padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            widget.option,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight:
                  _isHovered ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
