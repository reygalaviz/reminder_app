import 'dart:async';
import 'dart:math';
import 'package:flutter_slidable/flutter_slidable.dart';
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
import 'package:reminder_app/controllers/notifications.dart';
import 'package:reminder_app/screens/checkbox.dart';
import 'package:reminder_app/models/repeat_store.dart';
import 'package:reminder_app/main.dart';
import 'package:reminder_app/models/notif_data_store.dart';

// String id = "No notes exist";

bool don = false;
Color colPick = Colors.white;
StreamSubscription<Map<String, dynamic>>? _subscription;
//final items1 = <String, store.Notes>{};
List<Notes> items1 = [];
ValueNotifier<bool> bel = ValueNotifier(false);
List<DateTime> done = [];
DateTime calSelect = DateTime.now();
// late final ValueNotifier<List<Notes>> _selectedEvents;

class Table_Calendar extends StatefulWidget {
  const Table_Calendar({Key? key}) : super(key: key);

  @override
  State<Table_Calendar> createState() => Table_CalendarState();
}

class Table_CalendarState extends State<Table_Calendar> {
  final _db = Localstore.instance;
  DateFormat format2 = DateFormat("yyyy-MM-dd");

  String selectDate = "";
  String title = "";
  String body = "";
  String daySelect = "";
  Color selectColor = const Color.fromARGB(255, 180, 175, 174);
  CalendarFormat format = CalendarFormat.month;
  final Map<DateTime, List<Notes>> _events = {};
  DateTime? _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<Notes> _selectedEvents = [];

  //late final ValueNotifier<List<Notes>> _selectedEvents;

  @override
  void initState() {
    super.initState();

    //items1.clear();
    _selectedDay = DateTime.now();
    _selectedEvents = [];
  }

  Future addEvents() async {
    for (var value in done) {
      List<Notes> list = [];

      for (var ite in items1) {
        final parsDate = DateTime.parse(ite.date);
        if (parsDate == value) {
          list.add(ite);
        }
      }

      setState(() {
        if (_events.containsKey(value)) {
          _events.update(value, (value) => list);
        } else {
          _events.putIfAbsent(value, () => list);
        }
      });
    }
  }
  //   }
  // }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription!.cancel();
    }
    super.dispose();
  }

  List<Notes> _getEventsForDay(DateTime day) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    String day2 = format.format(day);

    List<Notes>? list2;

    list2 = _events[DateTime.parse(day2)] ?? [];

    return list2;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        calSelect = selectedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  Future<bool?> _showDialog(Notes item) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
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
              child: Text('Cancel',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    int b =
                        searchResults.indexWhere((val) => val.id == item.id);
                    if (b != -1) {
                      searchResults.removeAt(b);
                    }
                    int c = uncompleted.indexWhere((val) => val.id == item.id);
                    if (c != -1) {
                      uncompleted.removeAt(c);
                    }
                    items.remove(item.id);
                    int d =
                        items1.indexWhere((element) => element.id == item.id);
                    if (d != -1) {
                      items1.removeAt(d);
                    }
                    done.remove(DateTime.parse(item.date));
                    notes.removeWhere((element) => element == item.id);

                    item.delete();

                    notes.remove(item.id);
                  });
                  String not = notifs[item.id]!.id2;
                  NotificationService().deleteNotif(not);
                  ee.value = !ee.value;
                  Navigator.pop(context);

                  // Navigator.pop(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             home.Home2(key: UniqueKey(), boo: true)));
                },
                child:
                    const Text("Delete", style: TextStyle(color: Colors.red)))
          ],
        );
      },
    );
  }

  Widget calendar() {
    addEvents();
    return ValueListenableBuilder(
        valueListenable: bel,
        builder: (context, value, child) {
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
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                  leftChevronIcon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  rightChevronIcon: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(fontWeight: FontWeight.bold)),
                calendarStyle: CalendarStyle(
                    canMarkersOverflow: true,
                    isTodayHighlighted: true,
                    markersMaxCount: 4,
                    markerDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))),
                    defaultDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0)),
                    weekendDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0)),
                    selectedDecoration: BoxDecoration(
                        color: Colors.blue[700],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0)),
                    todayDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: const Color.fromARGB(255, 255, 171, 75),
                        borderRadius: BorderRadius.circular(5.0)),
                    selectedTextStyle: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                    // weekendTextStyle: const TextStyle(color: Colors.red),
                    todayTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor)),
              ),
            ),
          );
        });
  }

  Widget eventTitle() {
    String formattedDate = DateFormat.MMMMEEEEd().format(_selectedDay!);
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  itemCount: items1.length,
                  itemBuilder: (context, index) {
                    var item = items1[index];

                    DateFormat format = DateFormat("yyyy-MM-dd");
                    String day2 = format.format(_selectedDay!);
                    don = item.done;
                    String id5 = item.id;
                    if (item.date == day2 && item.done == false) {
                      return Slidable(
                        endActionPane: ActionPane(
                          dragDismissible: true,
                          extentRatio: .3,
                          motion: const StretchMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                await _showDialog(item);
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: FontAwesomeIcons.trash,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color:
                                  Color(int.parse(item.color)).withOpacity(1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            subtitle: Text(
                              "${item.time}     ${item.data}",
                              maxLines: 2,
                              style: const TextStyle(color: Colors.black),
                            ),
                            // tileColor: invisColor(item),
                            onTap: () {
                              id5 = item.id;

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             EditNote(id: id5)));
                              showModalBottomSheet(
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.0))),
                                  builder: (context) {
                                    return EditNote(id: id5);
                                  });
                            },
                            trailing:
                                Wrap(children: <Widget>[CheckBoxNote(id: id5)]),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  })),
        ]));
  }
}
