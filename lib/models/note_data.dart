import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reminder_app/models/color_data.dart';

class NoteData_ extends StatefulWidget {
  const NoteData_({Key? key}) : super(key: key);

  @override
  State<NoteData_> createState() => _NoteData_State();
}

class _NoteData_State extends State<NoteData_> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.all(8.0),
        hintText: 'Enter Reminder',
        hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
