// File: lib/dashboard/dashboard_page.dart
// Author: Will
// Version: 1.1
// Revised: 06-10-2024
import 'package:flutter/material.dart';
import 'package:sxui/app/Widgits/Billing/Billing.dart';
import 'package:sxui/app/MainDashboard/mainDash_Widget.dart';
import 'package:sxui/app/Widgits/Setting/setting.dart';
import 'package:sxui/app/Widgits/SalesSummary/salesSum.dart';
import 'package:sxui/app/Widgits/Search/search.dart';
import 'package:sxui/app/Widgits/Drivers/driver1.dart';
import 'package:sxui/app/Widgits/Drivers/driver2.dart';
import 'package:sxui/app/Widgits/Drivers/driver3.dart';
import 'package:sxui/app/Widgits/Drivers/driver4.dart';
import 'package:sxui/app/Widgits/Drivers/driverSum.dart';
import 'package:sxui/app/Widgits/Integrations/Integrations.dart';
import 'package:sxui/app/Widgits/Calendar/calendar.dart';
import 'package:sxui/app/Widgits/Log/log.dart';
import 'package:sxui/app/MainDashboard/Subs/Customers/add_customer.dart';
import 'package:sxui/app/models/tab_item.dart';
import 'package:sxui/app/Extensions/tab_properties.dart';
import 'package:sxui/app/Extensions/dashboard_box.dart'; // <-- needed for BoxX1..BoxX13

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SX Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

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
  final ValueNotifier<List<Map<String, dynamic>>> logMessages =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  // Tab management
  List<TabItem> openTabs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Existing body content
          Column(
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
                          // Box x2 - MainDashWidget
                          Expanded(
                            flex: 8,
                            child: MainDashWidget(
                              logMessages: logMessages,
                              onOpenTab: _openTab,
                              onCloseTab: _closeTab,
                            ),
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
                                Expanded(
                                  child: BoxX6(logMessages: logMessages),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: BoxX7(logMessages: logMessages),
                                ),
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
                                Expanded(
                                  child: BoxX8(logMessages: logMessages),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: BoxX9(logMessages: logMessages),
                                ),
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
                                Expanded(
                                  child: BoxX12(logMessages: logMessages),
                                ),
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
          // Open tabs
          ...openTabs.map((tab) {
            return Offstage(
              offstage: tab.isMinimized,
              child: Material(
                color: Colors.transparent,
                child: TabProperties(
                  key: ValueKey(tab.id),
                  title: tab.title,
                  onClose: () {
                    _closeTab(tab.id);
                  },
                  onMinimize: () {
                    _minimizeTab(tab.id);
                  },
                  child: tab.content,
                ),
              ),
            );
          }).toList(),

          // Minimized tabs bar
          if (openTabs.any((tab) => tab.isMinimized))
            Positioned(
              bottom: 10,
              left: 10,
              child: _buildMinimizedTabsBar(),
            ),
        ],
      ),
    );
  }

  // Tab management methods
  void _openTab(TabItem tab) {
    setState(() {
      // Minimize all currently open tabs before opening a new one
      for (var existingTab in openTabs) {
        existingTab.isMinimized = true;
      }
      openTabs.add(tab);
    });
  }

  void _closeTab(String tabId) {
    setState(() {
      openTabs.removeWhere((tab) => tab.id == tabId);
    });
  }

  void _minimizeTab(String tabId) {
    setState(() {
      openTabs.firstWhere((tab) => tab.id == tabId).isMinimized = true;
    });
  }

  void _restoreTab(String tabId) {
    setState(() {
      openTabs.firstWhere((tab) => tab.id == tabId).isMinimized = false;
    });
  }

  void _resizeTab(String tabId) {
    setState(() {
      TabItem tab = openTabs.firstWhere((tab) => tab.id == tabId);
      tab.isMaximized = !tab.isMaximized; // Toggle maximized state
    });
  }

  Widget _buildMinimizedTabsBar() {
    List<TabItem> minimizedTabs =
        openTabs.where((tab) => tab.isMinimized).toList();

    if (minimizedTabs.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width *
            0.5, // Max width is 50% of screen
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: minimizedTabs.map((tab) {
            return _buildMinimizedTabButton(tab);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMinimizedTabButton(TabItem tab) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          tab.isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          tab.isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          _restoreTab(tab.id);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 2),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: tab.isHovered ? Colors.grey[600] : Colors.grey[700],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tab.title,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  _closeTab(tab.id);
                },
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
