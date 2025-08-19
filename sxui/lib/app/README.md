lib/
└─ app/
   ├─ dashboard/
   │  ├─ pages/
   │  │  └─ dashboard_page.dart        # Entry page for the dashboard grid
   │  ├─ widgets/
   │  │  ├─ animated_backdrop.dart     # Ambient animated background
   │  │  ├─ glass_bar.dart             # Top glassy bar (SX Dashboard button + accent)
   │  │  ├─ minimized_tabs_bar.dart    # Minimized tabs strip
   │  │  └─ tile_chrome.dart           # Consistent tile frame/chrome
   │  ├─ dialogs/
   │  │  ├─ widget_picker_dialog.dart  # Choose widget to add
   │  │  ├─ size_picker.dart           # Small/Medium/Large picker
   │  │  └─ driver_name_dialog.dart    # Name prompt when adding a driver
   │  ├─ data/
   │  │  └─ widget_registry.dart       # All addable widgets + their builders
   │  ├─ models/
   │  │  └─ widget_kind.dart           # Enum of widget kinds
   │  └─ core/
   │     └─ tile_models.dart           # TileData, TileSize
   │
   ├─ main_hub/
   │  ├─ main_hub.dart                 # The “Main Hub” tile (Customers/Emails/Reports/Operations/More)
   │  ├─ components/
   │  │  ├─ hoverable_icon_button.dart
   │  │  └─ hoverable_text_item.dart
   │  └─ subs/
   │     ├─ customers/
   │     │  ├─ add_customer.dart
   │     │  └─ view_customer_profile.dart
   │     └─ operations/
   │        ├─ inventory.dart
   │        └─ add_product.dart
   │
   ├─ features/
   │  ├─ drivers/
   │  │  └─ driver.dart                # Single driver widget; multiple instances supported
   │  ├─ calendar/
   │  │  └─ calendar.dart
   │  ├─ search/
   │  │  └─ search.dart
   │  ├─ sales_summary/
   │  │  └─ sales_sum.dart
   │  ├─ log/
   │  │  └─ log.dart
   │  ├─ billing/
   │  │  └─ billing.dart
   │  └─ integrations/
   │     └─ integrations.dart
   │
   └─ shared/
      ├─ models/
      │  ├─ tab_item.dart             # Simple in-memory tab model
      │  └─ sub_item.dart             # (Used by Main Hub)
      ├─ widgets/
      │  ├─ dashboard_box.dart        # Standard card container for tiles
      │  ├─ hoverable_expanded_item.dart
      │  └─ advanced_calendar.dart
      └─ constants.dart               # Colors, etc.
