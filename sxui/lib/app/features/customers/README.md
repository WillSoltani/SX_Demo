# Subs/Customers

Customer feature modules.

### Files
- **add_customer.dart**  
  Widget for adding a new customer.  
  Typically opened in a new tab from the dashboard.
- **view_customer_profile.dart**  
  Widget to view a customer profile.  
  Can trigger opening a "Customer Detail" tab with a name.

### Notes
- Must import `package:sxui/app/constants.dart` to use shared colors like `darkPurple`.
- Integrated into dashboard via `dash_actions.dart`.
