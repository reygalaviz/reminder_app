import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:localstore/localstore.dart';
import 'dart:async';
import 'package:reminder_app/screens/edit_notes.dart';
//import 'package:keyboard_attachable/keyboard_attachable.dart';

int initNumber = 0;
String id = "No notes exist";
bool res = false;

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
    initNumber = _items.keys.length;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView.builder(
            itemCount: _items.keys.length,
            itemBuilder: (context, index) {
              final key = _items.keys.elementAt(index);
              final item = _items[key]!;
              return Card(
                child: ListTile(
                    title: Text(
                      item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
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
