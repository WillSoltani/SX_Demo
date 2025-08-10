// File: lib/widgets/dashboard/MainDashboard/Subs/view_customer_profile.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:faker/faker.dart'; // For generating realistic dummy data
import 'dart:math'; // For Random class
import '../../../constants.dart'; // Adjust the path as necessary
import 'dart:async'; // For Timer (debouncing)

class ViewCustomerProfile extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;
  final VoidCallback onClose;
  final Function(String customerName) onOpenTab; // Callback to open a new tab

  const ViewCustomerProfile({
    Key? key,
    required this.logMessages,
    required this.onClose,
    required this.onOpenTab, // Initialize the callback
  }) : super(key: key);

  @override
  _ViewCustomerProfileState createState() => _ViewCustomerProfileState();
}

class _ViewCustomerProfileState extends State<ViewCustomerProfile> {
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _filteredCustomers = [];
  Map<String, bool> _sortAscending = {
    'name': true,
    'email': true,
    'phone': true,
    'type': true,
    'balance': true,
  };
  Map<String, TextEditingController> _searchControllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
  };
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initializeCustomers();
    // Add listeners for debounced search
    _searchControllers.forEach((key, controller) {
      controller.addListener(_onSearchChanged);
    });
  }

  void _initializeCustomers() {
    // Generate realistic dummy customer data
    Faker faker = Faker();
    Random random = Random();
    _customers = List.generate(500, (index) {
      bool isCompany = faker.randomGenerator.boolean();
      String name = isCompany ? faker.company.name() : faker.person.name();
      return {
        'id': Uuid().v4(),
        'name': name,
        'email': faker.internet.email(),
        'phone': faker.phoneNumber.us(),
        'type': isCompany ? 'Company' : 'Individual',
        'balance':
            double.parse((random.nextDouble() * 5000).toStringAsFixed(2)),
      };
    });

    _filteredCustomers = List.from(_customers);
  }

  @override
  void dispose() {
    _searchControllers.values.forEach((controller) => controller.dispose());
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _filteredCustomers = _customers.where((customer) {
          bool matchesName = customer['name']
              .toLowerCase()
              .contains(_searchControllers['name']!.text.toLowerCase());
          bool matchesEmail = customer['email']
              .toLowerCase()
              .contains(_searchControllers['email']!.text.toLowerCase());
          bool matchesPhone = customer['phone']
              .toLowerCase()
              .contains(_searchControllers['phone']!.text.toLowerCase());
          return matchesName && matchesEmail && matchesPhone;
        }).toList();
      });
    });
  }

  void _sort(
      String column, Comparable Function(Map<String, dynamic>) getField) {
    setState(() {
      _filteredCustomers.sort((a, b) {
        int result = getField(a).compareTo(getField(b));
        return _sortAscending[column]! ? result : -result;
      });
      _sortAscending[column] = !_sortAscending[column]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0), // Uniform padding around the container
      child: Container(
        // Gradient Border Container
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              darkPurple,
              darkPurple.withOpacity(0.7),
              darkPurple.withOpacity(0.4),
            ],
          ),
        ),
        child: Container(
          // Inner Container with border and background color
          decoration: BoxDecoration(
            color: Colors.black, // Background color matching the tab
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              SizedBox(height: 16),
              // Search Bars
              _buildSearchRow(),
              SizedBox(height: 16),
              // Data Table
              Expanded(
                child: _buildDataTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchRow() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        constraints:
            BoxConstraints(maxWidth: 1200), // Max width for large screens
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSearchField('name', 'Search Name/Company'),
            SizedBox(width: 16),
            _buildSearchField('email', 'Search Email'),
            SizedBox(width: 16),
            _buildSearchField('phone', 'Search Phone Number'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(String key, String hintText) {
    return Expanded(
      child: TextField(
        controller: _searchControllers[key],
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white70,
          ),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      padding: EdgeInsets.all(8.0), // Padding inside the data area
      color: Colors.grey[850], // Background color for data area
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            // Vertical scrolling
            child: DataTable(
              columnSpacing: 20.0, // Adjust column spacing as needed
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.grey[800]!),
              dataRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.grey[850]!),
              columns: [
                _buildDataColumn('Name/Company', 'name'),
                _buildDataColumn('Email', 'email'),
                _buildDataColumn('Phone Number', 'phone'),
                _buildDataColumn('Type', 'type'),
                _buildDataColumn('Outstanding Balance', 'balance'),
              ],
              rows: _filteredCustomers.map((customer) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        customer['name'],
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        widget.onOpenTab(customer['name']);
                      },
                    ),
                    DataCell(
                      Text(
                        customer['email'],
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        widget.onOpenTab(customer['name']);
                      },
                    ),
                    DataCell(
                      Text(
                        customer['phone'],
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        widget.onOpenTab(customer['name']);
                      },
                    ),
                    DataCell(
                      Text(
                        customer['type'],
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        widget.onOpenTab(customer['name']);
                      },
                    ),
                    DataCell(
                      Text(
                        NumberFormat.currency(symbol: '\$')
                            .format(customer['balance']),
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        widget.onOpenTab(customer['name']);
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  DataColumn _buildDataColumn(String label, String columnKey) {
    return DataColumn(
      label: GestureDetector(
        onTap: () {
          _onColumnHeaderTap(columnKey);
        },
        child: Row(
          children: [
            Text(
              label,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 4),
            Icon(
              _sortAscending[columnKey]!
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
      numeric: columnKey == 'balance' ? true : false,
    );
  }

  void _onColumnHeaderTap(String columnKey) {
    switch (columnKey) {
      case 'name':
        _sort('name', (d) => d['name'] as String);
        break;
      case 'email':
        _sort('email', (d) => d['email'] as String);
        break;
      case 'phone':
        _sort('phone', (d) => d['phone'] as String);
        break;
      case 'type':
        _sort('type', (d) => d['type'] as String);
        break;
      case 'balance':
        _sort('balance', (d) => d['balance'] as double);
        break;
    }
  }
}
