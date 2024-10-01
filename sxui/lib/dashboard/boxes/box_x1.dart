import 'package:flutter/material.dart';
import '../widgets/hoverable_icon_text_item.dart';
import '../widgets/hoverable_stat_item.dart';
import '../widgets/dashboard_box.dart';
import '../constants.dart';
import '../../pages/bill_invoices_page.dart';
import '../../pages/cases_page.dart';
import '../../pages/flagged_page.dart';

class BoxX1 extends StatelessWidget {
  const BoxX1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add some padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hoverable icon and label
            HoverableIconTextItem(
              icon: Icons.receipt_long,
              text: 'Bill and Invoices',
              onTap: () {
                // Navigate to Bill and Invoices page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BillInvoicesPage()),
                );
              },
              iconColor: darkPurple,
              hoverIconColor: Colors.white,
              iconSize: 60,
              hoverIconSize: 70,
              textColor: Colors.white,
              hoverTextColor: Colors.white,
              textFontSize: 22,
              hoverTextFontSize: 26,
            ),
            SizedBox(height: 16),
            // Row for Cases and Flagged
            Row(
              children: [
                // Cases
                Expanded(
                  child: HoverableStatItem(
                    number: '232',
                    label: 'Cases',
                    onTap: () {
                      // Navigate to Cases page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CasesPage()),
                      );
                    },
                    numberColor: Colors.white,
                    hoverNumberColor: darkPurple,
                    labelColor: Colors.white,
                    hoverLabelColor: darkPurple,
                    numberFontSize: 28,
                    hoverNumberFontSize: 32,
                    labelFontSize: 16,
                    hoverLabelFontSize: 18,
                  ),
                ),
                // Spacer between Cases and Flagged
                SizedBox(width: 16),
                // Flagged
                Expanded(
                  child: HoverableStatItem(
                    number: '9',
                    label: 'Flagged',
                    onTap: () {
                      // Navigate to Flagged page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FlaggedPage()),
                      );
                    },
                    numberColor: Colors.white,
                    hoverNumberColor: darkPurple,
                    labelColor: Colors.white,
                    hoverLabelColor: darkPurple,
                    numberFontSize: 28,
                    hoverNumberFontSize: 32,
                    labelFontSize: 16,
                    hoverLabelFontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

