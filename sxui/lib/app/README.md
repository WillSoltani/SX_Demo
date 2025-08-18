# app/

Main application code and features.

## Structure
- **MainDashboard/** – dashboard shell (navigation, lists, actions)
- **Subs/** – feature modules opened from the dashboard (Customers, Operations, etc.)
- **Widgits/** – legacy widgets (Billing, Calendar, Drivers, etc.)
- **Extensions/** – shared UI helpers and reusable components
- **models/** – simple data classes used by UI (e.g., `TabItem`, `SubItem`)
- **pages/** – simple page/screen wrappers (e.g., `SubItemPage`)
- **constants.dart** – theme constants (e.g., `darkPurple`)

## Import style
```dart
import 'package:sxui/app/constants.dart';
import 'package:sxui/app/models/tab_item.dart';
