import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class CheckBoxNote extends StatefulWidget {
  const CheckBoxNote({Key? key}) : super(key: key);

  @override
  State<CheckBoxNote> createState() => _CheckBoxNoteState();
}

class _CheckBoxNoteState extends State<CheckBoxNote> {
  bool? value = false;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        checkColor: Colors.green,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        value: value,
        onChanged: (value) {
          setState(() {
            this.value = value;
          });
        });
  }
}
