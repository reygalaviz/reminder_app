import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'dart:async';
import 'package:reminder_app/screens/all_notes.dart' as note;

class EditNote extends StatefulWidget {
  const EditNote({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  StreamSubscription<Map<String, dynamic>>? _subscription;
  final _db = Localstore.instance;
  final _items = <String, store.Notes>{};
  var item;
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
  }

  @override
  Widget build(BuildContext context) {
    //final item = store.getData(widget.id);
    var item = _items[widget.id]!;
    String title = item.title;
    String body = item.data;
    return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
              reverse: true,
              child:
                  // SizedBox(
                  //   height: constraints.maxHeight * .3,
                  // ),
                  SizedBox(
                height: constraints.maxHeight * .7,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          maxLines: 2,
                          autocorrect: false,
                          enableSuggestions: false,
                          style:
                              const TextStyle(decoration: TextDecoration.none),
                          initialValue: title,
                          decoration: const InputDecoration(
                              hintText: 'Title of Note',
                              border: InputBorder.none,
                              labelText: "Title:"),
                          onChanged: (value) => title = value,
                          autofocus: true,
                        ),
                        TextFormField(
                          maxLines: 3,
                          autocorrect: false,
                          enableSuggestions: false,
                          style:
                              const TextStyle(decoration: TextDecoration.none),
                          initialValue: body,
                          decoration: const InputDecoration(
                            hintText: 'Write Reminder body',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => title = value,
                          autofocus: false,
                        ),
                        TextButton(
                          onPressed: () {
                            /*int id = generator.nextInt(150);
                      String title = "Test";
                      DateTime date = new DateTime(2022, 5, 31, 4, 50);
                      Color color = Color.fromARGB(199, 148, 84, 84);
                      String priority = "high";

                      store.writeData(
                          title, body, date, priority, color);*/
                            // final id =
                            //     Localstore.instance.collection("notes").doc().id;
                            // final date = DateTime.now().toIso8601String();
                            // Color color = Color.fromARGB(199, 148, 84, 84);
                            // String color1 = color.toString();
                            // String priority = "high";
                            // final item = store.Notes(
                            //     id: id,
                            //     title: title,
                            //     data: title,
                            //     date: date,
                            //     priority: priority,
                            //     color: color1);
                            // item.save();
                            // count.channelCounter++;

                            // NotificationService().displayNotification(
                            //     body: body,
                            //     channel: count.channelCounter,
                            //     title: title);
                            Navigator.pop(context);
                          },
                          child: const Text("Submit"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    super.dispose();
  }
}
