import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:reminder_app/main.dart';
import 'all_notes.dart';
import 'package:reminder_app/controllers/notifications.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/notif_data_store.dart';
import 'package:reminder_app/screens/repeat_note.dart';
import 'all_notes.dart' as allNotes;
import 'completed_notes.dart' as comp;
import 'package:reminder_app/screens/table_calendar.dart' as table;
import 'package:reminder_app/models/repeat_store.dart';

enum Select { oneTime, daily, weekly, monthly, yearly }

Color col1 = const Color.fromARGB(255, 171, 222, 230);
Color col2 = const Color.fromARGB(255, 203, 170, 203);
Color col3 = const Color.fromARGB(255, 245, 214, 196);
Color col4 = const Color.fromARGB(255, 222, 237, 213);
Color col5 = const Color.fromARGB(255, 238, 206, 206);
Color col6 = const Color.fromARGB(255, 197, 210, 114);
Color col7 = const Color.fromARGB(255, 245, 154, 142);
Color col8 = const Color.fromARGB(255, 116, 154, 214);

enum ColorList { col1, col2, col3, col4, white, col5, col6, col7, col8 }

//enum Priorities { low, medium, high}
class EditNote extends StatefulWidget {
  const EditNote({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final _db = Localstore.instance;

  final _notifs = <String, Notifs>{};
  late DateTime scheduler = DateTime.now();
  late DateTime scheduler2 = DateTime.now();
  StreamSubscription<Map<String, dynamic>>? _subscription;

  DateFormat format = DateFormat("yyyy-MM-dd");

  final dCont = TextEditingController();
  final cCont = TextEditingController();
  final eCont = TextEditingController();
  Color colPick = const Color.fromARGB(255, 255, 254, 254);
  final formatter = DateFormat().add_jm();
  String selectDate = "";
  String title = "";
  String body = "";
  String daySelect = "";
  String repeat = "One-Time";
  Color selectColor = const Color.fromARGB(255, 180, 175, 174);
  String priority = "high";
  @override
  void initState() {
    super.initState();

    _db
        .collection("notifs")
        .doc(widget.id)
        .get()
        .then((value) => _db.collection('notifs').stream.listen((event) {
              // setState(() {
              final item = Notifs.fromMap(event);
              _notifs.putIfAbsent(item.id, () => item);
              // });
            }));
  }

  Widget eventTitle() {
    return TextFormField(
      maxLines: 2,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(decoration: TextDecoration.none),
      initialValue: title,
      decoration: const InputDecoration(
        hintText: 'Add Title',
        border: InputBorder.none,
      ),
      onChanged: (value) => title = value,
      autofocus: true,
    );
  }

  Widget eventBody() {
    return TextFormField(
      maxLines: 3,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(decoration: TextDecoration.none),
      initialValue: body,
      decoration: const InputDecoration(
        hintText: 'Add Reminder',
        border: InputBorder.none,
      ),
      onChanged: (value) => body = value,
      autofocus: false,
    );
  }

  Widget eventDate() {
    DateTime date = DateTime.now();
    return TextFormField(
      controller: dCont..text = selectDate,
      readOnly: true,
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: IconButton(
              onPressed: () async {
                final DateTime? dateT = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(selectDate),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2025));
                String compForm = format.format(dateT!);
                selectDate = compForm;
                setState(() {
                  scheduler = dateT;
                });

                dCont.text = compForm;
              },
              icon: Icon(
                FontAwesomeIcons.calendar,
                color: Colors.grey[500],
              ))),
    );
    // return ListTile(
    //   leading: const Icon(FontAwesomeIcons.calendar),
    //   title: Text(dCont.text),
    //   onTap: () async {
    //     final DateTime? dateT = await showDatePicker(
    //         context: context,
    //         initialDate: DateTime.parse(selectDate),
    //         firstDate: DateTime(2022),
    //         lastDate: DateTime(2025));
    //     String compForm = format.format(dateT!);
    //     selectDate = compForm;
    //     setState(() {
    //       scheduler = dateT;
    //     });

