import 'package:flutter/material.dart';
import 'boxes/box_x1.dart';
import 'boxes/box_x2.dart';
import 'boxes/box_x3.dart';
import 'boxes/box_x4.dart';
import 'boxes/box_x5.dart';
import 'boxes/box_x6.dart';
import 'boxes/box_x7.dart';
import 'boxes/box_x8.dart';
import 'boxes/box_x9.dart';
import 'boxes/box_x10.dart';
import 'boxes/box_x11.dart';
import 'boxes/box_x12.dart';
import 'boxes/box_x13.dart';
import 'boxes/advanced_calendar.dart';
import 'constants.dart';
import 'dashboard_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  // Flex values for layout
  static const int leftMarginFlex = 3;
  static const int firstBoxFlex = 6;
  static const int boxMarginFlex = 1;
  static const int secondBoxFlex = 7;
  static const int thirdBoxFlex = 11;
  static const int rightMarginFlex = 3;

  static const int topMarginFlex = 2;
  static const int firstRowFlex = 20;
  static const int bottomMarginFlex = 2;

  // Log messages notifier
  final ValueNotifier<List<Map<String, dynamic>>> logMessages = ValueNotifier<List<Map<String, dynamic>>>([]);

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Column(
      children: [
        // Top Margin
        Expanded(flex: topMarginFlex, child: SizedBox()),
        // Main Content Row
        Expanded(
          flex: firstRowFlex,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Margin
              Expanded(flex: leftMarginFlex, child: SizedBox()),
              // First Column (x1, x2, x3)
              Expanded(
                flex: firstBoxFlex,
                child: Column(
                  children: [
                    // Box x1
                    Expanded(
                      flex: 4,
                      child: BoxX1(),
                    ),
                    // Spacer
                    Expanded(flex: 1, child: SizedBox()),
                    // Box x2
                    Expanded(
                      flex: 8,
                      child: BoxX2(), 
                    ),
                    // Spacer
                    Expanded(flex: 1, child: SizedBox()),
                    // Box x3
                    Expanded(
                      flex: 3,
                      child: BoxX3(),
                    ),
                  ],
                ),
              ),
              // Margin between boxes
              Expanded(flex: boxMarginFlex, child: SizedBox()),
              // Second Column (x4, x5, x6, x7, x8, x9)
              Expanded(
                flex: secondBoxFlex,
                child: Column(
                  children: [
                    // Box x4
                    Expanded(
                      flex: 2,
                      child: BoxX4(),
                    ),
                    // Spacer
                    Expanded(flex: 1, child: SizedBox()),
                    // Box x5
                    Expanded(
                      flex: 2,
                      child: BoxX5(),
                    ),
                    // Spacer
                    Expanded(flex: 1, child: SizedBox()),
                    // Boxes x6 and x7 in a row
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Expanded(child: BoxX6(logMessages: logMessages)),
                          SizedBox(width: 8),
                          Expanded(child: BoxX7(logMessages: logMessages)),
                        ],
                      ),
                    ),
                    // Spacer
                    Expanded(flex: 1, child: SizedBox()),
                    // Boxes x8 and x9 in a row
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Expanded(child: BoxX8(logMessages: logMessages)),
                          SizedBox(width: 8),
                          Expanded(child: BoxX9(logMessages: logMessages)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Margin between boxes
              Expanded(flex: boxMarginFlex, child: SizedBox()),
              // Third Column (x10, x11, x12, x13)
              Expanded(
                flex: thirdBoxFlex,
                child: Column(
                  children: [
                    // Box x10
                    Expanded(
                      flex: 3,
                      child: BoxX10(),
                    ),
                    // Spacer
                    Expanded(flex: 1, child: SizedBox()),
                    // Box x11 and x12 in a row
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(child: BoxX11()),
                          SizedBox(width: 8),
                          Expanded(child: BoxX12(logMessages: logMessages)),
                        ],
                      ),
                    ),
                    // Spacer
                    Expanded(flex: 1, child: SizedBox()),
                    // Box x13
                    Expanded(
                      flex: 8,
                      child: BoxX13(logMessages: logMessages),
                    ),
                  ],
                ),
              ),
              // Right Margin
              Expanded(flex: rightMarginFlex, child: SizedBox()),
            ],
          ),
        ),
        // Bottom Margin
        Expanded(flex: bottomMarginFlex, child: SizedBox()),
      ],
    ),
  );
}

}


