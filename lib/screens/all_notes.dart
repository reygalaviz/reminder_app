import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:reminder_app/screens/add_note.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:reminder_app/controllers/Notifications.dart';

class AllNotes extends StatefulWidget {
  const AllNotes({Key? key}) : super(key: key);

  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: const Center(
          child: Text(
        'All Notes',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
      )),
    );
  }
}
