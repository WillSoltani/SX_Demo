# Extensions/

Shared UI helpers & components.

### Files
- **dashboard_box.dart** → standard container for dashboard content
- **hoverable_text_item.dart** → text row with hover animation
- **hoverable_expanded_item.dart** → expandable list row with hover state
- **tab_properties.dart** → shared tab-related helpers

### Example
```dart
HoverableTextItem(
  text: "Add Customer",
  icon: Icons.person_add,
  onTap: () => print("Tapped"),
);
