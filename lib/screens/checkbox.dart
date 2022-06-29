// ignore_for_file: unused_field
import 'package:reminder_app/controllers/notifications.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'all_notes.dart' as all;
import '../models/note_data_store.dart';
import 'package:reminder_app/models/notif_data_store.dart';
import 'all_notes.dart' as allNotes;
import 'package:localstore/localstore.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;

class CheckBoxNote extends StatefulWidget {
  const CheckBoxNote({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<CheckBoxNote> createState() => _CheckBoxNoteState();
}

class _CheckBoxNoteState extends State<CheckBoxNote> {
  final _db = Localstore.instance;
  // final _items = <String, store.Notes>{};
  // StreamSubscription<Map<String, dynamic>>? _subscription;
  // final _notifs = <String, Notifs>{};

  Color colPick = const Color.fromARGB(255, 255, 254, 254);
  String selectDate = "";
  String title = "";
  String body = "";
  String daySelect = "";
  Color selectColor = const Color.fromARGB(255, 180, 175, 174);
  String priority = "high";

  // @override
  // void initState() {
  //   super.initState();
  //   _db.collection('notes').get().then((value) {
  //     _subscription = _db.collection('notes').stream.listen((event) {
  //       setState(() {
  //         final item = store.Notes.fromMap(event);
  //         print(item);
  //         _items.putIfAbsent(item.id, () => item);
  //       });
  //     });
  //   });
  //   _db
  //       .collection("notifs")
  //       .doc(widget.id)
  //       .get()
  //       .then((value) => _db.collection('notifs').stream.listen((event) {
  //             setState(() {
  //               final item = Notifs.fromMap(event);
  //               _notifs.putIfAbsent(item.id, () => item);
  //             });
  //           }));
  // }

  bool? value = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        side: MaterialStateBorderSide.resolveWith(
            (states) => const BorderSide(width: 2.0, color: Colors.black)),
        checkColor: Colors.green,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        value: value,
        onChanged: (value) {
          setState(() {
            store.Notes co = all.items[widget.id]!;
            int ind = allNotes.searchResults.indexOf(co);
            var item = allNotes.searchResults[ind];
            if (colPick == const Color.fromARGB(255, 255, 254, 254)) {
              colPick = Color(int.parse(item.color));
            }
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
            bool boop = item.done;
            if (item.done == true) {
              boop = false;
              allNotes.completed.remove(item);
            } else {
              boop = true;
              allNotes.uncompleted.remove(item);
            }
            String ter = all.notifs[widget.id]!.id2;

            NotificationService().deleteNotif(ter);
            this.value = value;
            final id = Localstore.instance.collection("notes").doc().id;
            item.delete();
            allNotes.searchResults.remove(item);
            final item1 = store.Notes(
                id: id,
                title: title,
                data: body,
                date: selectDate,
                time: daySelect,
                priority: priority,
                color: colPick.value.toString(),
                done: boop);
            item1.save();
            allNotes.searchResults.add(item1);
            Notifs notif1 = Notifs(
              id: id,
              id2: count.channelCounter.toString(),
            );
            notif1.save();
            if (boop == true) {
              allNotes.completed.add(item1);
            } else {
              allNotes.uncompleted.add(item1);
            }
          });
        });
  }
}
