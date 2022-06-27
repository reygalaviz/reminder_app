import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CompletedNotes extends StatefulWidget {
  const CompletedNotes({Key? key}) : super(key: key);

  @override
  State<CompletedNotes> createState() => _CompletedNotesState();
}

class _CompletedNotesState extends State<CompletedNotes> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        child: Flexible(
      child: Card(
          child: ExpansionTile(
        textColor: Colors.green,
        iconColor: Colors.green,
        title: Text(
          'Completed',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        children: <Widget>[],
      )),
    ));
  }
}
