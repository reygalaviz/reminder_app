import 'package:flutter/material.dart';
//import 'package:reminder_app/models/color_data.dart';

class NoteData extends StatefulWidget {
  const NoteData({Key? key}) : super(key: key);

  @override
  State<NoteData> createState() => _NoteDataState();
}

class _NoteDataState extends State<NoteData> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      cursorColor: Colors.black,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      decoration: const InputDecoration(
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
