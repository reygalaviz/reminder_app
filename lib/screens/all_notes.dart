import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'dart:async';

//import 'package:cupertino_icons/cupertino_icons.dart';
//import 'package:reminder_app/screens/add_note.dart';
//import 'package:reminder_app/screens/home.dart';
//import 'package:keyboard_attachable/keyboard_attachable.dart';
//import 'package:reminder_app/controllers/notifications.dart';
//import 'package:reminder_app/main.dart' as count;

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  String data = "No notes yet!";
  final _db = Localstore.instance;
  final _items = <String, store.Notes>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;
  @override
  void initState() {
    super.initState();
    _db.collection('notes').get().then((value) {
      /*      setState(() {
        value?.entries.forEach((element) {
          final item = store.Notes.fromMap(element.value);
          _items.putIfAbsent(item.id, () => item);
        });
      }); */
      _subscription = _db.collection('notes').stream.listen((event) {
        setState(() {
          final item = store.Notes.fromMap(event);
          _items.putIfAbsent(item.id, () => item);
        });
      });
      // if (kIsWeb) _db.collection('notes').stream.asBroadcastStream();
    });
  }
  /*@override
  void initState() {
    super.initState();
    store.readcontent().then((String value) {
      setState(() {
        data = value;
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    print(_items);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView.builder(
            itemCount: _items.keys.length,
            itemBuilder: (context, index) {
              final key = _items.keys.elementAt(index);
              final item = _items[key]!;
              return Center(
                  child: Text(
                item.data,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ));
            }

            /*Center(
          child: Text(
        data,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),*/
            ));
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    super.dispose();
  }
}
