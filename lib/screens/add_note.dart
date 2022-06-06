import 'dart:math';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:reminder_app/controllers/notifications.dart';
//import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:reminder_app/models/color_data.dart' as colors;

enum colorList { blue, green, red, yellow, white, cyan, purple, pink }

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
                // Row(
                PopupMenuButton<colorList>(
                    icon: const Icon(
                      Icons.color_lens,
                      color: Colors.green,
                    ),
                    onSelected: (value) {
                      if (value == colorList.blue) {
                        colPick = Colors.blue;
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
                        color: colPick.toString());
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
