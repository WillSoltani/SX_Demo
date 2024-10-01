import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
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

  // Define the dark purplish color
  static const Color darkPurple = Color(0xFF4B0082); // Indigo color as an example

  // State to keep track of the expanded main item
  String? expandedItem;

  // Animation Controllers
  late AnimationController _subItemsController;
  List<Animation<Offset>> _subItemAnimations = [];

  @override
  void initState() {
    super.initState();
    _subItemsController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    // Do not set expandedItem to 'Dashboard' by default
    expandedItem = null;
  }

  @override
  void dispose() {
    _subItemsController.dispose();
    super.dispose();
  }

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
                      // x1 - Customized
                      Expanded(
                        flex: 4,
                        child: _buildX1Container(context),
                      ),
                      // Spacer
                      Expanded(flex: 1, child: SizedBox()),
                      // x2 - Customized with AnimatedSwitcher
                      Expanded(
                        flex: 8,
                        child: _buildX2Container(context),
                      ),
                      // Spacer
                      Expanded(flex: 1, child: SizedBox()),
                      // x3 - New Interactive Settings Button
                      Expanded(
                        flex: 3,
                        child: _buildX3Container(context),
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
                      // x4 - Customized
                      Expanded(
                        flex: 2,
                        child: _buildX4Container(context),
                      ),
                      // Spacer
                      Expanded(flex: 1, child: SizedBox()),
                      // x5
                      Expanded(
                        flex: 2,
                        child: _buildContainer(
                          child: Center(
                            child: Text(
                              'x5',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      // Spacer
                      Expanded(flex: 1, child: SizedBox()),
                      // x6 and x7 in a row
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            // x6
                            Expanded(
                              child: _buildContainer(
                                child: Center(
                                  child: Text(
                                    'x6',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // x7
                            Expanded(
                              child: _buildContainer(
                                child: Center(
                                  child: Text(
                                    'x7',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Spacer
                      Expanded(flex: 1, child: SizedBox()),
                      // x8 and x9 in a row
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            // x8
                            Expanded(
                              child: _buildContainer(
                                child: Center(
                                  child: Text(
                                    'x8',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // x9
                            Expanded(
                              child: _buildContainer(
                                child: Center(
                                  child: Text(
                                    'x9',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
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
                      // x10
                      Expanded(
                        flex: 3,
                        child: _buildContainer(
                          child: Center(
                            child: Text(
                              'x10',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      // Spacer
                      Expanded(flex: 1, child: SizedBox()),
                      // x11 and x12 in a row
                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            // x11
                            Expanded(
                              child: _buildContainer(
                                child: Center(
                                  child: Text(
                                    'x11',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // x12
                            Expanded(
                              child: _buildContainer(
                                child: Center(
                                  child: Text(
                                    'x12',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Spacer
                      Expanded(flex: 1, child: SizedBox()),
                      // x13
                      Expanded(
                        flex: 8,
                        child: _buildContainer(
                          child: Center(
                            child: Text(
                              'x13',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
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

  // Customized container for x1 with hover effects
  Widget _buildX1Container(BuildContext context) {
    return _buildContainer(
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

  // Customized container for x2 with interactive expansion
  Widget _buildX2Container(BuildContext context) {
    return _buildContainer(
      key: ValueKey(expandedItem ?? 'main'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: expandedItem == null ? _buildMainItems(context) : _buildExpandedItem(context),
        ),
      ),
    );
  }

  // Customized container for x3 with interactive settings button
  Widget _buildX3Container(BuildContext context) {
    return _buildContainer(
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

  // Customized container for x4 with sales data
  Widget _buildX4Container(BuildContext context) {
    return _buildContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Dollar sign icon
            Icon(
              Icons.attach_money,
              color: darkPurple,
              size: 50,
            ),
            SizedBox(width: 16),
            // Sales information
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevent overflow
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Sales",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$5,300",
                    style: TextStyle(
                      color: darkPurple,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Progress bar
                  // Progress bar with thin white border
                  // Progress bar with visible empty portion
                  Container(
                    height: 10,
                    width: 200, // Fixed width for testing
                    decoration: BoxDecoration(
                      color: Colors.grey[500], // Background color for the empty portion
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white, width: 1), // Thin white border
                    ),
                    child: Stack(
                      children: [
                        // Filled portion of the progress bar
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 150, // 75% of 200
                            decoration: BoxDecoration(
                              color: darkPurple,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  SizedBox(height: 4),
                  Text(
                    "75% of yesterday's sales",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the list of main items
  Widget _buildMainItems(BuildContext context) {
    return Column(
      key: ValueKey('mainItems'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Dashboard at the top center
        Center(
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: darkPurple,
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16),
        // Other main items
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HoverableTextItem(
                text: 'Customers',
                icon: Icons.people,
                onTap: () => _expandItem('Customers'),
                fontSize: 24.0,
                hoverFontSize: 28.0,
              ),
              HoverableTextItem(
                text: 'Emails',
                icon: Icons.email,
                onTap: () => _expandItem('Emails'),
                fontSize: 24.0,
                hoverFontSize: 28.0,
              ),
              HoverableTextItem(
                text: 'Reports',
                icon: Icons.bar_chart,
                onTap: () => _expandItem('Reports'),
                fontSize: 24.0,
                hoverFontSize: 28.0,
              ),
              HoverableTextItem(
                text: 'Operations',
                icon: Icons.settings,
                onTap: () => _expandItem('Operations'),
                fontSize: 24.0,
                hoverFontSize: 28.0,
              ),
              HoverableTextItem(
                text: 'More',
                icon: Icons.more_horiz,
                onTap: () => _expandItem('More'),
                fontSize: 24.0,
                hoverFontSize: 28.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build the expanded main item with sub-items
  Widget _buildExpandedItem(BuildContext context) {
    List<SubItem> subs = [];
    switch (expandedItem) {
      case 'Customers':
        subs = [
          SubItem('Add Customer', Icons.person_add),
          SubItem('View Customer Profile', Icons.person),
          SubItem('View Customer Activity', Icons.history),
          SubItem('View Customer Summary', Icons.assessment),
          SubItem('Merge Customer', Icons.merge_type),
          SubItem('Customer Payment', Icons.payment),
        ];
        break;
      case 'Emails':
        subs = [
          SubItem('Compose Email', Icons.email),
          SubItem('Inbox', Icons.inbox),
          SubItem('Sent Items', Icons.send),
        ];
        break;
      case 'Reports':
        subs = [
          SubItem('Sales Report', Icons.show_chart),
          SubItem('Staff Report', Icons.people),
          SubItem('Custom Report', Icons.insert_chart),
          SubItem('Flagged Invoices', Icons.flag),
          SubItem('Financial Reports', Icons.account_balance),
        ];
        break;
      case 'Operations':
        subs = [
          SubItem('Inventory Management', Icons.inventory),
          SubItem('Order Management', Icons.shopping_cart),
          SubItem('Production Management', Icons.factory),
          SubItem('Pickup and Delivery', Icons.local_shipping),
          SubItem('Analytics and Reporting', Icons.analytics),
          SubItem('Staff Scheduling', Icons.schedule),
          SubItem('Printers and Devices', Icons.print),
        ];
        break;
      case 'More':
        subs = [
          SubItem('Settings', Icons.settings),
          SubItem('Help', Icons.help),
          SubItem('Feedback', Icons.feedback),
          SubItem('About Us', Icons.info),
          SubItem('Logout', Icons.logout),
        ];
        break;
    }

    // Initialize animations for sub-items
    _initializeSubItemAnimations(subs.length);

    return Column(
      key: ValueKey('expandedItem'),
      mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Main item at the top with hover effect
        HoverableExpandedItem(
          text: expandedItem!,
          onTap: () => _collapseItem(),
          fontSize: 32.0,
          hoverFontSize: 36.0,
        ),
        SizedBox(height: 8),
        // Sub-items with animations
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center sub-items vertically
            children: List.generate(subs.length, (index) {
              return Expanded(
                child: SlideTransition(
                  position: _subItemAnimations[index],
                  child: HoverableTextItem(
                    text: subs[index].title,
                    icon: subs[index].icon,
                    onTap: () => _navigateToSub(context, subs[index].title),
                    fontSize: 20.0,
                    hoverFontSize: 24.0,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Expand the selected main item
  void _expandItem(String item) {
    setState(() {
      expandedItem = item;
    });
    // Start the sub-items animation after a short delay
    Future.delayed(Duration(milliseconds: 300), () {
      _initializeSubItemAnimations(_getSubItemCount(item));
    });
  }

  // Collapse back to main items
  void _collapseItem() {
    setState(() {
      expandedItem = null;
    });
    _subItemsController.reset();
  }

  int _getSubItemCount(String item) {
    switch (item) {
      case 'Customers':
        return 6;
      case 'Emails':
        return 3;
      case 'Reports':
        return 5;
      case 'Operations':
        return 7;
      case 'More':
        return 5;
      default:
        return 0;
    }
  }

  // Initialize animations for sub-items
  void _initializeSubItemAnimations(int itemCount) {
    _subItemsController.reset();
    _subItemAnimations = [];
    for (int i = 0; i < itemCount; i++) {
      final startDelay = i * 0.1;
      final end = startDelay + 0.5;
      final animation = Tween<Offset>(
        begin: Offset(0, -1),
        end: Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: _subItemsController,
          curve: Interval(
            startDelay,
            end.clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      );
      _subItemAnimations.add(animation);
    }
    _subItemsController.forward();
  }

  // Navigation handler for sub-items
  void _navigateToSub(BuildContext context, String subItem) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubItemPage(subItem: subItem)),
    );
  }

  // Updated _buildContainer method
  Widget _buildContainer({Key? key, Widget? child}) {
    return Container(
      key: key,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Class to hold sub-item data
class SubItem {
  final String title;
  final IconData icon;

  SubItem(this.title, this.icon);
}

// Custom widget for hoverable icon and text items (for Bill and Invoices and Settings)
class HoverableIconTextItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color iconColor;
  final Color hoverIconColor;
  final double iconSize;
  final double hoverIconSize;
  final Color textColor;
  final Color hoverTextColor;
  final double textFontSize;
  final double hoverTextFontSize;

  const HoverableIconTextItem({
    required this.icon,
    required this.text,
    required this.onTap,
    required this.iconColor,
    required this.hoverIconColor,
    required this.iconSize,
    required this.hoverIconSize,
    required this.textColor,
    required this.hoverTextColor,
    required this.textFontSize,
    required this.hoverTextFontSize,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableIconTextItemState createState() => _HoverableIconTextItemState();
}

class _HoverableIconTextItemState extends State<HoverableIconTextItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                widget.icon,
                color: _isHovered ? widget.hoverIconColor : widget.iconColor,
                size: _isHovered ? widget.hoverIconSize : widget.iconSize,
              ),
            ),
            SizedBox(height: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: _isHovered ? widget.hoverTextColor : widget.textColor,
                fontSize: _isHovered ? widget.hoverTextFontSize : widget.textFontSize,
                fontWeight: FontWeight.bold,
              ),
              child: Text(widget.text),
            ),
          ],
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}

// Custom widget for hoverable stat items (for Cases and Flagged)
class HoverableStatItem extends StatefulWidget {
  final String number;
  final String label;
  final VoidCallback onTap;
  final Color numberColor;
  final Color hoverNumberColor;
  final Color labelColor;
  final Color hoverLabelColor;
  final double numberFontSize;
  final double hoverNumberFontSize;
  final double labelFontSize;
  final double hoverLabelFontSize;

  const HoverableStatItem({
    required this.number,
    required this.label,
    required this.onTap,
    required this.numberColor,
    required this.hoverNumberColor,
    required this.labelColor,
    required this.hoverLabelColor,
    required this.numberFontSize,
    required this.hoverNumberFontSize,
    required this.labelFontSize,
    required this.hoverLabelFontSize,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableStatItemState createState() => _HoverableStatItemState();
}

class _HoverableStatItemState extends State<HoverableStatItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: _isHovered ? widget.hoverNumberColor : widget.numberColor,
                fontSize: _isHovered ? widget.hoverNumberFontSize : widget.numberFontSize,
                fontWeight: FontWeight.bold,
              ),
              child: Text(widget.number),
            ),
            SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: _isHovered ? widget.hoverLabelColor : widget.labelColor,
                fontSize: _isHovered ? widget.hoverLabelFontSize : widget.labelFontSize,
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}

// Custom widget for hoverable text items with icons and adjustable font sizes
class HoverableTextItem extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final double fontSize;
  final double hoverFontSize;

  const HoverableTextItem({
    required this.text,
    required this.onTap,
    this.icon,
    this.fontSize = 18.0,
    this.hoverFontSize = 22.0,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableTextItemState createState() => _HoverableTextItemState();
}

class _HoverableTextItemState extends State<HoverableTextItem> {
  bool _isHovered = false;

  static const Color normalColor = Colors.white;
  static const Color hoverColor = DashboardPageState.darkPurple;

  @override
  Widget build(BuildContext context) {
    final color = _isHovered ? hoverColor : normalColor;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            color: _isHovered ? Colors.grey[600] : Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
              children: [
                if (widget.icon != null)
                  Icon(
                    widget.icon,
                    color: color,
                    size: widget.fontSize + 4,
                  ),
                if (widget.icon != null) SizedBox(width: 12),
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: color,
                      fontSize: _isHovered ? widget.hoverFontSize : widget.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}

// Custom widget for hoverable expanded main item
class HoverableExpandedItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double fontSize;
  final double hoverFontSize;

  const HoverableExpandedItem({
    required this.text,
    required this.onTap,
    this.fontSize = 32.0,
    this.hoverFontSize = 36.0,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableExpandedItemState createState() => _HoverableExpandedItemState();
}

class _HoverableExpandedItemState extends State<HoverableExpandedItem> {
  bool _isHovered = false;

  static const Color normalColor = DashboardPageState.darkPurple;
  static const Color hoverColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final color = _isHovered ? hoverColor : normalColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: color,
            fontSize: _isHovered ? widget.hoverFontSize : widget.fontSize,
            fontWeight: FontWeight.bold,
          ),
          child: Center(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }
}

// Placeholder pages for navigation
class BillInvoicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill and Invoices'),
      ),
      body: Center(
        child: Text(
          'Bill and Invoices Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class CasesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cases'),
      ),
      body: Center(
        child: Text(
          'Cases Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class FlaggedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flagged'),
      ),
      body: Center(
        child: Text(
          'Flagged Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SubItemPage extends StatelessWidget {
  final String subItem;

  const SubItemPage({required this.subItem, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subItem),
      ),
      body: Center(
        child: Text(
          '$subItem Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// New Settings Page
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder content for the settings page
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text(
          'Settings Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
