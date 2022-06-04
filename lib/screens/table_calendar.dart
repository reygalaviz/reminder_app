import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendar extends StatefulWidget {
  @override
  State<TableCalendar> createState() => _TableCalendarState();
}

class _TableCalendarState extends State<TableCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Calendar(
            selectedColor: Colors.red,
            selectedTodayColor: Colors.blue,
            todayColor: Colors.blue,
            eventColor: Colors.green,
            eventDoneColor: Colors.amber,
            bottomBarColor: Colors.deepOrange,
            onRangeSelected: (range) {
              print('Selected Day ${range.from}, ${range.to}');
            },
            isExpanded: true,
            dayOfWeekStyle: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
            bottomBarTextStyle: const TextStyle(
              color: Colors.white,
            ),
            hideArrows: false,
            weekDays: ['Sun', 'Mon', 'Tues', 'Wed', 'Thu', 'Fri', 'Sat'],
          ),
        ),
      ),
    );
  }
}
