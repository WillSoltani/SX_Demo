//Author: Will Soltani
//Version 1.0
//Revised: 30-09-2024
import 'package:flutter/material.dart';
import '../../Extensions/dashboard_box.dart';
import '../../Extensions/hoverable_icon_text_item.dart';
import '../../constants.dart';
import 'package:sxui/app/pages/settings_page.dart';

/// A simple box that contains a single hoverable icon-text item labeled 'Settings'.
/// Tapping on the icon redirects the user to the Settings page, providing a quick and
/// interactive way to access settings within the application.
///
/// This widget includes:
/// - A 'Settings' button with hover effects, changing both the icon's size and color.
/// - Navigation: Directs the user to the Settings page when tapped.
///
/// @param key The optional key for this widget.
class BoxX3 extends StatelessWidget {
  const BoxX3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardBox(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: HoverableIconTextItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () {
              // Navigate to Settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            iconColor: Colors.white,
            hoverIconColor: darkPurple,
            iconSize: 50,
            hoverIconSize: 60,
            textColor: Colors.white,
            hoverTextColor: darkPurple,
            textFontSize: 22,
            hoverTextFontSize: 26,
          ),
        ),
      ),
    );
  }
}

