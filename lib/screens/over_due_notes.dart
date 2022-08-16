import 'package:flutter/material.dart';

class OverDueNotes extends StatefulWidget {
  const OverDueNotes({Key? key}) : super(key: key);

  @override
  State<OverDueNotes> createState() => _OverDueNotesState();
}

class _OverDueNotesState extends State<OverDueNotes> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        child: Flexible(
      child: Card(
          child: ExpansionTile(
              textColor: Colors.red,
              iconColor: Colors.red,
              title: Text('PastDue',
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
    ));
  }
}
