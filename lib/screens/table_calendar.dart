import 'dart:async';
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
final items3 = <String, Repeat>{};
List<DateTime> done = [];

// late final ValueNotifier<List<Notes>> _selectedEvents;
//

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
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<Notes> _selectedEvents = [];

  //late final ValueNotifier<List<Notes>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    items1.clear();
    _selectedDay = DateTime.now();
    _selectedEvents = [];
    _db.collection('repeat').get().then((value) =>
        _subscription = _db.collection('repeat').stream.listen((event) {
          // setState(() {
          final item = Repeat.fromMap(event);
          items3.putIfAbsent(item.id, () => item);
          // });
        }));
  }

  Future addEvents() async {
    for (int i = 0; i < notes.length; i++) {
      var note1 = items[notes[i]];

      if (note1 != null) {
        if ((items1.indexWhere((element) => (element.id == note1.id)) == -1)) {
          var parsDate = DateTime.parse(note1.date);
          if (note1.done == false) {
            if (!items1.contains(note1)) {
              setState(() {
                items1.add(note1);
              });

              if (items3.containsKey(note1.id)) {
                Repeat? rex = items3[note1.id];
                if (rex!.option == "Daily") {
                  var selectDate2 = note1.date;
                  Notes lastNote = note1;
                  //items1.add(lastNote);
                  for (var i = 1; i <= 100; i++) {
                    DateTime g = DateTime.parse(selectDate2);
                    DateTime h = DateTime(g.year, g.month, g.day + 1);
                    selectDate2 = format2.format(h);

                    if (g.isBefore(DateTime.now())) {
                      String ter = channelCounter.toString();
                      //if (g.day != DateTime.now().day) {
                      if (notifs[lastNote.id] != null) {
                        ter = notifs[lastNote.id]!.id2;

                        NotificationService().deleteNotif(ter);
                      }

                      if (notifChoice == true) {
                        NotificationService().displayScheduleNotif(
                            body: body,
                            channel: channelCounter,
                            title: title,
                            date: h);
                      }

                      lastNote.delete();
                      int b = searchResults
                          .indexWhere((val) => val.id == lastNote.id);
                      if (b != -1) {
                        searchResults.removeAt(b);
                      }
                      int c = uncompleted
                          .indexWhere((val) => val.id == lastNote.id);
                      if (c != -1) {
                        uncompleted.removeAt(c);
                      }
                      items.remove(lastNote.id);
                      int d = items1
                          .indexWhere((element) => element.id == lastNote.id);
                      if (d != -1) {
                        items1.removeAt(d);
                      }
                      var x = items3[lastNote.id];
                      if (x != null) {
                        x.delete;
                      }
                      Repeat? f = items3[lastNote.id];
                      if (f != null) {
                        f.delete();
                      }
                      items3.remove(lastNote.id);
                      String id1 = store.db.collection('notes').doc().id;
                      //  id = id1;
                      Notes note = Notes(
                          id: id1,
                          title: note1.title,
                          data: note1.data,
                          date: selectDate2,
                          time: note1.time,
                          priority: note1.priority,
                          color: note1.color,
                          done: note1.done);
                      setState(() {
                        items1.add(note);
                      });
                      note.save();
                      Notifs notif = Notifs(
                        id: id1,
                        id2: ter,
                      );
                      notif.save();
                      searchResults.add(note);
                      uncompleted.add(note);
                      items.putIfAbsent(id1, () => note);
                      Repeat r = Repeat(id: id1, option: "Daily");
                      r.save();
                      lastNote = note;
                      // }
                    } else {
                      Notes note = Notes(
                          id: note1.id,
                          title: note1.title,
                          data: note1.data,
                          date: selectDate2,
                          time: note1.time,
                          priority: note1.priority,
                          color: note1.color,
                          done: note1.done);
                      setState(() {
                        items1.add(note);
                      });
                      lastNote = note;
                    }

                    bool biff = true;
                    for (int k = 0; k < done.length; k++) {
                      if (done[k] == h) {
                        biff = false;
                      }
                    }

                    if (biff == true) {
                      setState(() {
                        done.add(h);
                      });
                    }
                  }
                }

                if (rex.option == "Weekly") {
                  var selectDate2 = note1.date;
                  Notes lastNote = note1;
                  //items1.add(lastNote);
                  for (var i = 1; i <= 50; i++) {
                    DateTime g = DateTime.parse(selectDate2);
                    DateTime h = DateTime(g.year, g.month, g.day + 7);
                    selectDate2 = format2.format(h);

                    if (g.isBefore(DateTime.now())) {
                      // if (g.day != DateTime.now().day) {
                      String ter = notifs[lastNote.id]!.id2;

                      NotificationService().deleteNotif(ter);

                      if (notifChoice == true) {
                        NotificationService().displayScheduleNotif(
                            body: body,
                            channel: channelCounter,
                            title: title,
                            date: h);
                      }

                      lastNote.delete();
                      // items1.remove(lastNote);
                      int b = searchResults
                          .indexWhere((val) => val.id == lastNote.id);
                      if (b != -1) {
                        searchResults.removeAt(b);
                      }
                      int c = uncompleted
                          .indexWhere((val) => val.id == lastNote.id);
                      if (c != -1) {
                        uncompleted.removeAt(c);
                      }
                      items.remove(lastNote.id);
                      int d = items1
                          .indexWhere((element) => element.id == lastNote.id);
                      if (d != -1) {
                        items1.removeAt(d);
                      }
                      var x = items3[lastNote.id];
                      Repeat? f = items3[lastNote.id];
                      if (f != null) {
                        f.delete();
                      }
                      if (x != null) {
                        x.delete;
                      }
                      items3.remove(lastNote.id);
                      final id1 = store.db.collection('notes').doc().id;
                      // id = id1;
                      Notes note = Notes(
                          id: id1,
                          title: note1.title,
                          data: note1.data,
                          date: selectDate2,
                          time: note1.time,
                          priority: note1.priority,
                          color: note1.color,
                          done: note1.done);
                      setState(() {
                        items1.add(note);
                      });
                      note.save();
                      Notifs notif = Notifs(
                        id: id1,
                        id2: ter,
                      );
                      notif.save();
                      searchResults.add(note);
                      uncompleted.add(note);
                      items.putIfAbsent(id1, () => note);
                      Repeat r = Repeat(id: id1, option: "Weekly");
                      r.save();
                      items3.putIfAbsent(r.id, () => r);
                      lastNote = note;
                      // }
                    } else {
                      Notes note = Notes(
                          id: note1.id,
                          title: note1.title,
                          data: note1.data,
                          date: selectDate2,
                          time: note1.time,
                          priority: note1.priority,
                          color: note1.color,
                          done: note1.done);
                      setState(() {
                        items1.add(note);
                      });
                      lastNote = note;
                    }

                    bool biff = true;
                    for (int k = 0; k < done.length; k++) {
                      if (done[k] == h) {
                        biff = false;
                      }
                    }

                    if (biff == true) {
                      setState(() {
                        done.add(h);
                      });
                    }
                  }
                }
                if (rex.option == "Monthly") {
                  var selectDate2 = note1.date;
                  Notes lastNote = note1;
                  //items1.add(lastNote);
                  for (var i = 1; i <= 24; i++) {
                    DateTime g = DateTime.parse(selectDate2);

                    DateTime h = DateTime(g.year, g.month + 1, g.day);
                    selectDate2 = format2.format(h);

                    if (g.isBefore(DateTime.now())) {
                      if (g.day != DateTime.now().day) {
                        String ter = notifs[lastNote.id]!.id2;

                        NotificationService().deleteNotif(ter);

                        if (notifChoice == true) {
                          NotificationService().displayScheduleNotif(
                              body: body,
                              channel: channelCounter,
                              title: title,
                              date: h);
                        }

                        lastNote.delete();
                        // items1.remove(lastNote);
                        int b = searchResults
                            .indexWhere((val) => val.id == lastNote.id);
                        if (b != -1) {
                          searchResults.removeAt(b);
                        }
                        int c = uncompleted
                            .indexWhere((val) => val.id == lastNote.id);
                        if (c != -1) {
                          uncompleted.removeAt(c);
                        }
                        items.remove(lastNote.id);
                        int d = items1
                            .indexWhere((element) => element.id == lastNote.id);
                        if (d != -1) {
                          items1.removeAt(d);
                        }
                        var x = items3[lastNote.id];
                        if (x != null) {
                          x.delete;
                        }
                        Repeat? f = items3[lastNote.id];
                        if (f != null) {
                          f.delete();
                        }
                        items3.remove(lastNote.id);

                        final id1 = store.db.collection('notes').doc().id;
                        // id = id1;
                        Notes note = Notes(
                            id: id1,
                            title: note1.title,
                            data: note1.data,
                            date: selectDate2,
                            time: note1.time,
                            priority: note1.priority,
                            color: note1.color,
                            done: note1.done);
                        setState(() {
                          items1.add(note);
                        });
                        note.save();
                        Notifs notif = Notifs(
                          id: id1,
                          id2: ter,
                        );
                        notif.save();
                        searchResults.add(note);
                        uncompleted.add(note);
                        items.putIfAbsent(id1, () => note);
                        Repeat r = Repeat(id: id1, option: "Monthly");
                        r.save();
                        lastNote = note;
                      }
                    } else {
                      Notes note = Notes(
                          id: note1.id,
                          title: note1.title,
                          data: note1.data,
                          date: selectDate2,
                          time: note1.time,
                          priority: note1.priority,
                          color: note1.color,
                          done: note1.done);
                      setState(() {
                        items1.add(note);
                      });
                      lastNote = note;
                    }
                    bool biff = true;
                    for (int k = 0; k < done.length; k++) {
                      if (done[k] == h) {
                        biff = false;
                      }
                    }

                    if (biff == true) {
                      setState(() {
                        done.add(h);
                      });
                    }
                  }
                }
                if (rex.option == "Yearly") {
                  var selectDate2 = note1.date;
                  Notes lastNote = note1;
                  // String id = lastNote.id;
                  // items1.add(lastNote);
                  for (var i = 1; i <= 10; i++) {
                    DateTime g = DateTime.parse(selectDate2);
                    DateTime h = DateTime(g.year + 1, g.month, g.day);
                    selectDate2 = format2.format(h);
                    if (g.isBefore(DateTime.now())) {
                      if (g.day != DateTime.now().day) {
                        String ter = notifs[lastNote.id]!.id2;

                        NotificationService().deleteNotif(ter);

                        if (notifChoice == true) {
                          NotificationService().displayScheduleNotif(
                              body: body,
                              channel: channelCounter,
                              title: title,
                              date: h);
                        }

                        lastNote.delete();
                        // items1.remove(lastNote);
                        int b = searchResults
                            .indexWhere((val) => val.id == lastNote.id);
                        if (b != -1) {
                          searchResults.removeAt(b);
                        }
                        int c = uncompleted
                            .indexWhere((val) => val.id == lastNote.id);
                        if (c != -1) {
                          uncompleted.removeAt(c);
                        }
                        items.remove(lastNote.id);
                        int d = items1
                            .indexWhere((element) => element.id == lastNote.id);
                        if (d != -1) {
                          items1.removeAt(d);
                        }
                        var x = items3[lastNote.id];
                        if (x != null) {
                          x.delete;
                        }
                        Repeat? f = items3[lastNote.id];
                        if (f != null) {
                          f.delete();
                        }
                        items3.remove(lastNote.id);
                        final id1 = store.db.collection('notes').doc().id;
                        //id = id1;
                        Notes note = Notes(
                            id: id1,
                            title: note1.title,
                            data: note1.data,
                            date: selectDate2,
                            time: note1.time,
                            priority: note1.priority,
                            color: note1.color,
                            done: note1.done);
                        setState(() {
                          items1.add(note);
                        });
                        note.save();
                        Notifs notif = Notifs(
                          id: id1,
                          id2: ter,
                        );
                        notif.save();
                        searchResults.add(note);
                        uncompleted.add(note);
                        items.putIfAbsent(id1, () => note);
                        Repeat r = Repeat(id: id1, option: "Yearly");
                        r.save();
                        lastNote = note;
                      }
                    } else {
                      Notes note = Notes(
                          id: note1.id,
                          title: note1.title,
                          data: note1.data,
                          date: selectDate2,
                          time: note1.time,
                          priority: note1.priority,
                          color: note1.color,
                          done: note1.done);
                      setState(() {
                        items1.add(note);
                      });
                      lastNote = note;
                    }

                    bool biff = true;
                    for (int k = 0; k < done.length; k++) {
                      if (done[k] == h) {
                        biff = false;
                      }
                    }

                    if (biff == true) {
                      setState(() {
                        done.add(h);
                      });
                    }
                  }
                }
              }
              bool biff = true;
              for (int k = 0; k < done.length; k++) {
                if (done[k] == parsDate) {
                  biff = false;
                }
              }
              if (biff == true) {
                setState(() {
                  done.add(parsDate);
                });
              }
            }
          }
        }

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
    }
  }

  @override
  void dispose() {
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

                    notes.removeWhere((element) => element == item.id);

                    item.delete();

                    notes.remove(item.id);
                  });
                  String not = notifs[item.id]!.id2;
                  NotificationService().deleteNotif(not);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              home.Home2(key: UniqueKey(), boo: true)));
                  //  Navigator.pop(context);
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
            titleTextStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            leftChevronIcon: Icon(
              Icons.arrow_back_ios,
              size: 15,
              color: Theme.of(context).primaryColor,
            ),
            rightChevronIcon: Icon(
              Icons.arrow_forward_ios,
              size: 15,
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
    return Scaffold(
        body: Container(
            color: Theme.of(context).backgroundColor,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        // var item = items1.elementAt(index);
                        var item = items1[index];
                        // final item = items1[key]!;
                        DateFormat format = DateFormat("yyyy-MM-dd");
                        String day2 = format.format(_selectedDay);
                        don = item.done;
                        String id5 = item.id;
                        if (item.date == day2 && item.done == false) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        await _showDialog(item);
                                      },
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0)),
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: FontAwesomeIcons.trash,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  title: Text(
                                    item.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    "${item.time}     ${item.data}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  tileColor: invisColor(item),
                                  onTap: () {
                                    id5 = item.id;

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditNote(id: id5)));
                                  },
                                  trailing: Wrap(children: <Widget>[
                                    CheckBoxNote(id: id5)
                                  ]),
                                ),
                              ));
                        } else {
                          return Container();
                        }
                      }))
            ])));
  }
}
