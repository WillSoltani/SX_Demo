# MainDashboard/components

Small UI pieces used inside the dashboard.

### Files
- **hoverable_icon_button.dart**  
  A reusable circular icon button with hover animations.  
  Used by the dashboard’s back button.

### Example
```dart
HoverableIconButton(
  icon: Icons.arrow_back,
  onPressed: () => print("Back pressed"),
);