    //     dCont.text = compForm;
    //   },
    // );
  }

  Widget eventTime() {
    return TextFormField(
      controller: cCont..text = daySelect,
      readOnly: true,
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: IconButton(
              onPressed: () async {
                TimeOfDay? timeT = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                if (!mounted) return;
                String timeString = timeT!.format(context);
                daySelect = timeString;
                cCont.text = timeString;
                scheduler2 = DateTime(scheduler.year, scheduler.month,
                    scheduler.day, timeT.hour, timeT.minute);
              },
              icon: Icon(
                FontAwesomeIcons.clock,
                color: Colors.grey[500],
              ))),
    );
    // return ListTile(
    //   leading: const Icon(FontAwesomeIcons.clock),
    //   title: Text(cCont.text),
    //   onTap: () async {
    //     TimeOfDay? timeT = await showTimePicker(
    //         context: context, initialTime: TimeOfDay.now());
    //     if (!mounted) return;
    //     String timeString = timeT!.format(context);
    //     daySelect = timeString;
    //     cCont.text = timeString;
    //     scheduler2 = DateTime(scheduler.year, scheduler.month, scheduler.day,
    //         timeT.hour, timeT.minute);
    //   },
    // );
  }

  Widget eventRepeat() {
    return PopupMenuButton<Select>(
        icon: Text(repeat),
        onSelected: (value) {
          if (value == Select.daily) {
            repeat = "Daily";
          } else if (value == Select.monthly) {
            repeat = "Monthly";
          } else if (value == Select.weekly) {
            repeat = "Weekly";
          } else if (value == Select.yearly) {
            repeat = "Yearly";
          } else if (value == Select.oneTime) {
            repeat = "One-Time";
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Select>>[
              const PopupMenuItem<Select>(
                  value: Select.oneTime, child: Text("One-Time")),
              const PopupMenuItem<Select>(
                  value: Select.daily, child: Text("Daily")),
              const PopupMenuItem<Select>(
                  value: Select.weekly, child: Text("Weekly")),
              const PopupMenuItem<Select>(
                  value: Select.monthly, child: Text("Monthly")),
              const PopupMenuItem<Select>(
                  value: Select.yearly, child: Text("Yearly")),
            ]);
  }

  Widget eventColor1() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: col1),
              onPressed: () {
                setState(() {
                  selectColor = const Color.fromARGB(255, 171, 222, 230);
                });
                colPick = const Color.fromARGB(255, 171, 222, 230);
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: col1,
                ),
              )),
        ),
        Expanded(
          //2
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: col2),
              onPressed: () {
                setState(() {
                  selectColor = const Color.fromARGB(255, 203, 170, 203);
                });
                colPick = const Color.fromARGB(255, 203, 170, 203);
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: col2,
                ),
              )),
        ),
        Expanded(
          //3
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: col3),
              onPressed: () {
                setState(() {
                  selectColor = const Color.fromARGB(255, 245, 214, 196);
                });
                colPick = const Color.fromARGB(255, 245, 214, 196);
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: col3,
                ),
              )),
        ),
        Expanded(
          //4
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: col4),
              onPressed: () {
                setState(() {
                  selectColor = const Color.fromARGB(255, 222, 237, 213);
                });
                colPick = const Color.fromARGB(255, 222, 237, 213);
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: col4,
                ),
              )),
        ),
        Expanded(
          //5
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: col5),
              onPressed: () {
                setState(() {
                  selectColor = const Color.fromARGB(255, 238, 206, 206);
                });
                colPick = const Color.fromARGB(255, 238, 206, 206);
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: col5,
                ),
              )),
        ),
        Expanded(
          //6
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: col6),
              onPressed: () {
                setState(() {
                  selectColor = const Color.fromARGB(255, 197, 210, 114);
                });
                colPick = const Color.fromARGB(255, 197, 210, 114);
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: col6,
                ),
              )),
        ),
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: col7),
              onPressed: () {
                setState(() {
                  selectColor = const Color.fromARGB(255, 245, 154, 142);
                });
                colPick = const Color.fromARGB(255, 245, 154, 142);
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: col7,
                ),
              )),
        ),
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: col8),
              onPressed: () {
                setState(() {
                  selectColor = const Color.fromARGB(255, 116, 154, 214);
                });
                colPick = const Color.fromARGB(255, 116, 154, 214);
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: col8,
                ),
              )),
        ),
        Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), backgroundColor: Colors.white),
              onPressed: () {
                colPick = Colors.white;
                setState(() {
                  selectColor = const Color.fromARGB(255, 180, 175, 175);
                });
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              )),
        ),
      ],
    );
  }

  Widget eventColor() {
    return PopupMenuButton<ColorList>(
      icon: Material(
        // type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.5),
            color: selectColor,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            radius: 100.0,
          ),
        ),
      ),
      onSelected: (value) {
        if (value == ColorList.col1) {
          setState(() {
            selectColor = const Color.fromARGB(255, 171, 222, 230);
          });

          colPick = const Color.fromARGB(255, 171, 222, 230);
        } else if (value == ColorList.col2) {
          setState(() {
            selectColor = const Color.fromARGB(255, 203, 170, 203);
          });
          colPick = const Color.fromARGB(255, 203, 170, 203);
        } else if (value == ColorList.col3) {
          colPick = const Color.fromARGB(255, 245, 214, 196);
          setState(() {
            selectColor = const Color.fromARGB(255, 245, 214, 196);
          });
        } else if (value == ColorList.col4) {
          colPick = const Color.fromARGB(255, 222, 237, 213);
          setState(() {
            selectColor = const Color.fromARGB(255, 222, 237, 213);
          });
        } else if (value == ColorList.white) {
          colPick = Colors.white;
          setState(() {
            selectColor = const Color.fromARGB(255, 180, 175, 175);
          });
        } else if (value == ColorList.col5) {
          colPick = const Color.fromARGB(255, 238, 206, 206);
          setState(() {
            selectColor = const Color.fromARGB(255, 238, 206, 206);
          });
        } else if (value == ColorList.col6) {
          colPick = const Color.fromARGB(255, 197, 210, 114);

          setState(() {
            selectColor = const Color.fromARGB(255, 197, 210, 114);
          });
        } else if (value == ColorList.col7) {
          colPick = const Color.fromARGB(255, 245, 154, 142);
          setState(() {
            selectColor = const Color.fromARGB(255, 245, 154, 142);
          });
        } else if (value == ColorList.col8) {
          colPick = const Color.fromARGB(255, 116, 154, 214);
          setState(() {
            selectColor = const Color.fromARGB(255, 116, 154, 214);
          });
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ColorList>>[
        PopupMenuItem(
            child: Row(children: [
          PopupMenuItem<ColorList>(
            value: ColorList.col1,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 171, 222, 230),
                shape: BoxShape.circle,
              ),
            ),
          ),
          PopupMenuItem<ColorList>(
            value: ColorList.col2,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 203, 170, 203),
                shape: BoxShape.circle,
              ),
            ),
          ),
          PopupMenuItem<ColorList>(
            value: ColorList.col3,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 245, 214, 196),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ])),
        PopupMenuItem(
            child: Row(
          children: [
            PopupMenuItem<ColorList>(
              value: ColorList.col4,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 222, 237, 213),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            PopupMenuItem<ColorList>(
              value: ColorList.white,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(
                          width: 1, color: Color.fromARGB(255, 46, 46, 46)),
                      right: BorderSide(
                          width: 1, color: Color.fromARGB(255, 46, 46, 46)),
                      bottom: BorderSide(
                          width: 1, color: Color.fromARGB(255, 46, 46, 46)),
                      left: BorderSide(
                          width: 1, color: Color.fromARGB(255, 46, 46, 46))),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            PopupMenuItem<ColorList>(
              value: ColorList.col5,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 206, 206),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        )),
        PopupMenuItem(
            child: Row(
          children: [
            PopupMenuItem<ColorList>(
              value: ColorList.col6,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 197, 210, 114),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            PopupMenuItem<ColorList>(
              value: ColorList.col7,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 154, 142),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            PopupMenuItem<ColorList>(
              value: ColorList.col8,
              child: Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 116, 154, 214),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ))
      ],
    );
  }

  Widget eventRepeat1() {
    return PopupMenuButton<Select>(
        icon: Text(eCont.text),
        onSelected: (value) {
          if (value == Select.daily) {
            setState(() {
              repeat = "Daily";
            });
          } else if (value == Select.monthly) {
            setState(() {
              repeat = "Monthly";
            });
          } else if (value == Select.weekly) {
            setState(() {
              repeat = "Weekly";
            });
          } else if (value == Select.yearly) {
            setState(() {
              repeat = "Yearly";
            });
          } else if (value == Select.oneTime) {
            setState(() {
              repeat = "One-Time";
            });
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Select>>[
              const PopupMenuItem<Select>(
                  value: Select.oneTime, child: Text("One-Time")),
              const PopupMenuItem<Select>(
                  value: Select.daily, child: Text("Daily")),
              const PopupMenuItem<Select>(
                  value: Select.weekly, child: Text("Weekly")),
              const PopupMenuItem<Select>(
                  value: Select.monthly, child: Text("Monthly")),
              const PopupMenuItem<Select>(
                  value: Select.yearly, child: Text("Yearly")),
            ]);
  }

  @override
  Widget build(BuildContext context) {
    store.Notes item;
    if (items[widget.id] != null) {
      item = items[widget.id]!;
    } else {
      item = table.items1.firstWhere((element) => element.id == widget.id,
          orElse: (() => item = store.Notes(
              id: "",
              title: title,
              data: "",
              date: "",
              time: "",
              priority: priority,
              color: "",
              done: false)));
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
    var obj = allNotes.items3[item.id];
    if (repeat == "One-Time") {
      if (obj != null) {
        repeat = obj.option;
      }
    }
    eCont.text = repeat;

    //DateTime? dateT = DateTime.now();
    dCont.text = selectDate;

    cCont.text = daySelect;
    //TimeOfDay timer = TimeOfDay.fromDateTime(formatter.parse(daySelect));
    if (colPick == const Color.fromARGB(255, 255, 254, 254)) {
      colPick = Color(int.parse(item.color));
    }
    if (selectColor == const Color.fromARGB(255, 180, 175, 174)) {
      selectColor = Color(int.parse(item.color));
    }
    return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: EdgeInsets.all(constraints.maxWidth * .04),
                  child: Form(
                      child: Column(
                    children: [
                      eventTitle(),
                      eventBody(),
                      Row(children: [
                        Expanded(child: eventDate()),
                        Expanded(child: eventTime()),
                        Expanded(child: eventRepeat())
                      ]),
                      eventColor1(),
                      SizedBox(
                        height: constraints.maxHeight * .04,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.blue[700],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: IconButton(
                          onPressed: () {
                            if (_notifs[widget.id] != null) {
                              var ter = _notifs[widget.id];
                              if (ter != null) {
                                String tre = ter.id2;
                                NotificationService().deleteNotif(tre);
                              }
                            }
                            if (count.notifChoice == true) {
                              if (scheduler2.isAfter(DateTime.now())) {
                                NotificationService().displayScheduleNotif(
                                    body: body,
                                    channel: count.channelCounter,
                                    title: title,
                                    date: scheduler2);
                              } else {
                                NotificationService().displayNotification(
                                    body: body,
                                    channel: count.channelCounter,
                                    title: title);
                              }
                            }

                            if (obj != null) {
                              obj.delete();
                            }

                            bool bloop = item.done;
                            setState(() {
                              int a = comp.completed.indexWhere(
                                  (element) => element.id == item.id);
                              if (a != -1) {
                                comp.completed.removeAt(a);
                              }
                              int b = searchResults
                                  .indexWhere((val) => val.id == item.id);
                              if (b != -1) {
                                searchResults.removeAt(b);
                              }
                              int c = uncompleted
                                  .indexWhere((val) => val.id == item.id);
                              if (c != -1) {
                                uncompleted.removeAt(c);
                              }
                              allNotes.items.remove(item.id);
                              int d = table.items1.indexWhere(
                                  (element) => element.id == item.id);
                              if (d != -1) {
                                table.items1.removeAt(d);
                              }

                              notes
                                  .removeWhere((element) => element == item.id);
                            });
                            item.delete();
                            final id = Localstore.instance
                                .collection("notes")
                                .doc()
                                .id;
                            // print(item.id);
                            final item1 = store.Notes(
                                id: id,
                                title: title,
                                data: body,
                                date: selectDate,
                                time: daySelect,
                                priority: priority,
                                color: colPick.value.toString(),
                                done: bloop);
                            item1.save();

                            Notifs notif1 = Notifs(
                              id: id,
                              id2: count.channelCounter.toString(),
                            );
                            // String k;

                            // k = repeat;

                            print(repeat);
                            Repeat reeeeee = Repeat(id: id, option: repeat);
                            reeeeee.save();
                            allNotes.items3.putIfAbsent(id, () => reeeeee);
                            notif1.save();

                            searchResults.add(item1);
                            if (item.done == true) {
                              comp.completed.add(item1);
                            } else {
                              uncompleted.add(item1);
                            }
                            allNotes.items.putIfAbsent(id, () => item1);
                            table.items1.add(item1);

                            ee.value = !ee.value;
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.arrowUp,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ));
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    // Clean up the controller when the widget is removed
    cCont.dispose();
    dCont.dispose();
    eCont.dispose();
    super.dispose();
  }
}
