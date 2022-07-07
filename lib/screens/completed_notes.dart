import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'all_notes.dart' as allNotes;
import 'package:reminder_app/models/notif_data_store.dart';
import 'package:reminder_app/controllers/notifications.dart';
import '../models/note_data_store.dart';
import 'package:reminder_app/screens/edit_notes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../models/note_data_store.dart';
import 'home.dart' as home;
import 'package:reminder_app/models/notif_data_store.dart';
import 'checkbox.dart';

List<Notes> completed = <Notes>[];
String id = "No notes exist";
bool res = false;

class CompletedNotes extends StatefulWidget {
  const CompletedNotes({Key? key}) : super(key: key);

  @override
  State<CompletedNotes> createState() => _CompletedNotesState();
}

class _CompletedNotesState extends State<CompletedNotes> {
  bool res = false;
  @override
  Widget build(BuildContext context) {
    completed.clear();
    allNotes.items.forEach((key, value) {
      if (value.done == true) {
        completed.add(value);
      }
    });
    // return const SingleChildScrollView(
    //     child: Flexible(
    //   child: Card(
    //       child: ExpansionTile(
    //     textColor: Colors.green,
    //     iconColor: Colors.green,
    //     title: Text(
    //       'Completed',
    //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //     ),
    return SizedBox(
      height: 500,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: completed.length,
          // items.keys.length,
          itemBuilder: (context, index) {
            // final key = items.keys.elementAt(index);
            // final item = items[key]!;

            final item = completed[index];

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
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

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditNote(id: id)));
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
                          allNotes.searchResults.remove(item);
                          completed.remove(item);

                          item.delete();
                          String not = allNotes.notifs[item.id]!.id2;
                          NotificationService().deleteNotif(not);
                          allNotes.items.remove(item.id);
                          res = false;
                        });
                      }
                    },
                  ),
                  CheckBoxNote2(id: item.id)
                ]),
              ),
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
}
