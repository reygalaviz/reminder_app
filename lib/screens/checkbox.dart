// ignore_for_file: unused_field
import 'package:reminder_app/controllers/notifications.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:flutter/material.dart';
import 'package:reminder_app/screens/completed_notes.dart';
import 'all_notes.dart' as all;
import '../models/note_data_store.dart';
import 'package:reminder_app/models/notif_data_store.dart';
import 'all_notes.dart' as all_notes;
import 'package:reminder_app/main.dart';
import 'package:localstore/localstore.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:reminder_app/Screens/home.dart';
import 'package:reminder_app/screens/table_calendar.dart';
import 'package:reminder_app/screens/table_calendar.dart' as table;
import 'package:reminder_app/models/repeat_store.dart';
import 'search_notes.dart';
import 'package:intl/intl.dart';

class CheckBoxNote extends StatefulWidget {
  const CheckBoxNote({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<CheckBoxNote> createState() => _CheckBoxNoteState();
}

class _CheckBoxNoteState extends State<CheckBoxNote> {
  final _db = Localstore.instance;
  // final _items = <String, store.Notes>{};
  // StreamSubscription<Map<String, dynamic>>? _subscription;
  // final _notifs = <String, Notifs>{};

  Color colPick = const Color.fromARGB(255, 255, 254, 254);
  String selectDate = "";
  String title = "";
  String body = "";
  String daySelect = "";
  Color selectColor = const Color.fromARGB(255, 180, 175, 174);
  String priority = "high";
  String id4 = "";
  DateFormat format = DateFormat("yyyy-MM-dd");
  bool? val = false;
  @override
  Widget build(BuildContext context) {
    // print(all.items);
    // print(count.searchResults);
    bool boop = false;

    var ovj = count.notes
        .firstWhere((element) => element == widget.id, orElse: (() => ""));
    if (ovj != "") {
      var obj = all.items[ovj];

      if (obj != null) {
        boop = obj.done;
      }
    }

    String ter = "";
    return Transform.scale(
        scale: 1.5,
        child: Checkbox(
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.green.withOpacity(.82);
              }

              return Colors.green;
            }),
            side: MaterialStateBorderSide.resolveWith(
                (states) => const BorderSide(width: .5, color: Colors.black)),
            checkColor: colPick,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            value: boop,
            onChanged: (val) {
              setState(() {
                if (id4 == "") {
                  id4 = widget.id;
                }
                store.Notes item = all.items[id4]!;
                if (colPick == const Color.fromARGB(255, 255, 254, 254)) {
                  colPick = Color(int.parse(item.color));
                }
                if (selectDate == "") {
                  selectDate = item.date;
                }
                if (title == "") {
                  title = item.title;
                }
                if (body == "") {
                  body = item.data;
                }
                if (daySelect == "") {
                  daySelect = item.time;
                }

                if (item.done == true) {
                  boop = false;

                  val = true;
                } else {
                  boop = true;
                  val = false;
                }
                // if (all_notes.notifs[item.id] != null) {
                //   ter = all_notes.notifs[item.id]!.id2;
                // }
                if (all.notifs[widget.id] != null) {
                  var tert = all.notifs[widget.id]!;
                  ter = tert.id2;
                  all_notes.notifs.remove(tert.id);
                  tert.delete();
                  NotificationService().deleteNotif(ter);
                }
                int a = suggestions.indexWhere((val) => val.id == item.id);
                if (a != -1) {
                  suggestions.removeAt(a);
                }

                int b = searchResults.indexWhere((val) => val.id == item.id);
                if (b != -1) {
                  searchResults.removeAt(b);
                }
                int c = uncompleted.indexWhere((val) => val.id == item.id);
                if (c != -1) {
                  uncompleted.removeAt(c);
                }
                all_notes.items.remove(item.id);
                int d =
                    table.items1.indexWhere((element) => element.id == item.id);
                if (d != -1) {
                  table.items1.removeAt(d);
                }
                int e =
                    completed.indexWhere((element) => element.id == item.id);
                if (e != -1) {
                  completed.removeAt(e);
                }

                item.delete();
                final id1 = store.db.collection('notes').doc().id;

                Notes note = Notes(
                    id: id1,
                    title: title,
                    data: body,
                    date: selectDate,
                    time: daySelect,
                    priority: priority,
                    color: colPick.value.toString(),
                    done: boop);

                items1.add(note);
                searchResults.add(note);

                note.save();

                if (boop == true) {
                  completed.add(note);
                  done.remove(DateTime.parse(item.date));
                } else {
                  uncompleted.add(note);
                  completed.removeWhere((element) => element.id == widget.id);
                  if (!done.contains(DateTime.parse(note.date))) {
                    done.add(DateTime.parse(note.date));
                  }
                }
                done.clear();
                all_notes.items.putIfAbsent(id1, () => note);
                notes.add(note.id);
                if (all.items3[item.id] != null) {
                  var repea = all.items3[item.id];
                  if (repea!.option == "Daily") {
                    Repeat r = Repeat(id: note.id, option: "Daily");
                    all.items3.putIfAbsent(note.id, () => r);
                    r.save();

                    // for (var i = 1; i <= 100; i++) {
                    //   DateTime g = DateTime.parse(selectDate);
                    //   DateTime h = DateTime(g.year, g.month, g.day + 1);
                    //   selectDate = format.format(h);
                    //   if (done.indexWhere((element) => element == g) == -1) {
                    //     done.add(g);
                    //   }
                    //   if (boop == false) {
                    //     Notes note = Notes(
                    //         id: id,
                    //         title: title,
                    //         data: body,
                    //         date: selectDate,
                    //         time: daySelect,
                    //         priority: priority,
                    //         color: colPick.value.toString(),
                    //         done: false);
                    //     setState(() {
                    //       items1.add(note);
                    //     });
                    //   }
                    // }
                  } else if (repea.option == "Weekly") {
                    Repeat r = Repeat(id: note.id, option: "Weekly");
                    all.items3.putIfAbsent(note.id, () => r);
                    r.save();
                    // for (var i = 1; i <= 50; i++) {
                    //   DateTime g = DateTime.parse(selectDate);
                    //   DateTime h = DateTime(g.year, g.month, g.day + 7);
                    //   selectDate = format.format(h);
                    //   if (done.indexWhere((element) => element == g) == -1) {
                    //     done.add(g);
                    //   }
                    //   if (boop == false) {
                    //     Notes note = Notes(
                    //         id: id,
                    //         title: title,
                    //         data: body,
                    //         date: selectDate,
                    //         time: daySelect,
                    //         priority: priority,
                    //         color: colPick.value.toString(),
                    //         done: false);
                    //     setState(() {
                    //       items1.add(note);
                    //     });
                    //   }
                    // }
                  } else if (repea.option == "Monthly") {
                    Repeat r = Repeat(id: note.id, option: "Monthly");
                    all.items3.putIfAbsent(note.id, () => r);
                    r.save();
                    // for (var i = 1; i <= 24; i++) {
                    //   DateTime g = DateTime.parse(selectDate);
                    //   DateTime h = DateTime(g.year, g.month + 1, g.day);
                    //   selectDate = format.format(h);
                    //   if (done.indexWhere((element) => element == g) == -1) {
                    //     done.add(g);
                    //   }
                    //   if (boop == false) {
                    //     Notes note = Notes(
                    //         id: id,
                    //         title: title,
                    //         data: body,
                    //         date: selectDate,
                    //         time: daySelect,
                    //         priority: priority,
                    //         color: colPick.value.toString(),
                    //         done: false);
                    //     setState(() {
                    //       items1.add(note);
                    //     });
                    //   }
                    // }
                  } else if (repea.option == "Yearly") {
                    Repeat r = Repeat(id: note.id, option: "Yearly");
                    all.items3.putIfAbsent(note.id, () => r);
                    r.save();

                    // for (var i = 1; i <= 5; i++) {
                    //   DateTime g = DateTime.parse(selectDate);
                    //   DateTime h = DateTime(g.year + 1, g.month, g.day);
                    //   selectDate = format.format(h);
                    //   if (done.indexWhere((element) => element == g) == -1) {
                    //     done.add(g);
                    //   }
                    //   if (boop == false) {
                    //     Notes note = Notes(
                    //         id: id,
                    //         title: title,
                    //         data: body,
                    //         date: selectDate,
                    //         time: daySelect,
                    //         priority: priority,
                    //         color: colPick.value.toString(),
                    //         done: false);
                    //     setState(() {
                    //       items1.add(note);
                    //     });
                    //   }
                    // }
                  }
                }

                Notifs notif1 = Notifs(
                  id: id1,
                  id2: count.channelCounter.toString(),
                );
                notif1.save();
                all.ee.value = !all.ee.value;
                res.value = !res.value;

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Home()),
                // );
              });
            }));
  }
}
