import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_data_store.dart';

class EventDetails extends StatelessWidget {
  final Notes note;
  const EventDetails({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[Text(note.title)],
        ));
  }
}
