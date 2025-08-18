// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import 'loginpage.dart'; // Import login_page.dart
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login/Signup Animation',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginPage(), // Set the home to LoginPage
//     );
//   }
// }

// enum Selection { tryIn, finish }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController searchCustomerController = TextEditingController();
//   final TextEditingController searchPatientController = TextEditingController();
//   String addressInfo = ''; // Holds the dynamic address information

//   // Controllers for the new fields
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController invoiceNumberController = TextEditingController();
//   final TextEditingController dueDateController = TextEditingController();

//   // Radio button selection
//   Selection? _selectedOption = Selection.tryIn;

//   @override
//   void initState() {
//     super.initState();
//     dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Set current date
//     invoiceNumberController.text = '696969'; // Set default invoice number
//   }

//   // Data for the table
//   List<Map<String, dynamic>> tableData = [
//     {'No': 1, 'Item': '', 'Quantity': '', 'Description': '', 'Price': '', 'Total': ''},
//     {'No': 2, 'Item': '', 'Quantity': '', 'Description': '', 'Price': '', 'Total': ''},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sales and Invoicing'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: <Widget>[
//                   _buildButton('Void', () {
//                     print('Void button pressed');
//                   }),
//                   _buildButton('Email/Print', () {
//                     print('Email/Print button pressed');
//                   }),
//                   _buildButton('Return', () {
//                     print('Return button pressed');
//                   }),
//                   _buildButton('Exchange', () {
//                     print('Exchange button pressed');
//                   }),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Column for the two search boxes
//                   Column(
//                     children: [
//                       _buildSearchBox('Search Customer', searchCustomerController, isCustomer: true),
//                       SizedBox(height: 10),
//                       _buildSearchBox('Search Patient', searchPatientController),
//                     ],
//                   ),
//                   SizedBox(width: 10),
//                   // Address Information box
//                   _buildAddressInfoBox(),
//                   SizedBox(width: 10),
//                   // Column for the Date, Invoice Number, and Due Date
//                   Column(
//                     children: [
//                       _buildReadOnlyTextBox('Date', dateController),
//                       SizedBox(height: 10),
//                       _buildReadOnlyTextBox('Invoice Number', invoiceNumberController),
//                       SizedBox(height: 10),
//                       _buildDueDateTextBox(),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),

//               // Radio buttons
//               Row(
//                 children: [
//                   Text('Try-in', style: TextStyle(color: Colors.black)),
//                   Radio<Selection>(
//                     value: Selection.tryIn,
//                     groupValue: _selectedOption,
//                     onChanged: (Selection? value) {
//                       setState(() {
//                         _selectedOption = value;
//                       });
//                     },
//                   ),
//                   SizedBox(width: 20),
//                   Text('Finish', style: TextStyle(color: Colors.black)),
//                   Radio<Selection>(
//                     value: Selection.finish,
//                     groupValue: _selectedOption,
//                     onChanged: (Selection? value) {
//                       setState(() {
//                         _selectedOption = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               _buildTable(),
//               SizedBox(height: 20),

//               // Buttons at the bottom right of the table
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         print('Process button pressed');
//                       },
//                       child: Text('Process'),
//                     ),
//                     SizedBox(width: 10),
//                     ElevatedButton(
//                       onPressed: () {
//                         print('Finish button pressed');
//                       },
//                       child: Text('Finish'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBox(String hint, TextEditingController controller, {bool isCustomer = false}) {
//     return Container(
//       width: 250,
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: OutlineInputBorder(),
//           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         ),
//         onSubmitted: (String value) {
//           print('Entered text for $hint: $value');
//           if (isCustomer && value.isNotEmpty) {
//             // Update the address information when a customer is selected
//             setState(() {
//               addressInfo = 'Ottawa, mioone hameye kooh ha, ye takhte do nafareye meshki ba kiaye takht baaz roosh:)';
//             });
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildAddressInfoBox() {
//     return Container(
//       width: 250, // Same width as the search boxes
//       height: 100, // Height equal to the combined height of the two search boxes
//       child: TextField(
//         enabled: false, // Makes the text box read-only
//         maxLines: null, // Allows the text box to adjust content height if needed
//         decoration: InputDecoration(
//           hintText: 'Address Information',
//           border: OutlineInputBorder(),
//           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         ),
//         controller: TextEditingController(text: addressInfo),
//       ),
//     );
//   }

//   Widget _buildReadOnlyTextBox(String label, TextEditingController controller) {
//     return Container(
//       width: 250,
//       child: TextField(
//         controller: controller,
//         enabled: false, // Read-only
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         ),
//       ),
//     );
//   }

