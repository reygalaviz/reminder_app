import 'dart:math';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:reminder_app/controllers/notifications.dart';
//import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:reminder_app/models/color_data.dart' as colors;

enum ColorList { blue, green, red, yellow, white, cyan, purple, pink, orange }

Color selectColor = const Color.fromARGB(255, 180, 175, 175);

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
            ),
          ),
        ),
      ),
    );
  }
}
