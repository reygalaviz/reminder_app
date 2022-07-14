import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/Screens/all_notes.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'package:reminder_app/models/notes_operation.dart';
import 'package:reminder_app/screens/checkbox.dart';
import 'package:reminder_app/screens/completed_notes.dart';
import 'dart:async';
import 'package:reminder_app/screens/edit_notes.dart';
import 'package:reminder_app/screens/over_due_notes.dart';
import '../models/note_data_store.dart';
import 'home.dart' as home;
import 'package:reminder_app/models/notif_data_store.dart';
import 'package:reminder_app/controllers/notifications.dart';

int initNumber = 0;
final items = <String, store.Notes>{};
final notifs = <String, Notifs>{};
String id = "No notes exist";
bool res = false;
List<Notes> searchResults = <Notes>[];
List<String> notes = <String>[];

List<Notes> uncompleted = <Notes>[];

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> with TickerProviderStateMixin {
  String data = "No notes yet!";
  final _db = Localstore.instance;

  StreamSubscription<Map<String, dynamic>>? _subscription;
  String formattedDate = DateFormat.MMMMEEEEd().format(DateTime.now());

  late TabController _tabController = TabController(length: 3, vsync: this);
  @override
  void initState() {
    super.initState();
    setState(() {
      uncompleted.clear();

      searchResults.clear();
    });

    _tabController = TabController(length: 3, vsync: this);
    _db.collection('notes').get().then((value) {
      _subscription = _db.collection('notes').stream.listen((event) {
        setState(() {
          final item = store.Notes.fromMap(event);

          items.putIfAbsent(item.id, () => item);
          // searchResults.add(item);
          // if (item.done == true) {
          //   completed.add(item);
          // } else {

          // }
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
                notifs.putIfAbsent(item.id, () => item);
              });
            }));
  }

  Widget notesCard() {
    uncompleted.clear();
    items.forEach((key, value) {
      if (value.done == false) {
        uncompleted.add(value);
      }
    });
    return SizedBox(
      height: 500,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: uncompleted.length,
          // items.keys.length,
          itemBuilder: (context, index) {
            // final key = items.keys.elementAt(index);
            // final item = items[key]!;

            final item = uncompleted[index];

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        await _showDialog(item);
                        if (res == true) {
                          setState(() {
                            searchResults.remove(item);
                            uncompleted.remove(item);
                            item.delete();

                            String not = notifs[item.id]!.id2;
                            NotificationService().deleteNotif(not);

                            items.remove(item.id);

                            res = false;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: FontAwesomeIcons.trash,
                    ),
                  ],
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text(
                    texter(item2: item),
                    style: const TextStyle(color: Colors.black),
                  ),
                  tileColor: Color(int.parse(item.color)).withOpacity(1),
                  onTap: () {
                    id = item.id;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditNote(id: id)));
                  },
                  trailing: Wrap(children: <Widget>[CheckBoxNote(id: item.id)]),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    initNumber = items.keys.length;

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
                    SizedBox(
                        width: double.maxFinite,
                        height: constraints.maxHeight * .77,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            notesCard(),
                            const CompletedNotes(),
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

  String texter({required store.Notes item2}) {
    print(item2.data);
    if (item2.data == '') {
      return '${item2.date} ${item2.time}';
    } else {
      return item2.data;
    }
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