//   Widget _buildDueDateTextBox() {
//     return Container(
//       width: 250,
//       child: TextField(
//         controller: dueDateController,
//         readOnly: true,
//         decoration: InputDecoration(
//           labelText: 'Due Date',
//           border: OutlineInputBorder(),
//           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         ),
//         onTap: () async {
//           DateTime? pickedDate = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(2000),
//             lastDate: DateTime(2101),
//           );

//           if (pickedDate != null) {
//             TimeOfDay? pickedTime = await showTimePicker(
//               context: context,
//               initialTime: TimeOfDay.now(),
//             );

//             if (pickedTime != null) {
//               setState(() {
//                 final DateTime fullDateTime = DateTime(
//                   pickedDate.year,
//                   pickedDate.month,
//                   pickedDate.day,
//                   pickedTime.hour,
//                   pickedTime.minute,
//                 );
//                 dueDateController.text = DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime);
//               });
//             }
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildButton(String text, VoidCallback onPressed) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//       child: TextButton(
//         onPressed: onPressed,
//         style: TextButton.styleFrom(
//           foregroundColor: Colors.black,
//           side: BorderSide(color: Colors.black, width: 1),
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//     );
//   }

//   Widget _buildTable() {
//     return Table(
//       columnWidths: const {
//         0: FixedColumnWidth(40),  // "No" column
//         1: FlexColumnWidth(2),    // "Item" column
//         2: FixedColumnWidth(70),  // "Quantity" column
//         3: FlexColumnWidth(3),    // "Description" column
//         4: FixedColumnWidth(80),  // "Price" column
//         5: FixedColumnWidth(80),  // "Total" column
//       },
//       border: TableBorder.all(),
//       children: [
//         // Table Header
//         TableRow(
//           decoration: BoxDecoration(color: Colors.grey[300]),
//           children: [
//             _buildTableCell('No', isHeader: true),
//             _buildTableCell('Item', isHeader: true),
//             _buildTableCell('Quantity', isHeader: true),
//             _buildTableCell('Description', isHeader: true),
//             _buildTableCell('Price', isHeader: true),
//             _buildTableCell('Total', isHeader: true),
//           ],
//         ),
//         // Table Rows
//         for (var i = 0; i < tableData.length; i++) _buildTableRow(i),
//       ],
//     );
//   }

//   TableRow _buildTableRow(int index) {
//     var row = tableData[index];
//     return TableRow(
//       children: [
//         _buildTableCell('${row['No']}'), // No
//         _buildEditableTableCell(row, 'Item', index),
//         _buildEditableTableCell(row, 'Quantity', index),
//         _buildTableCell(row['Description'] ?? ''), // Description
//         _buildEditableTableCell(row, 'Price', index),
//         _buildTableCell(row['Total'] ?? ''), // Total
//       ],
//     );
//   }

//   Widget _buildTableCell(String text, {bool isHeader = false}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableTableCell(Map<String, dynamic> row, String key, int index) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: TextEditingController.fromValue(
//           TextEditingValue(
//             text: row[key]?.toString() ?? '',
//             selection: TextSelection.collapsed(offset: row[key]?.toString().length ?? 0),
//           ),
//         ),
//         decoration: InputDecoration(
//           border: InputBorder.none,
//         ),
//         keyboardType: key == 'Quantity' || key == 'Price' ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
//         onChanged: (value) {
//           setState(() {
//             row[key] = value;
//             if (key == 'Item') {
//               if (value.isEmpty) {
//                 // Clear the description and price if the item is cleared
//                 row['Description'] = '';
//                 row['Price'] = '';
//               } else {
//                 row['Description'] = 'Description XXX';
//                 if (row['Price'] == '') {
//                   row['Price'] = '69.00'; // Default price in float format
//                 }
//               }
//             }
//             if (key == 'Quantity' || key == 'Price') {
//               double quantity = double.tryParse(row['Quantity'] ?? '0') ?? 0.0;
//               double price = double.tryParse(row['Price']?.replaceAll('\$', '') ?? '') ?? 0.0;
//               row['Total'] = '\$' + (quantity * price).toStringAsFixed(2);
//             }
//             _updateTableRows();
//           });
//         },
//       ),
//     );
//   }

//   void _updateTableRows() {
//     // Add new empty rows if needed to keep 2 extra empty rows
//     if (tableData.where((row) => row['Item'].isEmpty && row['Quantity'].isEmpty).length < 2) {
//       int currentLength = tableData.length;
//       tableData.add({'No': currentLength + 1, 'Item': '', 'Quantity': '', 'Description': '', 'Price': '', 'Total': ''});
//     }
//   }
// }

