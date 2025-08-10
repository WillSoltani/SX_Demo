import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:uuid/uuid.dart';
import 'package:email_validator/email_validator.dart'; // Ensure the package is imported


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
  // Form keys for each step
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // Step 0: First Name, Last Name, Company
    GlobalKey<FormState>(), // Step 1: Contact Information
    GlobalKey<FormState>(), // Step 2: Website
    GlobalKey<FormState>(), // Step 3: Address
    GlobalKey<FormState>(), // Step 4: Statement Delivery
    GlobalKey<FormState>(), // Step 5: Additional Info
    GlobalKey<FormState>(), // Step 6: Review Info
  ];

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _phoneNumber1Controller = TextEditingController();
  final TextEditingController _phoneNumber2Controller = TextEditingController();
  final TextEditingController _faxController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _secondaryEmailController =
      TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  String _statementDeliveryMethod = '';
  String? _selectedType = '---'; // For address

  // Stepper index
  int _currentStep = 0;

  // Mock address suggestions
  List<String> _addressSuggestions = [
    '123 Main St',
    '456 Elm St',
    '789 Oak Ave',
  ];

  // Unique ID generation
  final TextEditingController _customerIdController = TextEditingController();

  void _generateCustomerId() {
    var uuid = Uuid();
    _customerIdController.text = uuid.v4().substring(0, 8).toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _generateCustomerId();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _phoneNumber1Controller.dispose();
    _phoneNumber2Controller.dispose();
    _faxController.dispose();
    _emailController.dispose();
    _secondaryEmailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _additionalInfoController.dispose();
    _customerIdController.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    if (_currentStep < _getSteps().length - 1) {
      if (_formKeys[_currentStep].currentState?.validate() ?? false) {
        setState(() {
          _currentStep += 1;
        });
      }
    } else {
      _onSubmit();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    } else {
      widget.onClose();
    }
  }

  void _onSubmit() {
    if (_formKeys.every((key) => key.currentState?.validate() ?? false)) {
      widget.logMessages.value = [
        ...widget.logMessages.value,
        {
          'description':
              '🌟 Created customer: ${_firstNameController.text} ${_lastNameController.text}',
          'completed': false,
        },
      ];
      widget.logMessages.notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Customer created successfully!')),
      );
      widget.onClose();
    }
  }

  void _onStepTapped(int step) {
    if (step <= _currentStep) {
      setState(() {
        _currentStep = step;
      });
    }
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: Text('Personal Info'),
        content: Form(
          key: _formKeys[0],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildSectionTitle('Personal Info')),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstNameController,
                      labelText: 'First Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: _lastNameController,
                      labelText: 'Last Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _companyNameController,
                labelText: 'Company Name (Optional)',
                validator: (value) {
                  if (_firstNameController.text.isEmpty &&
                      _lastNameController.text.isEmpty &&
                      value?.isEmpty == true) {
                    return 'Company name is required if first or last name is missing';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.editing,
      ),
      Step(
        title: Text('Contact Info'),
        content: Form(
          key: _formKeys[1],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildSectionTitle('Contact Information')),
              SizedBox(height: 16),
              _buildTextField(
                controller: _phoneNumber1Controller,
                labelText: 'Phone Number 1',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _phoneNumber2Controller,
                labelText: 'Phone Number 2 (Optional)',
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _faxController,
                labelText: 'Fax Number (Optional)',
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _secondaryEmailController,
                labelText: 'Secondary Email (Optional)',
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !EmailValidator.validate(value)) {
                    return 'Please enter a valid secondary email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.editing,
      ),
      Step(
        title: Text('Website'),
        content: Form(
          key: _formKeys[2],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildSectionTitle('Website')),
              SizedBox(height: 16),
              _buildTextField(
                controller: _websiteController,
                labelText: 'Website (Optional)',
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.editing,
      ),
Step(
        title: Text(
          'Address',
          style: TextStyle(
            fontSize: 18, // Adjusted font size for consistency
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Form(
          key: _formKeys[3],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildSectionTitle('Address')),
              SizedBox(height: 16),
              _buildAddressField(
                controller: _addressController,
                labelText:
                    'Address', // This one remains optional or validated depending on your preference
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _cityController,
                labelText: 'City',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _provinceController,
                labelText: 'Province/State',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Province/State is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _postalCodeController,
                labelText: 'Postal Code',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Postal Code is required';
                  }
                  // Optionally, you could add a regular expression to validate the postal code format
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _countryController,
                labelText: 'Country',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Country is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 3,
        state: _currentStep > 3 ? StepState.complete : StepState.editing,
      ),

      Step(
        title: Text('Statement Delivery'),
        content: Form(
          key: _formKeys[4],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildSectionTitle('Statement Delivery')),
              SizedBox(height: 16),
              _buildStatementDeliveryRadio(),
            ],
          ),
        ),
        isActive: _currentStep >= 4,
        state: _currentStep > 4 ? StepState.complete : StepState.editing,
      ),
      Step(
        title: Text('Additional Info'),
        content: Form(
          key: _formKeys[5],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildSectionTitle('Additional Info')),
              SizedBox(height: 16),
              _buildTextField(
                controller: _additionalInfoController,
                labelText: 'Additional Info',
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 5,
        state: StepState.editing,
      ),
      Step(
        title: Text('Review Info'),
        content: Form(
          key: _formKeys[6],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildSectionTitle('Review All Information')),
              SizedBox(height: 16),
              _buildReviewSection('First Name', _firstNameController.text),
              _buildReviewSection('Last Name', _lastNameController.text),
              _buildReviewSection(
                  'Company Name', _companyNameController.text ?? ''),
              _buildReviewSection(
                  'Phone Number 1', _phoneNumber1Controller.text),
              _buildReviewSection(
                  'Phone Number 2', _phoneNumber2Controller.text ?? ''),
              _buildReviewSection('Fax', _faxController.text ?? ''),
              _buildReviewSection('Email', _emailController.text),
              _buildReviewSection(
                  'Secondary Email', _secondaryEmailController.text ?? ''),
              _buildReviewSection('Website', _websiteController.text ?? ''),
              _buildReviewSection('Address', _addressController.text),
              _buildReviewSection('City', _cityController.text),
              _buildReviewSection('Province', _provinceController.text),
              _buildReviewSection('Postal Code', _postalCodeController.text),
              _buildReviewSection('Country', _countryController.text),
              _buildReviewSection(
                  'Statement Delivery', _statementDeliveryMethod),
              _buildReviewSection(
                  'Additional Info', _additionalInfoController.text ?? ''),
            ],
          ),
        ),
        isActive: _currentStep >= 6,
        state: StepState.editing,
      ),
    ];
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurpleAccent,
      ),
    );
  }

  Widget _buildTextField({
      required TextEditingController controller,
      required String labelText,
      String? Function(String?)? validator,
    }) {
      return TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.grey[800],
          labelStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // Reserve space for errors without shifting fields
          helperText: ' ', // Reserve space by default
          helperMaxLines: 1,
          errorMaxLines: 2, // Allow up to 2 lines for error messages
        ),
        validator: validator,
      );
    }

  Widget _buildAddressField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.grey[800],
          labelStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      suggestionsCallback: (pattern) {
        return _addressSuggestions.where(
            (address) => address.toLowerCase().contains(pattern.toLowerCase()));
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(
          title: Text(suggestion, style: TextStyle(color: Colors.black)),
        );
      },
      onSuggestionSelected: (String suggestion) {
        controller.text = suggestion;
      },
      validator: validator,
    );
  }

  Widget _buildStatementDeliveryRadio() {
    return Column(
      children: [
        RadioListTile<String>(
          title: Text('Email', style: TextStyle(color: Colors.white70)),
          value: 'Email',
          groupValue: _statementDeliveryMethod,
          onChanged: (value) {
            setState(() {
              _statementDeliveryMethod = value!;
            });
          },
          activeColor: Colors.deepPurpleAccent,
        ),
        RadioListTile<String>(
          title: Text('Printed Paper', style: TextStyle(color: Colors.white70)),
          value: 'Printed Paper',
          groupValue: _statementDeliveryMethod,
          onChanged: (value) {
            setState(() {
              _statementDeliveryMethod = value!;
            });
          },
          activeColor: Colors.deepPurpleAccent,
        ),
      ],
    );
  }

  Widget _buildReviewSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$title:',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        color: Colors.grey[850],
        elevation: 0,
      ),
      colorScheme: ColorScheme.dark(
        primary: Colors.deepPurple,
        secondary: Colors.deepPurpleAccent,
        background: Colors.grey[900]!,
        surface: Colors.grey[800]!,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        error: Colors.redAccent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
        labelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.deepPurple.withOpacity(0.8);
            }
            return Colors.deepPurple;
          }),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.deepPurple.withOpacity(0.8);
            }
            return Colors.deepPurple;
          }),
          side: MaterialStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(MaterialState.hovered)) {
              return BorderSide(color: Colors.deepPurple.withOpacity(0.8));
            }
            return BorderSide(color: Colors.deepPurple);
          }),
        ),
      ),
    );

    return Theme(
      data: customTheme,
      child: Scaffold(
        body: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          steps: _getSteps(),
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          onStepTapped: _onStepTapped,
          controlsBuilder: (context, details) {
            final isLastStep = _currentStep == _getSteps().length - 1;
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(isLastStep ? 'Add Customer' : 'Next'),
                  ),
                  SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    child: Text('Cancel'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
