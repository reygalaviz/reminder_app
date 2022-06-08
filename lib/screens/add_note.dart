import 'dart:math';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:reminder_app/controllers/notifications.dart';
//import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:reminder_app/models/color_data.dart' as colors;

enum colorList { blue, green, red, yellow, white, cyan, purple, pink }

Color selectColor = Colors.green;

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String body = '';
  String title = "No title inserted";
  Color colPick = Colors.white;

  var generator = Random(5);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        reverse: true,
        child: SizedBox(
          height: constraints.maxHeight * .7,
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
                PopupMenuButton<colorList>(
                    icon: Icon(
                      Icons.color_lens,
                      color: selectColor,
                    ),
                    onSelected: (value) {
                      if (value == colorList.blue) {
                        setState(() {
                          selectColor = Colors.blue;
                        });

                        colPick = Colors.blue;
                      } else if (value == colorList.green) {
                        setState(() {
                          selectColor = Colors.green;
                        });
                        colPick = Colors.green;
                      } else if (value == colorList.red) {
                        colPick = Colors.red;
                        setState(() {
                          selectColor = Colors.red;
                        });
                      } else if (value == colorList.yellow) {
                        colPick = Colors.yellow;
                        setState(() {
                          selectColor = Colors.yellow;
                        });
                      } else if (value == colorList.white) {
                        colPick = Colors.white;
                        setState(() {
                          selectColor =
                              const Color.fromARGB(255, 180, 175, 175);
                        });
                      } else if (value == colorList.cyan) {
                        colPick = Colors.cyan;
                        setState(() {
                          selectColor = Colors.cyan;
                        });
                      } else if (value == colorList.purple) {
                        colPick = Colors.purple;
                        setState(() {
                          selectColor = Colors.purple;
                        });
                      } else if (value == colorList.pink) {
                        colPick = const Color.fromARGB(255, 244, 103, 150);
                        setState(() {
                          selectColor =
                              const Color.fromARGB(255, 244, 103, 150);
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<colorList>>[
                          PopupMenuItem<colorList>(
                            value: colorList.blue,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<colorList>(
                            value: colorList.green,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<colorList>(
                            value: colorList.red,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<colorList>(
                            value: colorList.yellow,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.yellow,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<colorList>(
                            value: colorList.white,
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
                          PopupMenuItem<colorList>(
                            value: colorList.cyan,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.cyan,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<colorList>(
                            value: colorList.purple,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          PopupMenuItem<colorList>(
                            value: colorList.pink,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 244, 103, 150),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ]),
                TextButton(
                  onPressed: () {
                    final id = Localstore.instance.collection("notes").doc().id;
                    final date = DateTime.now().toIso8601String();
                    Color color = Color.fromARGB(199, 148, 84, 84);
                    String color1 = color.toString();
                    String priority = "high";
                    final item = store.Notes(
                        id: id,
                        title: title,
                        data: body,
                        date: date,
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
              // ]),
            ),
          ),
        ),
      ),
    );
  }
}
