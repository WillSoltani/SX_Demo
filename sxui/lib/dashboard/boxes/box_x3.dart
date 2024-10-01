import 'package:flutter/material.dart';
import '../widgets/dashboard_box.dart';
import '../widgets/hoverable_icon_text_item.dart';
import '../constants.dart';
import '../../pages/settings_page.dart';

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

