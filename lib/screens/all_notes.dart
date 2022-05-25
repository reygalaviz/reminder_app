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

String body = "";

class _AllNotesState extends State<AllNotes> {
  //keyboard textfield attachment
  void _showModal() async {
    await showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            reverse: true,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) => body = value,
                        autofocus: true,
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          print(body);
                          NotificationService().displayNotification(body: body);
                        },
                        child: Text("Submit"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Text(
        'All Notes',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        onPressed: () {
          return _showModal();
        },
      ),
    );
  }
}
