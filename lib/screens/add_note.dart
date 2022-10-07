import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/controllers/notifications.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/notes_operation.dart';
import 'package:reminder_app/models/notif_data_store.dart';
import 'package:reminder_app/models/repeat_store.dart';
import 'package:reminder_app/screens/all_notes.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:reminder_app/screens/table_calendar.dart';
import 'package:reminder_app/models/note_data_store.dart';

Color col1 = const Color.fromARGB(255, 171, 222, 230);
Color col2 = const Color.fromARGB(255, 203, 170, 203);
Color col3 = const Color.fromARGB(255, 245, 214, 196);
Color col4 = const Color.fromARGB(255, 222, 237, 213);
Color col5 = const Color.fromARGB(255, 238, 206, 206);
Color col6 = const Color.fromARGB(255, 197, 210, 114);
Color col7 = const Color.fromARGB(255, 245, 154, 142);
Color col8 = const Color.fromARGB(255, 116, 154, 214);

enum ColorList { col1, col2, col3, col4, white, col5, col6, col7, col8 }

enum Select { oneTime, daily, weekly, monthly, yearly }

Color selectColor = const Color.fromARGB(255, 180, 175, 175);

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  DateFormat format = DateFormat("yyyy-MM-dd");
  final rCont = TextEditingController();
  final dCont = TextEditingController();
  final cCont = TextEditingController();
  Color colPick = Colors.white;
  String repeat = "One-Time";
  String title = '';
  String body = '';
  String selectDate = "";
  String daySelect = "";
  DateFormat formatter = DateFormat.MMMEd();
  late DateTime scheduler = DateTime.now();
  late DateTime scheduler2 = DateTime.now();
  final id = Localstore.instance.collection("notes").doc().id;
  String priority = 'high';
  Widget eventColorTest() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              selectColor = Colors.blue;
            });

            colPick = Colors.blue;
          },
          icon: Material(
            // type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                color: const Color.fromARGB(255, 171, 222, 230),
                shape: BoxShape.circle,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                radius: 100.0,
              ),
            ),
          ),
        )
      ],
    );
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

  Widget eventDate() {
    return TextFormField(
      // enableInteractiveSelection: false,
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
                    builder: ((context, child) {
                      return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.blueAccent,
                              onSurface: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: child!);
                    }),
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2029, 12, 12));
                String compForm = format.format(dateT!);
                setState(() {
                  scheduler = dateT;
                });

                selectDate = compForm;

                dCont.text = compForm;
              },
              icon: Icon(
                FontAwesomeIcons.calendar,
                color: Colors.blue[700],
                size: 20,
              ))),
    );
    // return GestureDetector(
    //     onTap: () async {
    //       final DateTime? dateT = await showDatePicker(
    //           context: context,
    //           initialDate: DateTime.now(),
    //           firstDate: DateTime.now(),
    //           lastDate: DateTime(2029, 12, 12));
    //       String compForm = format.format(dateT!);
    //       setState(() {
    //         scheduler = dateT;
    //       });

    //       selectDate = compForm;

    //       dCont.text = compForm;
    //     },
    //     child: FormBuilderDateTimePicker(
    //       name: 'date',
    //       format: DateFormat("yyyy-MM-dd"),
    //       initialValue: DateTime.now(),
    //       inputType: InputType.date,
    //       onChanged: ((value) {
    //         print(value);
    //         if (value != null) {
    //           setState(() {
    //             scheduler = value;
    //           });
    //           String compForm = format.format(value);
    //           selectDate = compForm;
    //           dCont.text = DateFormat.MMMMEEEEd().format(value);
    //         }
    //       }),
    //     ));
    // return Container(
    //   color: Colors.amber,
    //   child: TextFormField(
    //     readOnly: true,
    //     autocorrect: false,
    //     enableSuggestions: false,
    //     controller: dCont,
    //     decoration: InputDecoration(
    //       border: InputBorder.none,
    //       contentPadding: const EdgeInsets.only(left: 0),
    //       prefixIconConstraints: const BoxConstraints(minWidth: 0),
    //       prefixIcon: Icon(FontAwesomeIcons.calendar),

    // prefixIcon: IconButton(
    //     onPressed: () async {
    //       final DateTime? dateT = await showDatePicker(
    //           context: context,
    //           initialDate: DateTime.now(),
    //           firstDate: DateTime.now(),
    //           lastDate: DateTime(2029, 12, 12));
    //       String compForm = format.format(dateT!);
    //       setState(() {
    //         scheduler = dateT;
    //       });

    //       selectDate = compForm;

    //       dCont.text = DateFormat.MMMEd().format(dateT);
    //     },
    //     icon: const Icon(
    //       FontAwesomeIcons.calendar,
    //       size: 20,
    //     )),
    //     ),
    //   ),
    // );
  }

  Widget eventTime() {
    return TextFormField(
        autofocus: false,
        readOnly: true,
        maxLines: 1,
        autocorrect: false,
        enableSuggestions: false,
        controller: cCont..text = daySelect,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.only(left: -8.0, bottom: 8.0, top: 14.0, right: -8.0),
          border: InputBorder.none,
          prefixIcon: IconButton(
            onPressed: () async {
              TimeOfDay? timeT = await showTimePicker(
                  builder: ((context, child) {
                    return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.blueAccent,
                            surface: Theme.of(context).backgroundColor,
                            onSurface: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: child!);
                  }),
                  context: context,
                  initialTime: TimeOfDay.now());
              if (!mounted) return;
              String timeString = timeT!.format(context);
              daySelect = timeString;
              cCont.text = timeString;
              scheduler2 = DateTime(scheduler.year, scheduler.month,
                  scheduler.day, timeT.hour, timeT.minute);
              // TimeOfDay? timeT = TimeOfDay.fromDateTime(DateTime.now());
              // showCupertinoModalPopup(
              //     context: context,
              //     builder: (BuildContext builder) {
              //       return Container(
              //           width: 200,
              //           height: 500,
              //           padding: const EdgeInsets.only(
              //               top: 20.0, left: 10.0, right: 10.0, bottom: 60.0),
              //           child: Column(
              //             children: [
              //               SizedBox(
              //                   height: 300,
              //                   width: 200,
              //                   child: CupertinoDatePicker(
              //                     mode: CupertinoDatePickerMode.time,
              //                     initialDateTime: DateTime.now(),
              //                     backgroundColor: Colors.white,
              //                     onDateTimeChanged: (value) {
              //                       timeT = TimeOfDay.fromDateTime(value);
              //                       if (!mounted) return;
              //                       if (timeT != null) {
              //                         String timeString =
              //                             timeT!.format(context);
              //                         daySelect = timeString;
              //                         cCont.text = timeString;
              //                         scheduler2 = DateTime(
              //                             scheduler.year,
              //                             scheduler.month,
              //                             scheduler.day,
              //                             timeT!.hour,
              //                             timeT!.minute);
              //                       }
              //                     },
              //                   )),
              //               CupertinoButton(
              //                 child: const Text('Ok'),
              //                 onPressed: () => Navigator.of(context).pop(),
              //               )
              //             ],
              //           ));
              //     });
            },
            icon: Icon(
              FontAwesomeIcons.clock,
              size: 20,
              color: Colors.blue[700],
            ),
          ),
        ));
  }

  Widget eventSub() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue[700],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      width: double.infinity,
      child: IconButton(
          onPressed: () {
            count.channelCounter++;

            if (repeat == "One-Time") {
              Notifs notif = Notifs(
                id: id,
                id2: count.channelCounter.toString(),
              );
              notif.save();

              Provider.of<NotesOperation>(context, listen: false).addNewNote(
                  id,
                  title,
                  body,
                  selectDate,
                  daySelect,
                  priority,
                  colPick.value.toString());

              if (count.notifChoice == true) {
                if (scheduler2.isAfter(DateTime.now())) {
                  NotificationService().displayScheduleNotif(
                      body: body,
                      channel: count.channelCounter,
                      title: title,
                      date: scheduler2);
                } else {
                  NotificationService().displayNotification(
                      body: body, channel: count.channelCounter, title: title);
                }
              }
              // if (done.indexWhere((element) => (element == scheduler)) == -1) {
              //   done.add(scheduler);
              // }

              selectColor = const Color.fromARGB(255, 180, 175, 175);
              ee.value = !ee.value;
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(key: UniqueKey())));
            } else if (repeat == "Daily") {
              // String id2 = Localstore.instance.collection("notes").doc().id;
              Notifs notif = Notifs(
                id: id,
                id2: count.channelCounter.toString(),
              );
              notif.save();
              Repeat reeeeee = Repeat(id: id, option: "Daily");
              reeeeee.save();
              items3.putIfAbsent(id, () => reeeeee);

              // for (var i = 1; i <= 365; i++) {
              Provider.of<NotesOperation>(context, listen: false).addNewNote(
                id,
                title,
                body,
                selectDate,
                daySelect,
                priority,
                colPick.value.toString(),
              );
              calSelect = DateTime.now();
              if (scheduler2.isAfter(DateTime.now())) {
                // for (var i = 1; i <= 100; i++) {
                //   DateTime g = DateTime.parse(selectDate);
                //   DateTime h = DateTime(g.year, g.month, g.day + 1);
                //   selectDate = format.format(h);
                //   if (done.indexWhere((element) => element == g) == -1) {
                //     done.add(g);
                //   }
                //   Notes note = Notes(
                //       id: id,
                //       title: title,
                //       data: body,
                //       date: selectDate,
                //       time: daySelect,
                //       priority: priority,
                //       color: colPick.value.toString(),
                //       done: false);
                //   setState(() {
                //     items1.add(note);
                //   });
                // }
                if (count.notifChoice == true) {
                  NotificationService().displayScheduleNotif(
                      body: body,
                      channel: count.channelCounter,
                      title: title,
                      date: scheduler2);
                }
              }

              selectColor = const Color.fromARGB(255, 180, 175, 175);
              ee.value = !ee.value;
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(key: UniqueKey())));
            } else if (repeat == "Monthly") {
              // String id2 = Localstore.instance.collection("notes").doc().id;
              Notifs notif = Notifs(
                id: id,
                id2: count.channelCounter.toString(),
              );
              notif.save();
              Repeat reeeeee = Repeat(id: id, option: "Monthly");
              reeeeee.save();
              items3.putIfAbsent(reeeeee.id, () => reeeeee);
              // for (var i = 1; i <= 365; i++) {
              Provider.of<NotesOperation>(context, listen: false).addNewNote(
                id,
                title,
                body,
                selectDate,
                daySelect,
                priority,
                colPick.value.toString(),
              );
              // for (var i = 1; i <= 24; i++) {
              //   DateTime g = DateTime.parse(selectDate);
              //   DateTime h = DateTime(g.year, g.month + 1, g.day);
              //   selectDate = format.format(h);
              //   if (done.indexWhere((element) => element == g) == -1) {
              //     done.add(g);
              //   }
              //   Notes note = Notes(
              //       id: id,
              //       title: title,
              //       data: body,
              //       date: selectDate,
              //       time: daySelect,
              //       priority: priority,
              //       color: colPick.value.toString(),
              //       done: false);
              //   setState(() {
              //     items1.add(note);
              //   });
              // }
              if (count.notifChoice == true) {
                NotificationService().displayScheduleNotif(
                    body: body,
                    channel: count.channelCounter,
                    title: title,
                    date: scheduler2);
              }

              selectColor = const Color.fromARGB(255, 180, 175, 175);
              ee.value = !ee.value;
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(key: UniqueKey())));
            } else if (repeat == "Weekly") {
              // String id2 = Localstore.instance.collection("notes").doc().id;
              Notifs notif = Notifs(
                id: id,
                id2: count.channelCounter.toString(),
              );
              notif.save();
              Repeat reeeeee = Repeat(id: id, option: "Weekly");
              reeeeee.save();
              items3.putIfAbsent(reeeeee.id, () => reeeeee);

              // for (var i = 1; i <= 365; i++) {
              Provider.of<NotesOperation>(context, listen: false).addNewNote(
                id,
                title,
                body,
                selectDate,
                daySelect,
                priority,
                colPick.value.toString(),
              );
              // for (var i = 1; i <= 50; i++) {
              //   DateTime g = DateTime.parse(selectDate);
              //   DateTime h = DateTime(g.year, g.month, g.day + 7);
              //   selectDate = format.format(h);
              //   if (done.indexWhere((element) => element == g) == -1) {
              //     done.add(g);
              //   }
              //   Notes note = Notes(
              //       id: id,
              //       title: title,
              //       data: body,
              //       date: selectDate,
              //       time: daySelect,
              //       priority: priority,
              //       color: colPick.value.toString(),
              //       done: false);
              //   setState(() {
              //     items1.add(note);
              //   });
              // }
              if (count.notifChoice == true) {
                NotificationService().displayScheduleNotif(
                    body: body,
                    channel: count.channelCounter,
                    title: title,
                    date: scheduler2);
              }

              selectColor = const Color.fromARGB(255, 180, 175, 175);
              ee.value = !ee.value;
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(key: UniqueKey())));
            } else if (repeat == "Yearly") {
              // String id2 = Localstore.instance.collection("notes").doc().id;
              Notifs notif = Notifs(
                id: id,
                id2: count.channelCounter.toString(),
              );
              notif.save();
              Repeat reeeeee = Repeat(id: id, option: "Yearly");
              reeeeee.save();
              items3.putIfAbsent(id, () => reeeeee);
              // for (var i = 1; i <= 365; i++) {
              Provider.of<NotesOperation>(context, listen: false).addNewNote(
                id,
                title,
                body,
                selectDate,
                daySelect,
                priority,
                colPick.value.toString(),
              );
              // for (var i = 1; i <= 5; i++) {
              //   DateTime g = DateTime.parse(selectDate);
              //   DateTime h = DateTime(g.year + 1, g.month, g.day);
              //   selectDate = format.format(h);
              //   if (done.indexWhere((element) => element == g) == -1) {
              //     done.add(g);
              //   }
              //   Notes note = Notes(
              //       id: id,
              //       title: title,
              //       data: body,
              //       date: selectDate,
              //       time: daySelect,
              //       priority: priority,
              //       color: colPick.value.toString(),
              //       done: false);
              //   setState(() {
              //     items1.add(note);
              //   });
              // }
              if (count.notifChoice == true) {
                NotificationService().displayScheduleNotif(
                    body: body,
                    channel: count.channelCounter,
                    title: title,
                    date: scheduler2);
              }

              selectColor = const Color.fromARGB(255, 180, 175, 175);
              ee.value = ee.value;
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(key: UniqueKey())));
            }
          },
          icon: const Icon(
            FontAwesomeIcons.arrowUp,
            color: Colors.white,
            size: 20,
          )),
    );
  }

  Widget eventRepeat() {
    return TextFormField(
        controller: rCont..text = 'One-Time',
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
                                repeat = "One-Time";
                                Select.oneTime;
                                rCont.text = repeat;
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'One-Time',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                repeat = "Daily";
                                Select.daily;
                                rCont.text = repeat;
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
                                rCont.text = repeat;
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
                                rCont.text = repeat;
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
                                rCont.text = repeat;
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

    // return PopupMenuButton<Select>(
    //     icon: Text(repeat),
    //     onSelected: (value) {
    //       if (value == Select.daily) {
    //         repeat = "Daily";
    //       } else if (value == Select.monthly) {
    //         repeat = "Monthly";
    //       } else if (value == Select.weekly) {
    //         repeat = "Weekly";
    //       } else if (value == Select.yearly) {
    //         repeat = "Yearly";
    //       } else if (value == Select.oneTime) {
    //         repeat = "One-Time";
    //       }
    //     },
    //     itemBuilder: (BuildContext context) => <PopupMenuEntry<Select>>[
    //           const PopupMenuItem<Select>(
    //               value: Select.oneTime, child: Text("One-Time")),
    //           const PopupMenuItem<Select>(
    //               value: Select.daily, child: Text("Daily")),
    //           const PopupMenuItem<Select>(
    //               value: Select.weekly, child: Text("Weekly")),
    //           const PopupMenuItem<Select>(
    //               value: Select.monthly, child: Text("Monthly")),
    //           const PopupMenuItem<Select>(
    //               value: Select.yearly, child: Text("Yearly")),
    //         ]);
  }

  @override
  void dispose() {
    cCont.dispose();
    dCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectDate == "") {
      selectDate = format.format(calSelect).toString();
    }
    if (daySelect == "") {
      daySelect = TimeOfDay.now().format(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: EdgeInsets.all(constraints.maxWidth * .04),
            child: Form(
              child: Column(children: [
                TextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  maxLines: 2,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: const TextStyle(decoration: TextDecoration.none),
                  decoration: const InputDecoration(
                    hintText: 'Add Title',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => title = value,
                  autofocus: true,
                ),
                TextFormField(
                  cursorColor: Theme.of(context).primaryColor,
                  maxLines: 3,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: const TextStyle(decoration: TextDecoration.none),
                  decoration: const InputDecoration(
                    hintText: 'Add Reminder',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => body = value,
                  autofocus: false,
                ),
                Row(children: [
                  Expanded(child: eventDate()),
                  Expanded(child: eventTime()),
                  Expanded(child: eventRepeat())
                ]),
                eventColor1(),
                SizedBox(
                  height: constraints.maxHeight * .04,
                ),
                eventSub(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
