import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_data_store.dart';

class EventDetails extends StatelessWidget {
  final Notes note;
  const EventDetails({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: Text(
              note.title,
              style: Theme.of(context).primaryTextTheme.headline5,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ListTile(
            title: Text(note.data),
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
