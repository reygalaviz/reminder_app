import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/models/notes_operation.dart';

class Clean_Calendar extends StatefulWidget {
  const Clean_Calendar({Key? key}) : super(key: key);

  @override
  State<Clean_Calendar> createState() => _Clean_CalendarState();
}

class _Clean_CalendarState extends State<Clean_Calendar> {
  List<NeatCleanCalendarEvent> _selectedEvents = [];
  final Map<DateTime, List<NeatCleanCalendarEvent>> _events = {};
  DateTime _selectedDay = DateTime.now();

  void _handleDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedDay);
  }

  @override
  void initState() {
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  Widget calendar() {
    return Expanded(
      child: Calendar(
        startOnMonday: false,
        weekDays: const ['Sun', 'Mon', 'Tues', 'Wed', 'Th', 'Fri', 'Sat'],
        isExpandable: true,
        selectedColor: Colors.black,
        todayColor: Colors.amber,
        eventColor: Colors.red,
        eventDoneColor: Colors.green,
        bottomBarColor: Colors.deepOrange,
        onRangeSelected: (range) {
          print('Selected Day ${range.from}, ${range.to}');
        },
        onDateSelected: (date) {
          return _handleDate(date);
        },
        isExpanded: true,
        events: _events,
        dayOfWeekStyle: const TextStyle(
            fontSize: 13, color: Colors.black, fontWeight: FontWeight.w900),
        bottomBarTextStyle: const TextStyle(color: Colors.white),
        hideArrows: false,
      ),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: Consumer<NotesOperation>(
          builder: (context, NotesOperation data, child) {
        return ListView.builder(
          padding: const EdgeInsets.all(0.0),
          // itemCount: data.getNotes.length,
          itemBuilder: (context, index) {
            final NeatCleanCalendarEvent event = _selectedEvents[index];
            return ListTile(
              contentPadding: const EdgeInsets.only(
                  left: 2.0, right: 8.0, top: 2.0, bottom: 2.0),
              leading: Container(
                width: 10.0,
                color: event.color,
              ),
              title: Text(event.summary),
              onTap: () {},
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          width: double.infinity,
          child: Column(children: [
            calendar(),
            const SizedBox(
              height: 10,
            ),
            _buildEventList()
          ]),
        ),
      ),
    );
  }
}
