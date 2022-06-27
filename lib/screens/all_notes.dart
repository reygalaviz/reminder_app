import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'package:reminder_app/screens/checkbox.dart';
import 'package:reminder_app/screens/completed_notes.dart';
import 'dart:async';
import 'package:reminder_app/screens/edit_notes.dart';
import 'package:reminder_app/screens/over_due_notes.dart';
import 'home.dart' as home;
import 'package:reminder_app/models/notif_data_store.dart';
import 'package:reminder_app/controllers/notifications.dart';

int initNumber = 0;
String id = "No notes exist";
bool res = false;

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> with TickerProviderStateMixin {
  String data = "No notes yet!";
  final _db = Localstore.instance;
  final _items = <String, store.Notes>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;
  String formattedDate = DateFormat.MMMMEEEEd().format(DateTime.now());
  final _notifs = <String, Notifs>{};
  late TabController _tabController = TabController(length: 3, vsync: this);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _db.collection('notes').get().then((value) {
      _subscription = _db.collection('notes').stream.listen((event) {
        setState(() {
          final item = store.Notes.fromMap(event);
          _items.putIfAbsent(item.id, () => item);
        });
      });
    });
    _db
        .collection("notifs")
        .doc()
        .get()
        .then((value) => _db.collection('notifs').stream.listen((event) {
              setState(() {
                final item = Notifs.fromMap(event);
                _notifs.putIfAbsent(item.id, () => item);
              });
            }));
  }

  Widget notesCard() {
    return SizedBox(
      height: 500,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _items.keys.length,
          itemBuilder: (context, index) {
            final key = _items.keys.elementAt(index);
            final item = _items[key]!;
            return Card(
              child: ListTile(
                title: Text(
                  item.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                subtitle: Text(
                  '${item.date} ${item.time}',
                  style: const TextStyle(color: Colors.black),
                ),
                tileColor: Color(int.parse(item.color)).withOpacity(1),
                onTap: () {
                  id = item.id;

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
                trailing: Wrap(children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.trash,
                      size: 20,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      await _showDialog(item);
                      if (res == true) {
                        setState(() {
                          item.delete();
                          String not = _notifs[item.id]!.id2;
                          NotificationService().deleteNotif(not);
                          _items.remove(item.id);
                          res = false;
                        });
                      }
                    },
                  ),
                  const CheckBoxNote()
                ]),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    initNumber = _items.keys.length;

    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.white30,
        ),
        onDismissed: (direct) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const home.Home2()),
          );
        },
        direction: DismissDirection.horizontal,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: LayoutBuilder(
              builder: (context, constraints) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Today',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: constraints.maxWidth * .01),
                      child: TabBar(
                          indicatorPadding: const EdgeInsets.only(right: 10),
                          indicatorColor: Theme.of(context).primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          isScrollable: true,
                          labelColor: Theme.of(context).primaryColor,
                          labelPadding:
                              const EdgeInsets.only(left: 0, right: 20),
                          unselectedLabelColor: Colors.grey[600],
                          controller: _tabController,
                          labelStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          tabs: const [
                            Tab(
                              text: 'ToDo',
                            ),
                            Tab(text: 'Completed'),
                            Tab(text: 'Overdue'),
                          ]),
                    ),
                    Container(
                        width: double.maxFinite,
                        height: constraints.maxHeight * .77,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            notesCard(),
                            Text('completed'),
                            Text('overdue'),
                          ],
                        )),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            )));
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    super.dispose();
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
}
