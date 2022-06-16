import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/color_data.dart';
import 'package:reminder_app/models/note_data_store.dart';
import 'package:reminder_app/screens/add_note.dart';
import 'package:reminder_app/screens/all_notes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'home.dart' as home;
import 'all_notes.dart';

String id = "No notes exist";
bool res = false;
Color colPick = Colors.white;
StreamSubscription<Map<String, dynamic>>? _subscription;
final _db = Localstore.instance;
final _items = <String, store.Notes>{};
String selectDate = "";
String title = "";
String body = "";
String daySelect = "";
Color selectColor = const Color.fromARGB(255, 180, 175, 174);

// Map<DateTime, List<Notes>>? _events;
// late final ValueNotifier<List<Notes>> _selectedEvents;

CalendarFormat format = CalendarFormat.month;
List<Notes> _events = [];
LinkedHashMap<DateTime, List<Notes>>? _groupedEvents;
DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();
DateFormat formatter = DateFormat("yyyy-MM-dd");

class Table_Calendar extends StatefulWidget {
  const Table_Calendar({Key? key}) : super(key: key);

  @override
  State<Table_Calendar> createState() => Table_CalendarState();
}

class Table_CalendarState extends State<Table_Calendar> {
  @override
  void initState() {
    super.initState();
    _db.collection('notes').get().then((value) {
      _subscription = _db.collection('notes').stream.listen((event) {
        setState(() {
          final item = store.Notes.fromMap(event);
          _items.putIfAbsent(item.id, () => item);
          _events.add(item);
        });
      });
    });
    // _selectedDay = DateTime.now();
    // _selectedEvents = ValueNotifier(_getEventsFromDay(_selectedDay));
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  // Future addEvents() async {
  //   await _db.collection('notes').get().then((events) {
  //     final id = Localstore.instance.collection("notes").doc().id;
  //     Color color = Color.fromARGB(199, 148, 84, 84);
  //     String color1 = color.toString();
  //     DateTime date = DateTime.now();

  //     for (var i = 0; i < events!.length; i++) {
  //       final id = Localstore.instance.collection("notes").doc().id;
  //       String priority = "high";
  //       final item1 = store.Notes(
  //           id: id,
  //           title: title,
  //           data: body,
  //           date: selectDate,
  //           time: daySelect,
  //           priority: priority,
  //           color: colPick.value.toString());
  //       item1.save();
  //     }
  //     setState(() {
  //       res = true;
  //     });
  //   });
  //   groupEvents(_events);
  // }

  groupEvents(List<Notes> events) {
    String dateString = "";

    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    DateTime date = DateTime.now();
    for (var event in _events) {
      dateString = event.date;
      date = DateTime.parse(dateString);
      // DateTime date = DateTime.utc().;
      if (_groupedEvents![date] == null) _groupedEvents![date] = [];
      _groupedEvents![date]?.add(event);
    }
  }

  List<Notes> _getEventsFromDay(DateTime date) {
    return _groupedEvents?[date] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget calendar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
            )
          ]),
      child: TableCalendar<Notes>(
        focusedDay: _focusedDay,
        firstDay: DateTime(1990),
        lastDay: DateTime(3022),
        selectedDayPredicate: (DateTime day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: _onDaySelected,
        calendarFormat: format,
        onFormatChanged: (calformat) {
          setState(() {
            format = calformat;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        headerStyle: const HeaderStyle(
          leftChevronIcon:
              Icon(Icons.arrow_back_ios, size: 15, color: Colors.black),
          rightChevronIcon:
              Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black),
        ),
        eventLoader: _getEventsFromDay,
        calendarStyle: CalendarStyle(
            canMarkersOverflow: true,
            isTodayHighlighted: true,
            defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0)),
            weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0)),
            selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0)),
            todayDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(5.0)),
            selectedTextStyle: TextStyle(color: Theme.of(context).primaryColor),
            weekendTextStyle: const TextStyle(color: Colors.red),
            todayTextStyle: TextStyle(
                fontWeight: FontWeight.w200,
                color: Theme.of(context).primaryColor)),
      ),
    );
  }

  Widget eventTitle() {
    if (_items.keys.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(2, 20, 15, 15),
        child: Text("No events",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            )),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.red,
          child: Text(
            "Events",
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
        ),
      ],
    );
  }

  Widget events() {
    return Expanded(
      child: ListView.builder(
          itemCount: _items.keys.length,
          itemBuilder: (context, index) {
            final key = _items.keys.elementAt(index);
            final item = _items[key]!;
            return Card(
              child: ListTile(
                  title: Text(
                    item.title,
                  ),
                  subtitle: Text(item.date),
                  tileColor: Color(int.parse(item.color)).withOpacity(1),
                  onTap: () {
                    id = item.id;
                    //make a map to handle this
                    showModalBottomSheet(
                        enableDrag: false,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0))),
                        context: context,
                        builder: (context) {
                          return EditNote(id: id);
                        });
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),

                    onPressed: () async {
                      await _showDialog(item);
                      if (res == true) {
                        setState(() {
                          item.delete();
                          _items.remove(item.id);
                          res = false;
                        });
                      }
                    }, //Center(
                    //  child: Text(
                    //item.data,
                  )),
            );
          }),
    );
  }

  Future<bool?> _showDialog(final item) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a permanent and data cannot be recovered again!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                res = false;
              },
            ),
            TextButton(
                onPressed: () {
                  res = true;
                  Navigator.of(context).pop();
                },
                child: const Text("Delete"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.white30,
        ),
        onDismissed: (direct) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const home.Home()),
          );
        },
        direction: DismissDirection.horizontal,
        child: Scaffold(
            body: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(children: [
            calendar(),
            eventTitle(),
            const SizedBox(
              height: 8.0,
            ),
            events(),
          ]),
        )));
  }
}

enum ColorList { blue, green, red, yellow, white, cyan, purple, pink, orange }

//enum Priorities { low, medium, high}
class EditNote extends StatefulWidget {
  const EditNote({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  // final _db = Localstore.instance;
  // final _items = <String, store.Notes>{};
  // StreamSubscription<Map<String, dynamic>>? _subscription;
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
  // @override
  // void initState() {
  //   super.initState();
  //   _db.collection('notes').get().then((value) {
  //     _subscription = _db.collection('notes').stream.listen((event) {
  //       setState(() {
  //         final item = store.Notes.fromMap(event);
  //         _items.putIfAbsent(item.id, () => item);
  //       });
  //     });
  //   });
  // }

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

    return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
              reverse: true,
              child: SizedBox(
                height: constraints.maxHeight * .90,
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
                              setState(() {
                                _items.remove(item.id);
                                _events.remove(item);
                              });

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
                                      builder: (context) =>
                                          const home.Home2()));
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
