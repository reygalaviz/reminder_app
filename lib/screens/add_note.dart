import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:reminder_app/controllers/notifications.dart';
import 'package:reminder_app/main.dart' as count;

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String body = '';
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        reverse: true,
        child: Container(
          height: constraints.maxHeight * .7,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 3,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: TextStyle(decoration: TextDecoration.none),
                    decoration: InputDecoration(
                      hintText: 'Write Reminder',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => body = value,
                    autofocus: true,
                  ),
                  TextButton(
                    onPressed: () {
                      NotificationService().displayNotification(
                          body: body, channel: count.channelCounter);
                      Navigator.pop(context);
                    },
                    child: const Text("Submit"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
