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
import 'home.dart' as home;
import 'all_notes.dart';

String id = "No notes exist";
bool res = false;
Color colPick = Colors.white;
StreamSubscription<Map<String, dynamic>>? _subscription;

// late final ValueNotifier<List<Notes>> _selectedEvents;
//

class Table_Calendar extends StatefulWidget {
  const Table_Calendar({Key? key}) : super(key: key);

  @override
  State<Table_Calendar> createState() => Table_CalendarState();
}

class Table_CalendarState extends State<Table_Calendar> {
  final _db = Localstore.instance;
  final _items = <String, store.Notes>{};
  String selectDate = "";
  String title = "";
  String body = "";
  String daySelect = "";
  Color selectColor = const Color.fromARGB(255, 180, 175, 174);
  CalendarFormat format = CalendarFormat.month;
  final Map<DateTime, List<Notes>> _events = {};
  DateTime? _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<DateTime> done = [];
  //late final ValueNotifier<List<Notes>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();

    _db.collection('notes').get().then((value) {
      _subscription = _db.collection('notes').stream.listen((event) {
        setState(() {
          final item = store.Notes.fromMap(event);
          _items.putIfAbsent(item.id, () => item);
          final parsDate = DateTime.parse(item.date);
          //parsDate.toUtc();

          done.add(parsDate);

          //so we have a parsdate map to hold every note occuring during that day
        });
      });
    });
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  // int getHashCode(DateTime key) {
  //   return key.day * 1000000 + key.month * 10000 + key.year;
  // }

  Future addEvents() async {
    for (var value in done) {
      List<Notes> list = [];

      _items.forEach((id, item) {
        final parsDate = DateTime.parse(item.date);
        if (parsDate == value) {
          list.add(item);
        }
      });
      // print(list);
      setState(() {
        _events.putIfAbsent(value, () => list);
        //print(_events[value]);
      });
    }
  }

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
  void dispose() {
    super.dispose();
  }

  List<Notes> _getEventsForDay(DateTime day) {
    //print(day);
    DateFormat format = DateFormat("yyyy-MM-dd");
    String day2 = format.format(day);

    List<Notes>? list2;
    //print(_events[DateTime.parse(day2)]);
    list2 = _events[DateTime.parse(day2)] ?? [];
    //print(_events.entries);

    //list2 as List<Notes>;
    return list2;
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
    addEvents();
    return Container(
      key: UniqueKey(),
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
          if (calformat != format) {
            setState(() {
              calformat = format;
            });
          }
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
            weekendTextStyle: const TextStyle(color: Colors.red),
            todayTextStyle: TextStyle(
                fontWeight: FontWeight.w200,
                color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Color? invisColor(item) {
    return Color(int.parse(item.color)).withOpacity(1);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.white30,
        ),
        onDismissed: (direct) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const home.Home()),
          );
        },
        direction: DismissDirection.horizontal,
        child: Scaffold(
            body: Container(
                color: Theme.of(context).backgroundColor,
                child: Column(children: [
                  calendar(),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: _items.keys.length,
                          itemBuilder: (context, index) {
                            final key = _items.keys.elementAt(index);
                            final item = _items[key]!;
                            DateFormat format = DateFormat("yyyy-MM-dd");
                            String day2 = format.format(_selectedDay!);
                            if (item.date == day2) {
                              return Card(
                                  child: ListTile(
                                title: Text(
                                  item.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                subtitle: Text(
                                  '${item.date} ${item.time}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                tileColor: invisColor(item),
                              ));
                            } else {
                              return Container();
                            }
                          }))
                ]))));
  }
}
