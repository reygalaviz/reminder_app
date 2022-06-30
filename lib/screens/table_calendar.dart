import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/note_data_store.dart';
import 'package:reminder_app/screens/all_notes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'home.dart' as home;
import 'package:reminder_app/Screens/cal_edit_note.dart';

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
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<DateTime> done = [];

  List<Notes> _selectedEvents = [];

  //late final ValueNotifier<List<Notes>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedEvents = [];

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
        _selectedEvents = _getEventsForDay(selectedDay);
      });
      // _events.value = _getEventsForDay(selectedDay);
    }
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
                  Navigator.pop(context);
                },
                child: const Text("Delete"))
          ],
        );
      },
    );
  }

  Widget calendar() {
    addEvents();
    return Container(
      key: UniqueKey(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: const <BoxShadow>[]),
      child: Card(
        elevation: 2.0,
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        margin: const EdgeInsets.all(8.0),
        child: TableCalendar<Notes>(
          focusedDay: _focusedDay,
          firstDay: DateTime(1990),
          lastDay: DateTime(3022),
          selectedDayPredicate: (DateTime day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: _onDaySelected,
          calendarFormat: format,
          onFormatChanged: (CalendarFormat calformat) {
            if (calformat != format) {
              setState(() {
                format = calformat;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: _getEventsForDay,
          headerStyle: const HeaderStyle(
            formatButtonTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            formatButtonDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            leftChevronIcon: Icon(
              Icons.arrow_back_ios,
              size: 15,
            ),
            rightChevronIcon: Icon(Icons.arrow_forward_ios, size: 15),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontWeight: FontWeight.bold)),
          calendarStyle: CalendarStyle(
              canMarkersOverflow: true,
              isTodayHighlighted: true,
              markersMaxCount: 4,
              markerDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))),
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
                  color: const Color.fromARGB(255, 255, 171, 75),
                  borderRadius: BorderRadius.circular(5.0)),
              selectedTextStyle: const TextStyle(fontWeight: FontWeight.w600),
              // weekendTextStyle: const TextStyle(color: Colors.red),
              todayTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor)),
        ),
      ),
    );
  }

  Widget eventTitle() {
    String formattedDate = DateFormat.MMMMEEEEd().format(_selectedDay);
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        padding: EdgeInsets.only(left: constraints.maxWidth * .025),
        child: Text(
          formattedDate,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      calendar(),
                      const SizedBox(
                        height: 8.0,
                      ),
                      eventTitle(),
                      const Divider(
                        height: 15,
                        thickness: 2.0,
                        indent: 10.0,
                        endIndent: 10.0,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: _items.keys.length,
                              itemBuilder: (context, index) {
                                final key = _items.keys.elementAt(index);
                                final item = _items[key]!;
                                DateFormat format = DateFormat("yyyy-MM-dd");
                                String day2 = format.format(_selectedDay);
                                if (item.date == day2) {
                                  return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListTile(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          title: Text(
                                            item.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          subtitle: Text(
                                            '${item.date} ${item.time}',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          tileColor: invisColor(item),
                                          onTap: () {
                                            id = item.id;

                                            showModalBottomSheet(
                                                enableDrag: false,
                                                isScrollControlled: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20.0))),
                                                context: context,
                                                builder: (context) {
                                                  return EditNote(id: id);
                                                });
                                          },
                                          trailing: IconButton(
                                              icon: const Icon(
                                                FontAwesomeIcons.trash,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              onPressed: () async {
                                                await _showDialog(item);
                                                if (res == true) {
                                                  setState(() {
                                                    _items.remove(item.id);
                                                    res = false;
                                                    items.remove(item.id);
                                                    item.delete();

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const home
                                                                    .Home2()));
                                                  });
                                                }
                                              })));
                                } else {
                                  return Container();
                                }
                              }))
                    ]))));
  }
}
