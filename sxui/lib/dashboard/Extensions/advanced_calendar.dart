// Author: Will Soltani
// Version: 1.0
// Revised: 30-09-2024

// This widget, AdvancedCalendar, provides a customizable calendar interface for adding, viewing, and managing events for each day.
// Users can add events, mark them as completed, or remove them. The widget logs interactions and displays the days of the selected month.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdvancedCalendar extends StatefulWidget {
  final ValueNotifier<List<Map<String, dynamic>>> logMessages;

  const AdvancedCalendar({Key? key, required this.logMessages})
      : super(key: key);

  @override
  _AdvancedCalendarState createState() => _AdvancedCalendarState();
}

class _AdvancedCalendarState extends State<AdvancedCalendar> {
  DateTime _selectedDate = DateTime.now();
  Map<String, List<Map<String, dynamic>>> _events = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentDate());
  }

  /// Helper function to format date for use as a map key.
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Function to add a new event for the selected day.
  void _addEvent(StateSetter updateDialogState) {
    final dateKey = _formatDate(_selectedDate);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _eventController = TextEditingController();
        return AlertDialog(
          title: Text('Add Event'),
          content: TextField(
            controller: _eventController,
            decoration: InputDecoration(hintText: 'Event description'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_eventController.text.isNotEmpty) {
                  setState(() {
                    if (_events[dateKey] == null) {
                      _events[dateKey] = [];
                    }
                    _events[dateKey]!.add({
                      'description': _eventController.text,
                      'completed': false,
                      'date': _selectedDate,
                      'time': TimeOfDay.now(),
                    });

                    widget.logMessages.value = [
                      ...widget.logMessages.value,
                      {
                        'description':
                            '🌟 USER 1 added an event: "${_eventController.text}" on ${_formatDate(_selectedDate)} at ${TimeOfDay.now().format(context)} ⏰ (Uncompleted)',
                        'completed': false,
                      },
                    ];
                    widget.logMessages.notifyListeners();
                  });

                  updateDialogState(() {});
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  /// Function to remove an event for the selected day.
  void _removeEvent(String dateKey, int index, StateSetter updateDialogState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove Event'),
          content: Text('Are you sure you want to remove this event?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String eventDescription =
                      _events[dateKey]![index]['description'];
                  DateTime eventDate = _events[dateKey]![index]['date'];
                  TimeOfDay eventTime = _events[dateKey]![index]['time'];

                  _events[dateKey]?.removeAt(index);
                  if (_events[dateKey]?.isEmpty ?? false) {
                    _events.remove(dateKey);
                  }

                  widget.logMessages.value = [
                    ...widget.logMessages.value,
                    {
                      'description':
                          '🌟 USER 1 removed an event: "$eventDescription" on ${_formatDate(eventDate)} at ${eventTime.format(context)} ⏰',
                      'completed': false,
                    },
                  ];
                  widget.logMessages.notifyListeners();
                });
                updateDialogState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  /// Toggle the completion status of an event.
  void _toggleEventCompletion(String dateKey, int index) {
    setState(() {
      bool isCompleted = _events[dateKey]![index]['completed'];
      _events[dateKey]![index]['completed'] = !isCompleted;

      String description = _events[dateKey]![index]['description'];
      DateTime eventDate = _events[dateKey]![index]['date'];
      TimeOfDay eventTime = _events[dateKey]![index]['time'];

      widget.logMessages.value = [
        ...widget.logMessages.value,
        {
          'description': isCompleted
              ? '🌟 USER 1 marked event as incomplete: "$description" on ${_formatDate(eventDate)} at ${eventTime.format(context)} ⏰'
              : '🌟 USER 1 marked event as complete: "$description" on ${_formatDate(eventDate)} at ${eventTime.format(context)} ⏰',
          'completed': !isCompleted,
        },
      ];
      widget.logMessages.notifyListeners();
    });
  }

  /// Get events for the selected date.
  List<Map<String, dynamic>> _getEventsForSelectedDate() {
    final dateKey = _formatDate(_selectedDate);
    return _events[dateKey] ?? [];
  }

  /// Scroll to the current date on initialization.
  void _scrollToCurrentDate() {
    final daysInMonth =
        DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final startWeekday = firstDayOfMonth.weekday;
    final indexToScroll = startWeekday - 1 + _selectedDate.day;
    final scrollPosition = (indexToScroll / 7).ceil() * 60.0;

    _scrollController.jumpTo(scrollPosition);
  }

  /// Get the days of the month to build the calendar grid.
  List<Widget> _buildCalendarGrid() {
    final daysInMonth =
        DateUtils.getDaysInMonth(_selectedDate.year, _selectedDate.month);
    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final startWeekday = firstDayOfMonth.weekday;

    List<Widget> dayWidgets = [];

    for (int i = 0; i < startWeekday - 1; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate =
          DateTime(_selectedDate.year, _selectedDate.month, day);
      final isSelected = currentDate.day == _selectedDate.day &&
          currentDate.month == _selectedDate.month &&
          currentDate.year == _selectedDate.year;
      final isToday = currentDate.day == DateTime.now().day &&
          currentDate.month == DateTime.now().month &&
          currentDate.year == DateTime.now().year;
      final hasEvents = _events[_formatDate(currentDate)] != null;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = currentDate;
            });
            _showEventsTab();
          },
          child: Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent : Colors.grey[800],
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    color: isToday
                        ? Color(0xFFFFD700)
                        : (isSelected ? Colors.deepPurple : Colors.white70),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (hasEvents)
                  Positioned(
                    bottom: 4.0,
                    child: Container(
                      width: 4.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return dayWidgets;
  }

  /// Show a tab to display events and allow adding a new event for the selected day.
  void _showEventsTab() {
    final dateKey = _formatDate(_selectedDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              contentPadding: EdgeInsets.all(16.0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Events for ${_formatDate(_selectedDate)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ..._getEventsForSelectedDate().asMap().entries.map((entry) {
                    int index = entry.key;
                    var event = entry.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            event['description'],
                            style: TextStyle(
                              color: event['completed']
                                  ? Colors.green
                                  : Colors.white,
                              decoration: event['completed']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _toggleEventCompletion(dateKey, index);
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: 50.0,
                            height: 25.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: event['completed']
                                  ? Colors.purple
                                  : Colors.grey,
                            ),
                            child: AnimatedAlign(
                              duration: Duration(milliseconds: 200),
                              alignment: event['completed']
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle,
                              color: Colors.redAccent),
                          onPressed: () {
                            _removeEvent(dateKey, index, setState);
                          },
                        ),
                      ],
                    );
                  }).toList(),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      _addEvent(setState);
                    },
                    child: Text('Add New Event'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Navigate to the previous month.
  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    });
    _scrollToCurrentDate();
  }

  /// Navigate to the next month.
  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
    });
    _scrollToCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _previousMonth,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_selectedDate),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: _nextMonth,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    color: (day == 'Sat' || day == 'Sun')
                        ? Color(0xFFFFD700)
                        : Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 4),
        Expanded(
          flex: 3,
          child: GridView.count(
            controller: _scrollController,
            crossAxisCount: 7,
            padding: EdgeInsets.all(4.0),
            children: _buildCalendarGrid(),
          ),
        ),
      ],
    );
  }
}
