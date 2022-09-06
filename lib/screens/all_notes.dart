import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'package:reminder_app/screens/checkbox.dart';
import 'package:reminder_app/screens/completed_notes.dart';
import 'dart:async';
import 'package:reminder_app/screens/edit_notes.dart';
import '../models/note_data_store.dart';
import 'home.dart' as home;
import 'package:reminder_app/models/notif_data_store.dart';
import 'package:reminder_app/controllers/notifications.dart';
import 'table_calendar.dart';
import 'package:reminder_app/main.dart';
import 'package:reminder_app/models/notif_option.dart';
import 'package:reminder_app/models/repeat_store.dart';

int initNumber = 0;

var items = <String, store.Notes>{};
var notifs = <String, Notifs>{};
List<NotifSetting> notifSet = <NotifSetting>[];
//String id = "No notes exist";
bool res = false;
final Map<DateTime, List<Notes>> events1 = {};
// List<Notes> searchResults = <Notes>[];
// List<String> notes = <String>[];
// List<Notes> uncompleted = <Notes>[];

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> with TickerProviderStateMixin {
  String data = "No notes yet!";
  final _db = Localstore.instance;
  DateFormat format2 = DateFormat("yyyy-MM-dd");

  StreamSubscription<Map<String, dynamic>>? _subscription;
  String formattedDate = DateFormat.MMMMEEEEd().format(DateTime.now());
  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _db.collection('notes').get().then((value) {
      _subscription = _db.collection('notes').stream.listen((event) {
        setState(() {
          final item = store.Notes.fromMap(event);
          if (!notes.contains(item.id)) {
            notes.add(item.id);
            searchResults.add(item);

            if (item.done == false) {
              if (uncompleted.indexWhere((element) => element.id == item.id) ==
                  -1) {
                uncompleted.add(item);
              }
            }
          }
          DateTime dateOfNote = DateTime.parse(item.date);
          if (items1.indexWhere((element) => element.id == item.id) == -1) {
            items1.add(item);
          }
          bool biff = done.contains(dateOfNote);
          if (biff == false) {
            setState(() {
              done.add(dateOfNote);
            });
          }

          items.putIfAbsent(item.id, () => item);
        });
      });
    });
    _db
        .collection("notifs")
        .doc()
        .get()
        .then((value) => _db.collection('notifs').stream.listen((event) {
              setState(() {
                final item = Notifs.fromMap(event);
                notifs.putIfAbsent(item.id, () => item);
              });
            }));

    _db
        .collection('notifOption')
        .get()
        .then((value) => _db.collection("notifOption").stream.listen((event) {
              setState(() {
                final item = NotifSetting.fromMap(event);
                notifSet.add(item);
              });
            }));
    _db.collection('repeat').get().then((value) =>
        _subscription = _db.collection('repeat').stream.listen((event) {
          final item = Repeat.fromMap(event);
          items3.putIfAbsent(item.id, () => item);
        }));
  }

  Widget notesCard() {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: events1.length,
          itemBuilder: (context, index) {
            DateTime ind = done[index];
            String ind1 = DateFormat.MMMMEEEEd().format(ind);
            List<Notes> x = events1[ind] ?? [];
            return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Text(
                      ind1,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: x.length,
                        itemBuilder: (context, index) {
                          final item = x[index];

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
                                  texter(item2: item),
                                  maxLines: 2,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                tileColor:
                                    Color(int.parse(item.color)).withOpacity(1),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditNote(id: item.id)));
                                },
                                trailing: Wrap(children: <Widget>[
                                  CheckBoxNote(id: item.id)
                                ]),
                              ),
                            ),
                          );
                        })
                  ],
                ));
          }),
    );
  }

  DateTime timeConvert(String normTime) {
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);
    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return DateTime(2022, 1, 1, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    items.forEach((key, value) {
      Repeat? ider = items3[key];
      if (ider != null) {
        Notes? note1 = value;

        if (ider.option == "Daily") {
          var selectDate2 = note1.date;
          Notes lastNote = note1;
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
              int hour = 0;
              int minute = 0;
              String ampm = note1.time.substring(note1.time.length - 2);
              String result = note1.time.substring(0, note1.time.indexOf(' '));
              if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
                hour = int.parse(result.split(':')[0]);
                if (hour == 12) hour = 0;
                minute = int.parse(result.split(":")[1]);
              } else {
                hour = int.parse(result.split(':')[0]) - 12;
                if (hour <= 0) {
                  hour = 24 + hour;
                }
                minute = int.parse(result.split(":")[1]);
              }
              DateTime he = h.add(Duration(hours: hour, minutes: minute));
              if (notifChoice == true) {
                NotificationService().displayScheduleNotif(
                    body: note1.data,
                    channel: channelCounter,
                    title: note1.title,
                    date: he);
              }

              lastNote.delete();
              int b = searchResults.indexWhere((val) => val.id == lastNote.id);
              if (b != -1) {
                searchResults.removeAt(b);
              }
              int c = uncompleted.indexWhere((val) => val.id == lastNote.id);
              if (c != -1) {
                uncompleted.removeAt(c);
              }
              items.remove(lastNote.id);
              int d = items1.indexWhere((element) => element.id == lastNote.id);
              if (d != -1) {
                items1.removeAt(d);
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

              items1.add(note);

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

              items1.add(note);

              lastNote = note;
            }

            bool biff = done.contains(h);
            if (biff == false) {
              done.add(h);
            }
          }
        }

        if (ider.option == "Weekly") {
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
              int hour = 0;
              int minute = 0;
              String ampm = note1.time.substring(note1.time.length - 2);
              String result = note1.time.substring(0, note1.time.indexOf(' '));
              if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
                hour = int.parse(result.split(':')[0]);
                if (hour == 12) hour = 0;
                minute = int.parse(result.split(":")[1]);
              } else {
                hour = int.parse(result.split(':')[0]) - 12;
                if (hour <= 0) {
                  hour = 24 + hour;
                }
                minute = int.parse(result.split(":")[1]);
              }
              DateTime he = h.add(Duration(hours: hour, minutes: minute));
              if (notifChoice == true) {
                NotificationService().displayScheduleNotif(
                    body: note1.data,
                    channel: channelCounter,
                    title: note1.title,
                    date: he);
              }
              lastNote.delete();
              // items1.remove(lastNote);
              int b = searchResults.indexWhere((val) => val.id == lastNote.id);
              if (b != -1) {
                searchResults.removeAt(b);
              }
              int c = uncompleted.indexWhere((val) => val.id == lastNote.id);
              if (c != -1) {
                uncompleted.removeAt(c);
              }
              items.remove(lastNote.id);
              int d = items1.indexWhere((element) => element.id == lastNote.id);
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

              items1.add(note);

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

              items1.add(note);

              lastNote = note;
            }

            bool biff = done.contains(h);
            if (biff == false) {
              done.add(h);
            }
          }
        }
        if (ider.option == "Monthly") {
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
                int hour = 0;
                int minute = 0;
                String ampm = note1.time.substring(note1.time.length - 2);
                String result =
                    note1.time.substring(0, note1.time.indexOf(' '));
                if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
                  hour = int.parse(result.split(':')[0]);
                  if (hour == 12) hour = 0;
                  minute = int.parse(result.split(":")[1]);
                } else {
                  hour = int.parse(result.split(':')[0]) - 12;
                  if (hour <= 0) {
                    hour = 24 + hour;
                  }
                  minute = int.parse(result.split(":")[1]);
                }
                DateTime he = h.add(Duration(hours: hour, minutes: minute));
                if (notifChoice == true) {
                  NotificationService().displayScheduleNotif(
                      body: note1.data,
                      channel: channelCounter,
                      title: note1.title,
                      date: he);
                }

                lastNote.delete();
                // items1.remove(lastNote);
                int b =
                    searchResults.indexWhere((val) => val.id == lastNote.id);
                if (b != -1) {
                  searchResults.removeAt(b);
                }
                int c = uncompleted.indexWhere((val) => val.id == lastNote.id);
                if (c != -1) {
                  uncompleted.removeAt(c);
                }
                items.remove(lastNote.id);
                int d =
                    items1.indexWhere((element) => element.id == lastNote.id);
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

                items1.add(note);

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

              items1.add(note);

              lastNote = note;
            }
            bool biff = done.contains(h);
            if (biff == false) {
              done.add(h);
            }
          }
        }
        if (ider.option == "Yearly") {
          var selectDate2 = note1.date;
          Notes lastNote = note1;

          for (var i = 1; i <= 10; i++) {
            DateTime g = DateTime.parse(selectDate2);
            DateTime h = DateTime(g.year + 1, g.month, g.day);
            selectDate2 = format2.format(h);
            if (g.isBefore(DateTime.now())) {
              if (g.day != DateTime.now().day) {
                String ter = notifs[lastNote.id]!.id2;

                NotificationService().deleteNotif(ter);
                int hour = 0;
                int minute = 0;
                String ampm = note1.time.substring(note1.time.length - 2);
                String result =
                    note1.time.substring(0, note1.time.indexOf(' '));
                if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
                  hour = int.parse(result.split(':')[0]);
                  if (hour == 12) hour = 0;
                  minute = int.parse(result.split(":")[1]);
                } else {
                  hour = int.parse(result.split(':')[0]) - 12;
                  if (hour <= 0) {
                    hour = 24 + hour;
                  }
                  minute = int.parse(result.split(":")[1]);
                }
                DateTime he = h.add(Duration(hours: hour, minutes: minute));
                if (notifChoice == true) {
                  NotificationService().displayScheduleNotif(
                      body: note1.data,
                      channel: channelCounter,
                      title: note1.title,
                      date: he);
                }

                lastNote.delete();
                // items1.remove(lastNote);
                int b =
                    searchResults.indexWhere((val) => val.id == lastNote.id);
                if (b != -1) {
                  searchResults.removeAt(b);
                }
                int c = uncompleted.indexWhere((val) => val.id == lastNote.id);
                if (c != -1) {
                  uncompleted.removeAt(c);
                }
                items.remove(lastNote.id);
                int d =
                    items1.indexWhere((element) => element.id == lastNote.id);
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

                items1.add(note);

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

              items1.add(note);

              lastNote = note;
            }
          }
        }
      }
    });

    // initNumber = items.keys.length;
    done.sort(((a, b) => a.compareTo(b)));
    for (var value in done) {
      List<Notes> list = [];

      for (var ite in items1) {
        final parsDate = DateTime.parse(ite.date);
        if (parsDate == value && ite.done == false) {
          list.add(ite);
        }
      }

      list.sort(((a, b) => timeConvert(a.time).compareTo(timeConvert(b.time))));
      if (events1.containsKey(value)) {
        events1.update(value, (value) => list);
      } else {
        events1.putIfAbsent(value, () => list);
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Today',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: constraints.maxWidth * .01),
                  child: TabBar(
                      indicatorPadding: const EdgeInsets.only(right: 10),
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      isScrollable: true,
                      labelColor: Theme.of(context).primaryColor,
                      labelPadding: const EdgeInsets.only(left: 0, right: 20),
                      unselectedLabelColor: Colors.grey[600],
                      controller: _tabController,
                      labelStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(
                          text: 'ToDo',
                        ),
                        Tab(text: 'Completed'),
                      ]),
                ),
                Expanded(
                  child: SizedBox(
                      width: double.maxFinite,
                      height: constraints.maxHeight * .77,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          notesCard(),
                          CompletedNotes(key: UniqueKey()),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ));
  }

  // @override
  // void dispose() {
  //   if (_subscription != null) _subscription?.cancel();
  //   super.dispose();
  // }

  String texter({required store.Notes item2}) {
    if (item2.data.isNotEmpty) {
      return '${item2.time}   ${item2.data}';
    } else {
      return item2.time;
    }
  }

  Future<bool?> _showDialog(store.Notes item2) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (dialogContex) {
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
                res = false;
              },
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    int b =
                        searchResults.indexWhere((val) => val.id == item2.id);
                    if (b != -1) {
                      searchResults.removeAt(b);
                    }
                    int c = uncompleted.indexWhere((val) => val.id == item2.id);
                    if (c != -1) {
                      uncompleted.removeAt(c);
                    }
                    items.remove(item2.id);
                    int d =
                        items1.indexWhere((element) => element.id == item2.id);
                    if (d != -1) {
                      items1.removeAt(d);
                    }

                    notes.removeWhere((element) => element == item2.id);
                    done.remove(DateTime.parse(item2.date));
                    int e = completed
                        .indexWhere((element) => element.id == item2.id);
                    if (e != -1) {
                      completed.removeAt(e);
                    }

                    item2.delete();
                    notes.remove(item2.id);
                    String not = notifs[item2.id]!.id2;
                    NotificationService().deleteNotif(not);
                    if (!mounted) return;
                    Navigator.pop(context);

                    res = true;
                  });
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ))
          ],
        );
      },
    );
  }
}
