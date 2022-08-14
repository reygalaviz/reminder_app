import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/controllers/notifications.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/notes_operation.dart';
import 'package:reminder_app/models/notif_data_store.dart';
import 'package:reminder_app/models/repeat_store.dart';

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
  final dCont = TextEditingController();
  final cCont = TextEditingController();
  Color colPick = Colors.white;
  String repeat = "One-Time";
  String title = '';
  String body = '';
  String selectDate = "";
  String daySelect = "";

  late DateTime scheduler = DateTime.now();
  late DateTime scheduler2 = DateTime.now();
  DismissDirection direct = DismissDirection.endToStart;
  var generator = Random(5);
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
      readOnly: true,
      autocorrect: false,
      enableSuggestions: false,
      controller: dCont,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(left: 0),
        prefixIconConstraints: const BoxConstraints(minWidth: 0),
        prefixIcon: IconButton(
            onPressed: () async {
              final DateTime? dateT = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022, 1, 1),
                  lastDate: DateTime(2025, 12, 12));
              String compForm = format.format(dateT!);
              setState(() {
                scheduler = dateT;
              });

              selectDate = compForm;

              dCont.text = compForm;
            },
            icon: const Icon(
              FontAwesomeIcons.calendar,
              size: 20,
            )),
      ),
    );
  }

  Widget eventTime() {
    return TextFormField(
        autofocus: false,
        readOnly: true,
        maxLines: 1,
        autocorrect: false,
        enableSuggestions: false,
        controller: cCont,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: IconButton(
            onPressed: () async {
              TimeOfDay? timeT = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(DateTime.now()));
              if (!mounted) return;
              String timeString = timeT!.format(context);
              daySelect = timeString;
              cCont.text = timeString;
              scheduler2 = DateTime(scheduler.year, scheduler.month,
                  scheduler.day, timeT.hour, timeT.minute);
            },
            icon: const Icon(
              FontAwesomeIcons.clock,
              size: 20,
            ),
          ),
        ));
  }

  Widget eventSub() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.red,
      child: IconButton(
          onPressed: () {
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

              selectColor = const Color.fromARGB(255, 180, 175, 175);

              Navigator.pop(context);
            } else if (repeat == "Daily") {
              // String id2 = Localstore.instance.collection("notes").doc().id;
              Notifs notif = Notifs(
                id: id,
                id2: count.channelCounter.toString(),
              );
              notif.save();
              Repeat reeeeee = Repeat(id: id, option: "Daily");
              reeeeee.save();
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
              if (count.notifChoice == true) {
                NotificationService().scheduleNotificationDaily(
                    body: body,
                    channel: count.channelCounter,
                    title: title,
                    date: scheduler2);
              }

              selectColor = const Color.fromARGB(255, 180, 175, 175);

              Navigator.pop(context);
            } else if (repeat == "Weekly") {
              // String id2 = Localstore.instance.collection("notes").doc().id;
              Notifs notif = Notifs(
                id: id,
                id2: count.channelCounter.toString(),
              );
              notif.save();
              Repeat reeeeee = Repeat(id: id, option: "Weekly");
              reeeeee.save();
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
              if (count.notifChoice == true) {
                NotificationService().displayScheduleNotif(
                    body: body,
                    channel: count.channelCounter,
                    title: title,
                    date: scheduler2);
              }

              selectColor = const Color.fromARGB(255, 180, 175, 175);

              Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    if (selectDate == "") {
      selectDate = format.format(DateTime.now()).toString();
    }
    if (daySelect == "") {
      daySelect = TimeOfDay.now().format(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: EdgeInsets.all(constraints.maxWidth * .04),
            child: Form(
              child: Column(children: [
                TextFormField(
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(child: eventTime()),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(child: eventColor()),
                  const SizedBox(
                    width: 10,
                  ),
                  // Expanded(child:
                  SizedBox(width: 80, child: eventRepeat()),
                  const SizedBox(
                    width: 150,
                  ),
                  Expanded(child: eventSub()),
                ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
