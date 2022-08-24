import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'package:reminder_app/screens/checkbox.dart';
import 'package:reminder_app/screens/completed_notes.dart';
import 'dart:async';
import 'package:reminder_app/screens/edit_notes.dart';
import '../models/note_data_store.dart';
import 'home.dart' as home;
import 'package:reminder_app/models/notif_data_store.dart';
import 'package:reminder_app/controllers/notifications.dart';
import 'table_calendar.dart';
import 'package:reminder_app/main.dart';

int initNumber = 0;

var items = <String, store.Notes>{};
var notifs = <String, Notifs>{};
//String id = "No notes exist";

// List<Notes> searchResults = <Notes>[];
// List<String> notes = <String>[];
// List<Notes> uncompleted = <Notes>[];

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
  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   uncompleted.clear();
    // });

    _tabController = TabController(length: 2, vsync: this);
    _db.collection('notes').get().then((value) {
      _subscription = _db.collection('notes').stream.listen((event) {
        setState(() {
          final item = store.Notes.fromMap(event);
          if (!notes.contains(item.id)) {
            ;
            notes.add(item.id);
            searchResults.add(item);

            if (item.done == false) {
              if (uncompleted.indexWhere((element) => element.id == item.id) ==
                  -1) {
                uncompleted.add(item);
              }
            }
          }

          items.putIfAbsent(item.id, () => item);
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
    return SizedBox(
      height: 500,
      child: ListView.builder(
          //key: Key(uncompleted.length.toString()),
          shrinkWrap: true,
          itemCount: uncompleted.length,
          itemBuilder: (context, index) {
            final item = uncompleted[index];

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        await _showDialog(item);
                      },
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
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
                    ;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditNote(id: item.id)));
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

    return Scaffold(
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
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                  padding: EdgeInsets.only(left: constraints.maxWidth * .01),
                  child: TabBar(
                      indicatorPadding: const EdgeInsets.only(right: 10),
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      isScrollable: true,
                      labelColor: Theme.of(context).primaryColor,
                      labelPadding: const EdgeInsets.only(left: 0, right: 20),
                      unselectedLabelColor: Colors.grey[600],
                      controller: _tabController,
                      labelStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(
                          text: 'ToDo',
                        ),
                        Tab(text: 'Completed'),
                      ]),
                ),
                SizedBox(
                    width: double.maxFinite,
                    height: constraints.maxHeight * .77,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        notesCard(),
                        CompletedNotes(key: UniqueKey()),
                      ],
                    )),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ));
    //));
  }

  // @override
  // void dispose() {
  //   if (_subscription != null) _subscription?.cancel();
  //   super.dispose();
  // }

  String texter({required store.Notes item2}) {
    if (item2.data == '') {
      return '${item2.date} ${item2.time}';
    } else {
      return item2.data;
    }
  }

  Future<bool?> _showDialog(store.Notes item2) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (dialogContex) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
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
              child: Text('Cancel',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    int b =
                        searchResults.indexWhere((val) => val.id == item2.id);
                    if (b != -1) {
                      searchResults.removeAt(b);
                    }
                    int c = uncompleted.indexWhere((val) => val.id == item2.id);
                    if (c != -1) {
                      uncompleted.removeAt(c);
                    }
                    items.remove(item2.id);
                    int d =
                        items1.indexWhere((element) => element.id == item2.id);
                    if (d != -1) {
                      items1.removeAt(d);
                    }

                    notes.removeWhere((element) => element == item2.id);

                    int e = completed
                        .indexWhere((element) => element.id == item2.id);
                    if (e != -1) {
                      completed.removeAt(e);
                    }

                    item2.delete();
                    notes.remove(item2.id);
                    String not = notifs[item2.id]!.id2;
                    NotificationService().deleteNotif(not);
                    if (!mounted) return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (dialogContext) => home.Home(
                                  key: UniqueKey(),
                                )));
                  });
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ))
          ],
        );
      },
    );
  }
}
