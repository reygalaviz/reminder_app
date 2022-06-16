import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/models/color_data.dart';
import 'package:reminder_app/models/note_data_store.dart';
import 'package:reminder_app/screens/add_note.dart';
import 'package:reminder_app/screens/all_notes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';

import '../models/notes_operation.dart';
import 'all_notes.dart';
import 'edit_notes.dart';

String id = "No notes exist";
bool res = false;
Color colPick = Colors.white;
StreamSubscription<Map<String, dynamic>>? _subscription;
final _db = Localstore.instance;
final _items = <String, store.Notes>{};
String selectDate = "";
String title = "";
String body = "";
String daySelect = "";
Color selectColor = const Color.fromARGB(255, 180, 175, 174);
CalendarFormat format = CalendarFormat.month;
Map<DateTime, List<Notes>>? _events;
DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();

// late final ValueNotifier<List<Notes>> _selectedEvents;
//

class Table_Calendar extends StatefulWidget {
  const Table_Calendar({Key? key}) : super(key: key);

  @override
  State<Table_Calendar> createState() => Table_CalendarState();
}

class Table_CalendarState extends State<Table_Calendar> {
  // groupEvents(List<Notes> events) {
  //   String dateString = "";
  //   _groupedEvents = {};
  //   DateTime date = DateTime.now();
  //   for (var event in events) {
  //     dateString = event.date;
  //     date = DateTime.parse(dateString);
  //     if (_groupedEvents?[date] == null) {
  //       _groupedEvents?[date] = [];
  //     } else {
  //       _groupedEvents?[date]?.add(event);
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _events = {};
  }

  void dispose() {
    super.dispose();
  }

  List<Notes> _getEventsForDay(DateTime day) {
    return _events?[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
      });
      // _events.value = _getEventsForDay(selectedDay);
    }
  }

  Widget calendar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: const <BoxShadow>[]),
      child: TableCalendar<Notes>(
        focusedDay: _focusedDay,
        firstDay: DateTime(1990),
        lastDay: DateTime(3022),
        selectedDayPredicate: (DateTime day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: _onDaySelected,
        calendarFormat: format,
        onFormatChanged: (calformat) {
          setState(() {
            format = calformat;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        headerStyle: const HeaderStyle(
          leftChevronIcon: Icon(Icons.arrow_back_ios, size: 15),
          rightChevronIcon: Icon(Icons.arrow_forward_ios, size: 15),
        ),
        eventLoader: _getEventsForDay,
        calendarStyle: CalendarStyle(
            canMarkersOverflow: true,
            isTodayHighlighted: true,
            defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0)),
            weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0)),
            selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0)),
            todayDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(5.0)),
            selectedTextStyle: TextStyle(color: Theme.of(context).primaryColor),
            weekendTextStyle: TextStyle(color: Colors.red),
            todayTextStyle: TextStyle(
                fontWeight: FontWeight.w200,
                color: Theme.of(context).primaryColor)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Theme.of(context).backgroundColor,
      child: Column(children: [
        calendar(),
        const SizedBox(
          height: 8.0,
        ),
      ]),
    ));
  }
}
