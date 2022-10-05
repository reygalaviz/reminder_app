import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'package:reminder_app/screens/edit_notes.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:reminder_app/controllers/notifications.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/notif_data_store.dart';
import 'package:reminder_app/screens/repeat_note.dart';
import 'all_notes.dart' as allNotes;
import 'completed_notes.dart' as comp;
import 'package:reminder_app/models/repeat_store.dart';
import 'package:reminder_app/main.dart';
import 'package:reminder_app/screens/table_calendar.dart' as table;

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
  final _items = <String, store.Notes>{};
  final _notifs = <String, Notifs>{};
  late DateTime scheduler = DateTime.now();
  late DateTime scheduler2 = DateTime.now();
  StreamSubscription<Map<String, dynamic>>? _subscription;
  // var item;
  DateFormat format = DateFormat("yyyy-MM-dd");
  final eCont = TextEditingController();
  final dCont = TextEditingController();
  final cCont = TextEditingController();
  Color colPick = const Color.fromARGB(255, 255, 254, 254);
  final formatter = DateFormat().add_jm();
  String selectDate = "";
  String title = "";
  String body = "";
  String daySelect = "";
  Color selectColor = const Color.fromARGB(255, 180, 175, 174);
  String priority = "high";
  String be = "beak";
  String repeat = "Once";
  @override
  void initState() {
    super.initState();
    _db.collection('notes').get().then((value) {
      _subscription = _db.collection('notes').stream.listen((event) {
        setState(() {
          final item = store.Notes.fromMap(event);
          _items.putIfAbsent(item.id, () => item);
        });
      });
    });
    _db
        .collection("notifs")
        .doc(widget.id)
        .get()
        .then((value) => _db.collection('notifs').stream.listen((event) {
              // setState(() {
              final item = Notifs.fromMap(event);
              _notifs.putIfAbsent(item.id, () => item);
              //});
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
    return TextFormField(
      controller: dCont..text = selectDate,
      readOnly: true,
      decoration: InputDecoration(
          isDense: true,
          contentPadding:
              EdgeInsets.only(left: -8.0, bottom: 8.0, top: 14.0, right: -8.0),
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
                color: Colors.blue[700],
                size: 20,
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
          contentPadding:
              EdgeInsets.only(left: -8.0, bottom: 8.0, top: 14.0, right: -8.0),
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
                color: Colors.blue[700],
                size: 20,
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

  Widget eventRepeat() {

    return TextFormField(
        controller: eCont,
        readOnly: true,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(
                left: -8.0, bottom: 8.0, top: 14.0, right: -8.0),
            border: InputBorder.none,
            prefixIcon: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: Text('Select an Option'),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () {
                                repeat = "Once";
                                Select.oneTime;
                                eCont.text = repeat;
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Once',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                repeat = "Daily";
                                Select.daily;
                                eCont.text = repeat;
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Daily',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                repeat = "Weekly";
                                Select.weekly;
                                eCont.text = repeat;
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Weekly',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                repeat = "Monthly";
                                Select.monthly;
                                eCont.text = repeat;
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Monthly',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                repeat = "Yearly";
                                Select.yearly;
                                eCont.text = repeat;
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Yearly',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(
                  FontAwesomeIcons.repeat,
                  color: Colors.blue[700],
                ))));

  }

  @override
  Widget build(BuildContext context) {
    if (_items[widget.id] != null) {
      var item = _items[widget.id]!;
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

                              var obj = allNotes.items3[item.id];

                              if (repeat == "One-Time") {
                                if (obj != null) {
                                  repeat = obj.option;
                                }
                              }

                              if (obj != null) {
                                obj.delete();
                              }
                              bool bloop = item.done;
                              setState(() {
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

                                notes.removeWhere(
                                    (element) => element == item.id);
                                _items.remove(item.id);
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

                              if (obj != null) {
                                if (obj.option == "Daily") {
                                  Repeat reeeeee =
                                      Repeat(id: id, option: "Daily");
                                  reeeeee.save();
                                }

                              if (repeat != "One-Time") {
                                Repeat reeeeee = Repeat(id: id, option: repeat);
                                reeeeee.save();

                              }
                              notif1.save();
                              setState(() {
                                searchResults.add(item1);

                                if (item.done == true) {
                                  comp.completed.add(item1);
                                } else {
                                  uncompleted.add(item1);
                                }
                                allNotes.items.putIfAbsent(id, () => item1);
                                table.items1.add(item1);

                                _items.putIfAbsent(item1.id, () => item1);
                              });
                              // table.items1.clear();
                              // if (scheduler.day != DateTime.now().day ||
                              //     scheduler.month != DateTime.now().month) {
                              //   if (table.done.indexWhere(
                              //           (element) => (element == scheduler)) ==
                              //       -1) {
                              //     table.done.add(scheduler);
                              //   }
                              // }

                              // Navigator.pop(context);

                              allNotes.ee.value = !allNotes.ee.value;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home2(
                                            key: UniqueKey(),
                                            boo: true,
                                          )));
                              // Navigator.pop(context);

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
    } else {
      return Container();
    }

  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    // Clean up the controller when the widget is removed
    dCont.dispose();
    super.dispose();
  }
}
