// File: dashboard/boxes/add_customer.dart

// Author: Will Soltani
// Version: 1.11
// Revised: 14-10-2024

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

  // State variables for dropdown and radio button selections
  String _selectedType = '---';
  String? _statementDeliveryMethod; // 'Email' or 'Printed Paper'

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
        .where((address) =>
            address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Toggles the selection between Account Info and Billing Info.
  void _toggleSection(bool isBilling) {
    setState(() {
      _isBillingInfoSelected = isBilling;
    });
  }

  /// Widget for individual form fields to reduce redundancy
  Widget _buildFormField({
    required String label,
    required Widget field,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 5),
          field,
        ],
      ),
    );
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
                    // Structured Layout for Alignment
                    Column(
                      children: [
                        // First Row: First Name & Last Name
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'First Name',
                                field: TextFormField(
                                  controller: _firstNameController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'First Name',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
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
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _buildFormField(
                                label: 'Last Name',
                                field: TextFormField(
                                  controller: _lastNameController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
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
                              ),
                            ),
                          ],
                        ),

                        // Second Row: Company Name & Email
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'Company Name',
                                field: TextFormField(
                                  controller: _companyNameController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Company Name',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
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
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _buildFormField(
                                label: 'Email',
                                field: TextFormField(
                                  controller: _emailController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
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
                              ),
                            ),
                          ],
                        ),

                        // Third Row: Phone Number 1 & Secondary Phone Number
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'Phone Number 1',
                                field: TextFormField(
                                  controller: _phoneNumber1Controller,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Phone Number 1',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
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
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _buildFormField(
                                label: 'Secondary Phone Number',
                                field: TextFormField(
                                  controller: _secondaryPhoneController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Secondary Phone Number',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    // Implement phone number formatting if needed
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Fourth Row: Fax & Address
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'Fax',
                                field: TextFormField(
                                  controller: _faxController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Fax Number',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _buildFormField(
                                label: 'Address',
                                field: TypeAheadFormField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    controller: _addressController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Address',
                                      hintStyle: TextStyle(
                                          color: Colors.white54),
                                      filled: true,
                                      fillColor: Colors.grey[800],
                                      helperText:
                                          ' ', // Reserve space for error
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    return _getAddressSuggestions(pattern);
                                  },
                                  itemBuilder:
                                      (context, String suggestion) {
                                    return ListTile(
                                      title: Text(
                                        suggestion,
                                        style: TextStyle(
                                            color: Colors.black),
                                      ),
                                    );
                                  },
                                  onSuggestionSelected:
                                      (String suggestion) {
                                    _addressController.text = suggestion;
                                    // Auto-fill related fields based on the selected address
                                    // For demonstration, we'll mock the data
                                    setState(() {
                                      _cityController.text =
                                          'Sample City';
                                      _provinceController.text =
                                          'Sample Province';
                                      _countryController.text =
                                          'Sample Country';
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
                              ),
                            ),
                          ],
                        ),

                        // Fifth Row: Type (Dropdown) & Province/State
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'Type',
                                field: DropdownButtonFormField<String>(
                                  value: _selectedType,
                                  items: [
                                    DropdownMenuItem(
                                      value: '---',
                                      child: Text(
                                        '---',
                                        style:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Dentist',
                                      child: Text(
                                        'Dentist',
                                        style:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Denturist',
                                      child: Text(
                                        'Denturist',
                                        style:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Lab',
                                      child: Text(
                                        'Lab',
                                        style:
                                            TextStyle(color: Colors.white),
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
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style:
                                      TextStyle(color: Colors.white),
                                  dropdownColor: Colors.grey[800],
                                  validator: (value) {
                                    if (value == null ||
                                        value == '---') {
                                      return 'Please select a valid type';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _buildFormField(
                                label: 'Province/State',
                                field: TextFormField(
                                  controller: _provinceController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Province/State',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Sixth Row: City & Postal Code
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'City',
                                field: TextFormField(
                                  controller: _cityController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'City',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: _buildFormField(
                                label: 'Postal Code',
                                field: TextFormField(
                                  controller: _postalCodeController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Postal Code',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Postal code is required';
                                    }
                                    // Simple postal code validation
                                    if (!RegExp(r'^\d{4,10}$')
                                        .hasMatch(value)) {
                                      return 'Enter a valid postal code';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Seventh Row: Country & Statement Delivery Method
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'Country',
                                field: TextFormField(
                                  controller: _countryController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Country',
                                    hintStyle:
                                        TextStyle(color: Colors.white54),
                                    filled: true,
                                    fillColor: Colors.grey[800],
                                    helperText:
                                        ' ', // Reserve space for error
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: FormField<String>(
                                validator: (value) {
                                  if (_statementDeliveryMethod ==
                                          null ||
                                      _statementDeliveryMethod!
                                          .isEmpty) {
                                    return 'Please select a statement delivery method';
                                  }
                                  return null;
                                },
                                builder:
                                    (FormFieldState<String> state) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Statement Delivery Method',
                                          style: TextStyle(
                                              color: Colors.white),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            // Email Radio Button
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Radio<String>(
                                                    value: 'Email',
                                                    groupValue:
                                                        _statementDeliveryMethod,
                                                    onChanged:
                                                        (String? value) {
                                                      setState(() {
                                                        _statementDeliveryMethod =
                                                            value;
                                                      });
                                                      state.didChange(value);
                                                    },
                                                    activeColor:
                                                        Colors.deepPurpleAccent,
                                                  ),
                                                  Text(
                                                    'Email',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Printed Paper Radio Button
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Radio<String>(
                                                    value: 'Printed Paper',
                                                    groupValue:
                                                        _statementDeliveryMethod,
                                                    onChanged:
                                                        (String? value) {
                                                      setState(() {
                                                        _statementDeliveryMethod =
                                                            value;
                                                      });
                                                      state.didChange(value);
                                                    },
                                                    activeColor:
                                                        Colors.deepPurpleAccent,
                                                  ),
                                                  Text(
                                                    'Printed Paper',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Display validation error if any
                                        if (state.hasError)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Text(
                                              state.errorText!,
                                              style: TextStyle(
                                                color: Colors.red[700],
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Additional Info
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 5.0),
                      child: _buildFormField(
                        label: 'Additional Info',
                        field: TextFormField(
                          controller: _additionalInfoController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText:
                                'Enter additional information here...',
                            hintStyle:
                                TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.grey[800],
                            helperText:
                                ' ', // Reserve space for error
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: 1, // Reduced to one line
                        ),
                      ),
                    ),

                    // Create Customer Button with enhanced styling
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 10.0),
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
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              boxShadow: _isCreateButtonHovered
                                  ? [
                                      BoxShadow(
                                        color: Colors.deepPurpleAccent
                                            .withOpacity(0.6),
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.transparent,
                                      ),
                                    ],
                              borderRadius:
                                  BorderRadius.circular(12.0),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: Icon(
                                Icons.person_add,
                                color: Colors.white,
                                ),
                              label: Text(
                                'Create Customer',
                                style: TextStyle(
                                  fontSize: 18, // Increased font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isCreateButtonHovered
                                    ? Colors.deepPurpleAccent
                                    : Colors.deepPurple, // Dynamic color
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16), // Larger padding
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12.0),
                                ),
                                elevation: 5, // Added elevation
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
        )
      )
    );
      }
    }
