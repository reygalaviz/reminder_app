import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/color_data.dart';
import 'package:reminder_app/models/note_data_store.dart';
import 'package:reminder_app/screens/add_note.dart';
import 'package:reminder_app/screens/all_notes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';

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

// Map<DateTime, List<Notes>>? _events;
// late final ValueNotifier<List<Notes>> _selectedEvents;

CalendarFormat format = CalendarFormat.month;
List<Notes> _events = [];
LinkedHashMap<DateTime, List<Notes>>? _groupedEvents;
DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();
DateFormat formatter = DateFormat("yyyy-MM-dd");

class Table_Calendar extends StatefulWidget {
  const Table_Calendar({Key? key}) : super(key: key);

  @override
  State<Table_Calendar> createState() => Table_CalendarState();
}

class Table_CalendarState extends State<Table_Calendar> {
  void initState() {
    super.initState();
    _db.collection('notes').get().then((value) {
      _subscription = _db.collection('notes').stream.listen((event) {
        setState(() {
          final item = store.Notes.fromMap(event);
          _items.putIfAbsent(item.id, () => item);
          _events.add(item);
        });
      });
    });
    // _selectedDay = DateTime.now();
    // _selectedEvents = ValueNotifier(_getEventsFromDay(_selectedDay));
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  // Future addEvents() async {
  //   await _db.collection('notes').get().then((events) {
  //     final id = Localstore.instance.collection("notes").doc().id;
  //     Color color = Color.fromARGB(199, 148, 84, 84);
  //     String color1 = color.toString();
  //     DateTime date = DateTime.now();

  //     for (var i = 0; i < events!.length; i++) {
  //       final id = Localstore.instance.collection("notes").doc().id;
  //       String priority = "high";
  //       final item1 = store.Notes(
  //           id: id,
  //           title: title,
  //           data: body,
  //           date: selectDate,
  //           time: daySelect,
  //           priority: priority,
  //           color: colPick.value.toString());
  //       item1.save();
  //     }
  //     setState(() {
  //       res = true;
  //     });
  //   });
  //   groupEvents(_events);
  // }

  groupEvents(List<Notes> events) {
    String dateString = "";

    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    DateTime date = DateTime.now();
    for (var event in _events) {
      dateString = event.date;
      date = DateTime.parse(dateString);
      // DateTime date = DateTime.utc().;
      if (_groupedEvents![date] == null) _groupedEvents![date] = [];
      _groupedEvents![date]?.add(event);
    }
  }

  List<Notes> _getEventsFromDay(DateTime date) {
    return _groupedEvents?[date] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
      });
    }
  }

  void dispose() {
    String troll = "hey rey this is a merge conflict";
    print(troll);
    super.dispose();
  }

  Widget calendar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
            )
          ]),
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
          leftChevronIcon:
              Icon(Icons.arrow_back_ios, size: 15, color: Colors.black),
          rightChevronIcon:
              Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black),
        ),
        eventLoader: _getEventsFromDay,
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

  Widget eventTitle() {
    if (_items.keys.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(2, 20, 15, 15),
        child: Text("No events",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            )),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.red,
          child: Text(
            "Events",
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
        ),
      ],
    );
  }

  Widget events() {
    return Expanded(
      child: ListView.builder(
          itemCount: _items.keys.length,
          itemBuilder: (context, index) {
            final key = _items.keys.elementAt(index);
            final item = _items[key]!;
            return Card(
              child: ListTile(
                  title: Text(
                    item.title,
                  ),
                  tileColor: Color(int.parse(item.color)).withOpacity(1),
                  onTap: () {
                    id = item.id;
                    //make a map to handle this
                    showModalBottomSheet(
                        enableDrag: false,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0))),
                        context: context,
                        builder: (context) {
                          return EditNote(id: id);
                        });
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),

                    onPressed: () async {
                      await _showDialog(item);
                      if (res == true) {
                        setState(() {
                          item.delete();
                          _items.remove(item.id);
                          res = false;
                        });
                      }
                    }, //Center(
                    //  child: Text(
                    //item.data,
                  )),
            );
          }),
    );
  }

  Future<bool?> _showDialog(final item) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a permanent and data cannot be recovered again!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                res = false;
              },
            ),
            TextButton(
                onPressed: () {
                  res = true;
                  Navigator.of(context).pop();
                },
                child: const Text("Delete"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Theme.of(context).backgroundColor,
      child: Column(children: [
        calendar(),
        eventTitle(),
        const SizedBox(
          height: 8.0,
        ),
        events(),
      ]),
    ));
  }
}
