import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:intl/intl.dart';
import 'dart:async';

enum ColorList { blue, green, red, yellow, white, cyan, purple, pink, orange }

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
  StreamSubscription<Map<String, dynamic>>? _subscription;
  // var item;
  DateFormat format = DateFormat("yyyy-MM-dd");
  final dCont = TextEditingController();
  final cCont = TextEditingController();
  Color colPick = const Color.fromARGB(255, 255, 254, 254);
  final formatter = DateFormat().add_jm();
  String selectDate = "";
  String title = "";
  String body = "";
  String daySelect = "";
  Color selectColor = const Color.fromARGB(255, 180, 175, 174);
  String priority = "low";
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
              reverse: true,
              child: SizedBox(
                height: constraints.maxHeight * .95,
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
                          maxLines: 2,
                          autocorrect: false,
                          enableSuggestions: false,
                          style:
                              const TextStyle(decoration: TextDecoration.none),
                          initialValue: body,
                          decoration: const InputDecoration(
                            hintText: 'Write Reminder body',
                            border: InputBorder.none,
                            labelText: "Details",
                          ),
                          onChanged: (value) => body = value,
                          autofocus: false,
                        ),
                        TextFormField(
                          readOnly: true,
                          maxLines: 1,
                          autocorrect: false,
                          controller: dCont,
                          style:
                              const TextStyle(decoration: TextDecoration.none),
                          //initialValue: formatted,
                          decoration: const InputDecoration(
                              hintText: 'Date for the note',
                              border: InputBorder.none,
                              labelText: "Date"),
                          onTap: () async {
                            DateTime? dateT = await showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(selectDate),
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
                          style:
                              const TextStyle(decoration: TextDecoration.none),
                          //initialValue: formatted,
                          decoration: const InputDecoration(
                              hintText: 'Time for the note',
                              border: InputBorder.none,
                              labelText: "Time"),
                          onTap: () async {
                            TimeOfDay? timeT = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay
                                    .now()); // TimeOfDay.fromDateTime(DateTime.now()));

                            if (!mounted) return;
                            String timeString = timeT!.format(context);
                            daySelect = timeString;
                            cCont.text = timeString;
                          },
                          autofocus: false,
                        ),
                        Row(children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                constraints.maxWidth / 3, 0.0, 00.0, 0.0),
                          ),
                          // PopupMenuButton<Priorities>(itemBuilder: itemBuilder)
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
                                    selectColor = const Color.fromARGB(
                                        255, 180, 175, 175);
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
                                  colPick =
                                      const Color.fromARGB(255, 244, 103, 150);
                                  setState(() {
                                    selectColor = const Color.fromARGB(
                                        255, 244, 103, 150);
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
                                                  width: 1,
                                                  color: Colors.black),
                                              right: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              left: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
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
                                          color: Color.fromARGB(
                                              255, 244, 103, 150),
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
                              item.delete();
                              _items.remove(item.id);

                              final id = Localstore.instance
                                  .collection("notes")
                                  .doc()
                                  .id;

                              final item1 = store.Notes(
                                  id: id,
                                  title: title,
                                  data: body,
                                  date: selectDate,
                                  time: daySelect,
                                  priority: priority,
                                  color: colPick.value.toString());
                              item1.save();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()),
                              );
                            },
                            child: const Text("Submit"),
                          ),
                        ]),
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
    // Clean up the controller when the widget is removed
    dCont.dispose();
    super.dispose();
  }
}
