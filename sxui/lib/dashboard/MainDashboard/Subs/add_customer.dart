// File: dashboard/boxes/add_customer.dart

// Author: Will Soltani
// Version: 1.5
// Revised: 07-10-2024

// This widget, AddCustomer, provides a form to add new customers.
// It includes "Account Info" and "Billing Info" sections with various input fields,
// validation logic, and address autocomplete functionality.

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart'; // Ensure this dependency is added in pubspec.yaml
import '../../Extensions/tab_properties.dart'; // Import the new tab_properties.dart file

class AddCustomer extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;
  final VoidCallback onClose;

  const AddCustomer({
    Key? key,
    required this.logMessages,
    required this.onClose,
  }) : super(key: key);

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isBillingInfoSelected = false;

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _phoneNumber1Controller = TextEditingController();
  final TextEditingController _faxController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _secondaryPhoneController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  // New Controller for "Type" field
  String _selectedType = '---';

  // Mock address suggestions
  List<String> _addressSuggestions = [
    '123 Main St',
    '456 Elm St',
    '789 Oak Ave',
    '321 Pine Rd',
    '654 Maple Blvd',
    '987 Cedar Ln',
    '159 Spruce St',
    '753 Birch Ave',
  ];

  // Hover state variable for Create Customer button
  bool _isCreateButtonHovered = false;

  @override
  void dispose() {
    // Dispose controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _phoneNumber1Controller.dispose();
    _faxController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _secondaryPhoneController.dispose();
    _addressController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  /// Handles form submission and validation.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed to create customer
      widget.logMessages.value = [
        ...widget.logMessages.value,
        {
          'description':
              '🌟 USER 1 created a new customer: ${_firstNameController.text} ${_lastNameController.text}',
          'completed': false,
        },
      ];
      widget.logMessages.notifyListeners();

      // Optionally, reset the form or provide feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Customer created successfully!')),
      );

      // Close the tab after creation
      widget.onClose();
    }
  }

  /// Provides address suggestions based on user input.
  List<String> _getAddressSuggestions(String query) {
    return _addressSuggestions
        .where((address) => address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Toggles the selection between Account Info and Billing Info.
  void _toggleSection(bool isBilling) {
    setState(() {
      _isBillingInfoSelected = isBilling;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TabProperties(
      title: 'Add Customer',
      onClose: widget.onClose,
      onMinimize: () {
        // Implement minimize functionality if needed
      },
      onResize: () {
        // Implement resize functionality if needed
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Tabs for Account Info and Billing Info
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _toggleSection(false),
                    child: Text(
                      'Account Info',
                      style: TextStyle(
                        fontSize: _isBillingInfoSelected ? 16 : 20,
                        fontWeight: FontWeight.bold,
                        color: _isBillingInfoSelected
                            ? Colors.grey
                            : Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  GestureDetector(
                    onTap: () => _toggleSection(true),
                    child: Text(
                      'Billing Info',
                      style: TextStyle(
                        fontSize: _isBillingInfoSelected ? 20 : 16,
                        fontWeight: FontWeight.bold,
                        color: _isBillingInfoSelected
                            ? Colors.deepPurpleAccent
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey),
            // Form Section
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Left Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First Name
                              Text(
                                'First Name',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _firstNameController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'First Name',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'First name is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // Company Name
                              Text(
                                'Company Name',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _companyNameController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Company Name',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if ((_firstNameController.text.isEmpty ||
                                          _lastNameController.text.isEmpty) &&
                                      (value == null || value.isEmpty)) {
                                    return 'Company name is required if first or last name is missing';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // Phone Number 1
                              Text(
                                'Phone Number 1',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _phoneNumber1Controller,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Phone Number 1',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  // Implement phone number formatting if needed
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  // Simple phone number validation
                                  if (!RegExp(r'^\+?\d{7,15}$')
                                      .hasMatch(value)) {
                                    return 'Enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // Fax
                              Text(
                                'Fax',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _faxController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Fax Number',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // Type (New Field)
                              Text(
                                'Type',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              DropdownButtonFormField<String>(
                                value: _selectedType,
                                items: [
                                  DropdownMenuItem(
                                    value: '---',
                                    child: Text(
                                      '---',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Dentist',
                                    child: Text(
                                      'Dentist',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Denturist',
                                    child: Text(
                                      'Denturist',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Lab',
                                    child: Text(
                                      'Lab',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedType = newValue!;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                                dropdownColor: Colors.grey[800],
                                validator: (value) {
                                  if (value == null || value == '---') {
                                    return 'Please select a valid type';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // City
                              Text(
                                'City',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _cityController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'City',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // Country
                              Text(
                                'Country',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _countryController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Country',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20), // Increased bottom margin
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        // Right Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Last Name
                              Text(
                                'Last Name',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _lastNameController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Last Name',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Last name is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // Email
                              Text(
                                'Email',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _emailController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // Secondary Phone Number
                              Text(
                                'Secondary Phone Number',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _secondaryPhoneController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Secondary Phone Number',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  // Implement phone number formatting if needed
                                },
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // Address with Autocomplete
                              Text(
                                'Address',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: _addressController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Address',
                                    hintStyle: TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                suggestionsCallback: (pattern) {
                                  return _getAddressSuggestions(pattern);
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(
                                      suggestion,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  _addressController.text = suggestion;
                                  // Auto-fill related fields based on the selected address
                                  // For demonstration, we'll mock the data
                                  setState(() {
                                    _cityController.text = 'Sample City';
                                    _provinceController.text =
                                        'Sample Province';
                                    _countryController.text = 'Sample Country';
                                    _postalCodeController.text = '12345';
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Address is required';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // Province/State
                              Text(
                                'Province/State',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _provinceController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Province/State',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20), // Increased bottom margin

                              // Postal Code
                              Text(
                                'Postal Code',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: _postalCodeController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Postal Code',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Postal code is required';
                                  }
                                  // Simple postal code validation
                                  if (!RegExp(r'^\d{4,10}$').hasMatch(value)) {
                                    return 'Enter a valid postal code';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20), // Increased bottom margin
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Additional Info
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional Info',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: _additionalInfoController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter additional information here...',
                              hintStyle: TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            maxLines: 1, // Reduced to one line
                          ),
                          SizedBox(
                              height:
                                  20), // Added space to accommodate error messages
                        ],
                      ),
                    ),
                    // Create Customer Button with hover effects
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              _isCreateButtonHovered = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              _isCreateButtonHovered = false;
                            });
                          },
                          child: AnimatedScale(
                            scale: _isCreateButtonHovered
                                ? 1.05
                                : 1.0, // Slightly larger on hover
                            duration: Duration(milliseconds: 200),
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.deepPurple, // Button color
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                textStyle: TextStyle(
                                  fontSize: _isCreateButtonHovered
                                      ? 18
                                      : 16, // Increase font size on hover
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: Text(
                                'Create Customer',
                                style: TextStyle(
                                    color: Colors
                                        .white), // Set text color to white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
