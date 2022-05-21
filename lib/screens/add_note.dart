import 'package:flutter/material.dart';
import 'package:reminder_app/responsive/responsive_helper.dart';
import 'package:reminder_app/responsive/tablet_body.dart';
import 'package:reminder_app/responsive/mobile_body.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveWidget(mobile: MobileBody(), tablet: TabletBody()),
    );
  }
}
