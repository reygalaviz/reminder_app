import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:reminder_app/controllers/notifications.dart';
//import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/note_data_store.dart' as store;

enum ColorList { blue, green, red, yellow, white, cyan, purple, pink, orange }

Color selectColor = const Color.fromARGB(255, 180, 175, 175);

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _db = Localstore.instance;
  final _items = <String, store.Notes>{};
  var item;
  DateFormat format = DateFormat("yyyy-MM-dd");
  final dCont = TextEditingController();
  final cCont = TextEditingController();
  Color colPick = Colors.white;

  String title = '';
  String body = '';
  String selectDate = "";
  String daySelect = "";
  var generator = Random(5);
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
        child: SizedBox(
          height: constraints.maxHeight * .8,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
            child: Form(
              child: Column(children: [
                TextFormField(
                  maxLines: 3,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: const TextStyle(decoration: TextDecoration.none),
                  decoration: const InputDecoration(
                    hintText: 'Title of Note',
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
                    hintText: 'Write Reminder body',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => body = value,
                  autofocus: false,
                ),
                PopupMenuButton<ColorList>(
                    icon: Icon(
                      Icons.color_lens,
                      color: selectColor,
                    ),
                    onSelected: (value) {
                      if (value == ColorList.blue) {
                        setState(() {
                          selectColor = Colors.blue;
                        });

                        colPick = Colors.blue;
                      } else if (value == ColorList.green) {
                        setState(() {
                          selectColor = Colors.green;
                        });
                        colPick = Colors.green;
                      } else if (value == ColorList.red) {
                        colPick = Colors.red;
                        setState(() {
                          selectColor = Colors.red;
                        });
                      } else if (value == ColorList.yellow) {
                        colPick = Colors.yellow;
                        setState(() {
                          selectColor = Colors.yellow;
                        });
                      } else if (value == ColorList.white) {
                        colPick = Colors.white;
                        setState(() {
                          selectColor =
                              const Color.fromARGB(255, 180, 175, 175);
                        });
                      } else if (value == ColorList.cyan) {
                        colPick = Colors.cyan;
                        setState(() {
                          selectColor = Colors.cyan;
                        });
                      } else if (value == ColorList.purple) {
                        colPick = Colors.purple;
                        setState(() {
                          selectColor = Colors.purple;
                        });
                      } else if (value == ColorList.pink) {
                        colPick = const Color.fromARGB(255, 244, 103, 150);
                        setState(() {
                          selectColor =
                              const Color.fromARGB(255, 244, 103, 150);
                        });
                      } else if (value == ColorList.orange) {
                        colPick = Colors.orange;
                        setState(() {
                          selectColor = Colors.orange;
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<ColorList>>[
                          PopupMenuItem<ColorList>(
                            value: ColorList.blue,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<ColorList>(
                            value: ColorList.green,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<ColorList>(
                            value: ColorList.red,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<ColorList>(
                            value: ColorList.yellow,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.yellow,
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
                                        width: 1, color: Colors.black),
                                    right: BorderSide(
                                        width: 1, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 1, color: Colors.black),
                                    left: BorderSide(
                                        width: 1, color: Colors.black)),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<ColorList>(
                            value: ColorList.cyan,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.cyan,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<ColorList>(
                            value: ColorList.purple,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<ColorList>(
                            value: ColorList.pink,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 244, 103, 150),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<ColorList>(
                            value: ColorList.orange,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ]),
                TextFormField(
                  readOnly: true,
                  maxLines: 1,
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: dCont,
                  style: const TextStyle(decoration: TextDecoration.none),
                  //initialValue: formatted,
                  decoration: const InputDecoration(
                      hintText: 'Date for the note',
                      border: InputBorder.none,
                      labelText: "Date"),
                  onTap: () async {
                    DateTime? dateT = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025));
                    String compForm = format.format(dateT!);
                    selectDate = compForm;
                    dCont.text = compForm;
                  },
                  autofocus: false,
                ),
                TextFormField(
                  readOnly: true,
                  maxLines: 1,
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: cCont,
                  style: const TextStyle(decoration: TextDecoration.none),
                  //initialValue: formatted,
                  decoration: const InputDecoration(
                      hintText: 'Time for the note',
                      border: InputBorder.none,
                      labelText: "Time"),
                  onTap: () async {
                    TimeOfDay? timeT = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()));
                    if (!mounted) return;
                    String timeString = timeT!.format(context);
                    daySelect = timeString;
                    cCont.text = timeString;
                    print(daySelect);
                  },
                  autofocus: false,
                ),
                TextButton(
                  onPressed: () {
                    final id = Localstore.instance.collection("notes").doc().id;

                    String priority = "high";
                    final item = store.Notes(
                        id: id,
                        title: title,
                        data: body,
                        date: selectDate,
                        time: daySelect,
                        priority: priority,
                        color: colPick.value.toString());
                    item.save();
                    count.channelCounter++;

                    NotificationService().displayNotification(
                        body: body,
                        channel: count.channelCounter,
                        title: title);
                    Navigator.pop(context);
                  },
                  child: const Text("Submit"),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
