import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/models/note_data_store.dart';

bool? isDone = false;

class CheckBoxNote extends StatefulWidget {
  const CheckBoxNote({Key? key}) : super(key: key);

  @override
  State<CheckBoxNote> createState() => _CheckBoxNoteState();
}

class _CheckBoxNoteState extends State<CheckBoxNote> {
  late final Notes note;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        side: MaterialStateBorderSide.resolveWith(
            (states) => const BorderSide(width: 2.0, color: Colors.black)),
        checkColor: Colors.green,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        value: isDone,
        onChanged: (value) {
          setState(() {
            // isDone = value;
          });
        });
  }
}
