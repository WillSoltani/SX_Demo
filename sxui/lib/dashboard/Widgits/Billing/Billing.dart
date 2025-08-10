//Author: Will Soltani
//Version 1.0
//Revised: 30-09-2024
import 'package:flutter/material.dart';
import '../../Extensions/hoverable_icon_text_item.dart';
import '../../Extensions/hoverable_stat_item.dart';
import '../../Extensions/dashboard_box.dart';
import '../../constants.dart';
import '../../../pages/bill_invoices_page.dart';
import '../../../pages/cases_page.dart';
import '../../../pages/flagged_page.dart';

/// A box that holds the invoice and billing button with numbers indicating the ongoing active cases
/// and how many of them are flagged. Tapping on the button directs to the bill and invoicing page.
///
/// The widget includes:
/// - An icon-text button for navigating to the 'Bill and Invoices' page.
/// - Numerical indicators showing the total number of active cases and flagged cases, with navigation to their respective pages.
///
/// @param key The optional key for this widget.
class BoxX1 extends StatelessWidget {
  const BoxX1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HoverableIconTextItem(
              icon: Icons.receipt_long,
              text: 'Bill and Invoices',
              onTap: () {
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
            Row(
              children: [
                Expanded(
                  child: HoverableStatItem(
                    number: '232',
                    label: 'Cases',
                    onTap: () {
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
                SizedBox(width: 16),
                Expanded(
                  child: HoverableStatItem(
                    number: '9',
                    label: 'Flagged',
                    onTap: () {
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
