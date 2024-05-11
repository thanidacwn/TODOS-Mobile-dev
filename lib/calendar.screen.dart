import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_ui_flutter/models/todo.model.dart';
import 'package:to_do_ui_flutter/services/firestore.dart';

class CalendarScreen extends StatefulWidget {
  // This class will hold the calendar screen
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // This class will hold the calendar screen
  Map<DateTime, List<dynamic>> _events = HashMap<DateTime, List<dynamic>>();
  final FireStoreService fireStoreService = FireStoreService();
  List<ToDoModel> items = <ToDoModel>[];
  List<dynamic> _selectedEvents = <ToDoModel>[];

  DateTime focusedDay = DateTime.now();

  Map<DateTime, List<dynamic>> _groupEvents(List<ToDoModel> allEvents) {
    final Map<DateTime, List<dynamic>> data = {};
    for (final ToDoModel event in allEvents) {
      final DateTime date = DateTime.parse(event.todoDate!);
      final DateTime day = DateTime.utc(date.year, date.month, date.day);
      if (data[day] == null) {
        data[day] = [];
      }
      data[day]!.add(event);
    }
    return data;
  }

  void _onDaySelected(DateTime day, DateTime focusDay) {
    // This function will be called when a day is selected
    setState(() {
      focusedDay = focusDay;
      _selectedEvents = _events[day] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'Calendar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: fireStoreService.getTodos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                items = snapshot.data!.docs
                    .map((e) => ToDoModel(
                          todoId: e.id,
                          todoTopic: e['todoTopic'],
                          todoDescription: e['todoDescription'],
                          todoDate: e['todoDate'],
                          todoStatus: e['todoStatus'],
                        ))
                    .where((todo) => todo.todoStatus == 'pending')
                    .toList();

                if (items.isNotEmpty) {
                  _events = _groupEvents(items);
                }
              }

              return Container(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: TableCalendar(
                            // rowHeight: 60,
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            selectedDayPredicate: (day) =>
                                isSameDay(day, focusedDay),
                            focusedDay: focusedDay,
                            headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true),
                            onDaySelected: _onDaySelected,
                            weekendDays: const [
                              DateTime.saturday,
                              DateTime.sunday
                            ],
                            calendarStyle: const CalendarStyle(
                              weekendTextStyle: TextStyle(
                                color: Colors.red,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Colors.deepPurple,
                                shape: BoxShape.circle,
                              ),
                              markersMaxCount: 1,
                              outsideDaysVisible: false,
                              markerDecoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            eventLoader: (day) {
                              return _events[day] ?? [];
                            },
                          ),
                        ),
                        ..._selectedEvents.map((event) => Container(
                            // padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),

                            child: Card(
                                elevation: 7,
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(event.todoTopic!),
                                  subtitle: Text(event.todoDescription!),
                                  leading: const Icon(Icons.event_note),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(event.todoTopic!),
                                            content:
                                                Text(event.todoDescription!),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Close'))
                                            ],
                                          );
                                        });
                                  },
                                  // contentPadding: const EdgeInsets.all(10),
                                )))),
                      ])));
            }));
  }
}
