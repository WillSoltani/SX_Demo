// File: lib/widgets/dashboard/MainDashboard/Subs/Operations/add_product.dart

// Author: Will
// Version: 1.0
// Revised: 10-15-2024

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs
import '../../../../dashboard/constants.dart';

class AddProduct extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;
  final VoidCallback onClose;

  const AddProduct({
    Key? key,
    required this.logMessages,
    required this.onClose,
  }) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  // Form keys for each step
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // Step 0
    GlobalKey<FormState>(), // Step 1
    GlobalKey<FormState>(), // Step 2
    GlobalKey<FormState>(), // Step 3
    GlobalKey<FormState>(), // Step 4
    // No form in step 5 (Review)
  ];

  // Controllers for form fields
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _reducedPriceController = TextEditingController();
  final TextEditingController _stockQuantityController =
      TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();

  // Category selection
  String? _selectedCategory;
  final List<String> _categories = [
    'Denture',
    'Crown',
    'Appliance',
    'Operation',
    'Night Guard',
    'Others',
  ];

  // Unlimited quantity selection
  bool _isUnlimitedQuantity = false;

  // Stepper index
  int _currentStep = 0;

  // Generate product ID
  void _generateProductId() {
    var uuid = Uuid();
    _productIdController.text = uuid.v4().substring(0, 8).toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _generateProductId();
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _reducedPriceController.dispose();
    _stockQuantityController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    if (_currentStep < _getSteps().length - 1) {
      // Validate the current step
      if (_formKeys[_currentStep].currentState?.validate() ?? false) {
        setState(() {
          _currentStep += 1;
        });
      }
    } else {
      _onSave();
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

  void _onSave() {
    // Validate all forms
    bool isValid = true;
    for (var key in _formKeys) {
      if (key.currentState != null && !key.currentState!.validate()) {
        isValid = false;
        break;
      }
    }

    if (isValid) {
      // Perform save operation
      print('Product saved');
      // Add logic to save the product to your database or state management solution
      widget.onClose();
    } else {
      // Go back to the first invalid step
      for (int i = 0; i < _formKeys.length; i++) {
        if (_formKeys[i].currentState != null &&
            !_formKeys[i].currentState!.validate()) {
          setState(() {
            _currentStep = i;
          });
          break;
        }
      }
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
      // Step 0: Basic Information
      Step(
        title: Text('Basic Info'),
        content: Form(
          key: _formKeys[0],
          child: Column(
            children: [
              _buildTextField(
                controller: _productIdController,
                labelText: 'Product ID',
                readOnly: true,
                suffixIcon: IconButton(
                  icon: Icon(Icons.refresh, color: Colors.grey),
                  onPressed: _generateProductId,
                ),
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _productNameController,
                labelText: 'Product Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Product Name';
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
      // Step 1: Category
      Step(
        title: Text('Category'),
        content: Form(
          key: _formKeys[1],
          child: Column(
            children: [
              _buildDropdownField(),
              if (_selectedCategory == 'Others') ...[
                SizedBox(height: 16),
                _buildTextField(
                  controller: _customCategoryController,
                  labelText: 'Custom Category',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Category';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.editing,
      ),
      // Step 2: Pricing
      Step(
        title: Text('Pricing'),
        content: Form(
          key: _formKeys[2],
          child: Column(
            children: [
              _buildTextField(
                controller: _priceController,
                labelText: 'Price',
                prefixText: '\$',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _reducedPriceController,
                labelText: 'Reduced Price',
                prefixText: '\$',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.editing,
      ),
      // Step 3: Stock
      Step(
        title: Text('Stock'),
        content: Form(
          key: _formKeys[3],
          child: Column(
            children: [
              _buildTextField(
                controller: _stockQuantityController,
                labelText: 'Stock Quantity',
                keyboardType: TextInputType.number,
                enabled: !_isUnlimitedQuantity,
                validator: (value) {
                  if (!_isUnlimitedQuantity) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Stock Quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid integer';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildUnlimitedQuantitySwitch(),
            ],
          ),
        ),
        isActive: _currentStep >= 3,
        state: _currentStep > 3 ? StepState.complete : StepState.editing,
      ),
      // Step 4: Description
      Step(
        title: Text('Description'),
        content: Form(
          key: _formKeys[4],
          child: _buildTextField(
            controller: _descriptionController,
            labelText: 'Description',
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a Description';
              }
              return null;
            },
          ),
        ),
        isActive: _currentStep >= 4,
        state: _currentStep > 4 ? StepState.complete : StepState.editing,
      ),
      // Step 5: Review
      Step(
        title: Text('Review'),
        content: _buildReview(),
        isActive: _currentStep >= 5,
        state: StepState.editing,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Custom theme using grey 900 and dark purple, without 'primary' usage
    final customTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        color: Colors.grey[850],
        elevation: 0, // Optional: Remove AppBar shadow for a cleaner look
      ),
      colorScheme: ColorScheme.dark(
        primary: darkPurple,
        secondary: darkPurple,
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
      // Define button themes if needed
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return darkPurple.withOpacity(0.8);
            }
            return darkPurple;
          }),
          foregroundColor:
              MaterialStateProperty.all<Color>(Colors.white), // Text color
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return darkPurple.withOpacity(0.8);
            }
            return darkPurple;
          }),
          side: MaterialStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(MaterialState.hovered)) {
              return BorderSide(color: darkPurple.withOpacity(0.8));
            }
            return BorderSide(color: darkPurple);
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.white;
            }
            return Colors.white70;
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
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            final isLastStep = _currentStep == _getSteps().length - 1;
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(isLastStep ? 'Save' : 'Next'),
                    // The text color is set to white via the theme
                  ),
                  SizedBox(width: 16),
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: Text('Back'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            Colors.white, // Set text color to white
                        side: BorderSide(
                            color:
                                darkPurple), // Keep the border color as darkPurple
                      ),
                    ),

                  if (!isLastStep)
                    TextButton(
                      onPressed: widget.onClose,
                      child: Text('Cancel'),
                      // The text color is set via the theme
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    Widget? suffixIcon,
    bool enabled = true,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: prefixText,
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(color: Colors.white),
      validator: validator,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      items: _categories.map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(
            category,
            style: TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
          if (_selectedCategory != 'Others') {
            _customCategoryController.clear();
          }
        });
      },
      decoration: InputDecoration(
        labelText: 'Category',
      ),
      dropdownColor: Colors.grey[800],
      iconEnabledColor: Colors.white70,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Category';
        }
        if (value == 'Others' && (_customCategoryController.text.isEmpty)) {
          return 'Please enter a Category';
        }
        return null;
      },
    );
  }

  Widget _buildUnlimitedQuantitySwitch() {
    return SwitchListTile(
      title: Text('Unlimited Quantity', style: TextStyle(color: Colors.white)),
      value: _isUnlimitedQuantity,
      onChanged: (value) {
        setState(() {
          _isUnlimitedQuantity = value;
          if (_isUnlimitedQuantity) {
            _stockQuantityController.clear();
          }
        });
      },
      activeColor: darkPurple,
    );
  }

  Widget _buildReview() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review your product details:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 16),
          _buildReviewItem('Product ID', _productIdController.text),
          _buildReviewItem('Product Name', _productNameController.text),
          _buildReviewItem(
            'Category',
            _selectedCategory == 'Others'
                ? _customCategoryController.text
                : _selectedCategory ?? '',
          ),
          _buildReviewItem('Price', '\$${_priceController.text}'),
          if (_reducedPriceController.text.isNotEmpty)
            _buildReviewItem(
                'Reduced Price', '\$${_reducedPriceController.text}'),
          _buildReviewItem(
            'Stock Quantity',
            _isUnlimitedQuantity ? 'Unlimited' : _stockQuantityController.text,
          ),
          _buildReviewItem('Description', _descriptionController.text),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String title, String value) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white70)),
      subtitle: Text(value, style: TextStyle(color: Colors.white)),
    );
  }
}
