// File: lib/widgets/dashboard/MainDashboard/Subs/inventory.dart

// Author: Will
// Version: 1.0
// Revised: 15-10-2024

// This widget, InventoryManagement, displays the inventory management section with search
// functionalities and action buttons for adding products, exporting, and importing data.

import 'dart:async';
import 'dart:math'; // For generating random prices
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting currency
import 'package:uuid/uuid.dart'; // For generating unique IDs
import 'package:sxui/app/constants.dart';
import '../../../Extensions/hoverable_expanded_item.dart'; // Import the hoverable item

class InventoryManagement extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;
  final VoidCallback onClose;
  final Function(String productId)
      onOpenTab; // Callback to open a product detail tab
  final VoidCallback onAddProduct; // Callback to open the Add Product tab

  const InventoryManagement({
    Key? key,
    required this.logMessages,
    required this.onClose,
    required this.onOpenTab, // Initialize the callback for product details
    required this.onAddProduct, // Initialize the callback for adding a product
  }) : super(key: key);

  @override
  _InventoryManagementState createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> {
  // Controllers for search fields
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Timer for debounced search
  Timer? _debounce;

  // Mock data
  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  Map<String, bool> _sortAscending = {
    'productId': true,
    'productName': true,
    'description': true,
    'price': true,
  };

  @override
  void initState() {
    super.initState();
    // Generate mock data
    _generateMockData();

    // Initialize filtered products
    _filteredProducts = List.from(_allProducts);

    // Add listeners for debounced search
    _productIdController.addListener(_onSearchChanged);
    _productNameController.addListener(_onSearchChanged);
    _descriptionController.addListener(_onSearchChanged);
  }

  void _generateMockData() {
    var uuid = Uuid();
    var random = Random();
    for (int i = 1; i <= 200; i++) {
      _allProducts.add({
        'id': uuid.v4(),
        'productId': 'PID${i.toString().padLeft(4, '0')}',
        'productName': 'Product $i',
        'description': 'Description for Product $i',
        'price': (random.nextDouble() * 100).toStringAsFixed(2),
      });
    }
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      // Implement search functionality
      setState(() {
        _filteredProducts = _allProducts.where((product) {
          final productIdMatch = product['productId']
              .toString()
              .toLowerCase()
              .contains(_productIdController.text.toLowerCase());
          final productNameMatch = product['productName']
              .toString()
              .toLowerCase()
              .contains(_productNameController.text.toLowerCase());
          final descriptionMatch = product['description']
              .toString()
              .toLowerCase()
              .contains(_descriptionController.text.toLowerCase());
          return productIdMatch && productNameMatch && descriptionMatch;
        }).toList();
      });
    });
  }

  void _sort(
      String column, Comparable Function(Map<String, dynamic>) getField) {
    setState(() {
      _filteredProducts.sort((a, b) {
        int result = getField(a).compareTo(getField(b));
        return _sortAscending[column]! ? result : -result;
      });
      _sortAscending[column] = !_sortAscending[column]!;
    });
  }

  void _onAddProduct() {
    // Use the onAddProduct callback to open the Add Product tab
    widget.onAddProduct();
  }

  void _onExport() {
    // Show export formats dropdown
    showDialog(
      context: context,
      builder: (context) {
        return _buildDropdownDialog('Export Formats', [
          '.csv',
          '.json',
          'Excel (.xlsx)',
        ]);
      },
    );
  }

  void _onImport() {
    // Show import formats dropdown
    showDialog(
      context: context,
      builder: (context) {
        return _buildDropdownDialog('Import Formats', [
          '.csv',
          '.json',
          'Excel (.xlsx)',
        ]);
      },
    );
  }

  Widget _buildDropdownDialog(String title, List<String> options) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: darkPurple)),
      content: Container(
        width: double.minPositive,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map(
                (option) => ListTile(
                  title: Text(option),
                  onTap: () {
                    Navigator.of(context).pop();
                    // Implement format selection functionality here later
                    print('$title selected: $option');
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _openProductTab(String productId) {
    // Use the onOpenTab callback to open a new tab with product details
    widget.onOpenTab(productId);
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
              // Search Bars and Action Buttons
              _buildSearchAndActionsRow(),
              SizedBox(height: 16),
              // Data Table with Mock Data
              Expanded(
                child: _buildDataTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndActionsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Add Product Button
          Expanded(
            flex: 1,
            child: _buildActionButton(
              label: 'Add Product',
              icon: Icons.add,
              onPressed: _onAddProduct,
            ),
          ),
          SizedBox(width: 16),
          // Search Fields
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: _buildSearchField(
                      _productIdController, 'Search Product ID'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildSearchField(
                      _productNameController, 'Search Product Name'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildSearchField(
                      _descriptionController, 'Search Description'),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          // Export Button
          Expanded(
            flex: 1,
            child: _buildActionButton(
              label: 'Export',
              icon: Icons.file_download,
              onPressed: _onExport,
            ),
          ),
          SizedBox(width: 16),
          // Import Button
          Expanded(
            flex: 1,
            child: _buildActionButton(
              label: 'Import',
              icon: Icons.file_upload,
              onPressed: _onImport,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(TextEditingController controller, String hintText) {
    return SizedBox(
      height: 48.0,
      child: TextField(
        controller: controller,
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
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48.0, // Match the height of the search bars
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return darkPurple.withOpacity(0.8); // Hover color
                }
                return darkPurple; // Default color
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            elevation: MaterialStateProperty.all<double>(4.0),
            shadowColor: MaterialStateProperty.all<Color>(
              darkPurple.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildDataTable() {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 16.0), // Margin on left and right
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double totalWidth = constraints.maxWidth;
          double columnSpacing = 16.0;
          int columnCount = 4; // Updated to 4 columns
          double cellWidth =
              (totalWidth - (columnSpacing * (columnCount - 1))) / columnCount;

          return SingleChildScrollView(
            child: DataTable(
              columnSpacing: columnSpacing,
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.grey[800]!),
              dataRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.grey[850]!),
              columns: [
                _buildDataColumn('Product ID', 'productId', cellWidth),
                _buildDataColumn('Product Name', 'productName', cellWidth),
                _buildDataColumn('Description', 'description', cellWidth),
                _buildDataColumn('Price', 'price', cellWidth, numeric: true),
              ],
              rows: _filteredProducts.map((product) {
                return DataRow(
                  cells: [
                    DataCell(
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: cellWidth,
                          child: Text(
                            product['productId'],
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openProductTab(product['productId']);
                      },
                    ),
                    DataCell(
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: cellWidth,
                          child: Text(
                            product['productName'],
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openProductTab(product['productId']);
                      },
                    ),
                    DataCell(
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: cellWidth,
                          child: Text(
                            product['description'],
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openProductTab(product['productId']);
                      },
                    ),
                    DataCell(
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          width: cellWidth,
                          child: Text(
                            '\$${product['price']}',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      onTap: () {
                        _openProductTab(product['productId']);
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

  DataColumn _buildDataColumn(
    String label,
    String columnKey,
    double width, {
    bool numeric = false,
  }) {
    return DataColumn(
      label: GestureDetector(
        onTap: () {
          _onColumnHeaderTap(columnKey);
        },
        child: Container(
          width: width,
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
      ),
      numeric: numeric,
    );
  }

  void _onColumnHeaderTap(String columnKey) {
    switch (columnKey) {
      case 'productId':
        _sort('productId', (d) => d['productId'] as String);
        break;
      case 'productName':
        _sort('productName', (d) => d['productName'] as String);
        break;
      case 'description':
        _sort('description', (d) => d['description'] as String);
        break;
      case 'price':
        _sort('price', (d) => double.parse(d['price']));
        break;
    }
  }
}
