import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              DateTime? dateT = await showDatePicker(
                  context: context,
                  initialDate: DateTime.parse(selectDate),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));
              String compForm = format.format(dateT!);
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
                  context: context, initialTime: TimeOfDay.now());
              if (!mounted) return;
              String timeString = timeT!.format(context);
              daySelect = timeString;
              cCont.text = timeString;
            },
            icon: const Icon(
              FontAwesomeIcons.clock,
              size: 20,
            ),
          ),
        ));
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
              selectColor = const Color.fromARGB(255, 180, 175, 175);
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
              selectColor = const Color.fromARGB(255, 244, 103, 150);
            });
          } else if (value == ColorList.orange) {
            colPick = Colors.orange;
            setState(() {
              selectColor = Colors.orange;
            });
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<ColorList>>[
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
                        top: BorderSide(width: 1, color: Colors.black),
                        right: BorderSide(width: 1, color: Colors.black),
                        bottom: BorderSide(width: 1, color: Colors.black),
                        left: BorderSide(width: 1, color: Colors.black)),
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
            ]);
  }

  Widget eventSubmit() {
    var item = _items[widget.id]!;
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.red,
      child: IconButton(
        onPressed: () {
          item.delete();
          _items.remove(item.id);

          final id = Localstore.instance.collection("notes").doc().id;

          final item1 = store.Notes(
              id: id,
              title: title,
              data: body,
              date: selectDate,
              time: daySelect,
              priority: priority,
              color: colPick.value.toString(),
              done: item.done);
          item1.save();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Home2()),
          );
        },
        icon: const Icon(
          FontAwesomeIcons.arrowUp,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget eventRepeat() {
    return IconButton(
        onPressed: () {},
        icon: const Icon(
          FontAwesomeIcons.repeat,
          color: Colors.grey,
          size: 20,
        ));
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
      daySelect = item.time!;
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(item.title),
      ),
      body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
                reverse: true,
                child: Form(
                  child: Column(
                    children: [
                      eventTitle(),
                      eventBody(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: eventDate()),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(child: eventTime()),
                        ],
                      ),
                      eventColor(),
                      const SizedBox(
                        width: 10,
                      ),
                      eventRepeat(),
                      const SizedBox(
                        width: 200,
                      ),
                      eventSubmit(),
                    ],
                  ),
                ),
              )),
    );
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    // Clean up the controller when the widget is removed
    dCont.dispose();
    super.dispose();
  }
}
