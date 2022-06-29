import 'package:flutter/cupertino.dart';
import 'package:reminder_app/models/note_data_store.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:reminder_app/Screens/all_notes.dart' as allNotes;
import 'package:reminder_app/screens/all_notes.dart';
import 'package:reminder_app/screens/checkbox.dart';

class NotesOperation extends ChangeNotifier {
  final List<Notes> _notes = <Notes>[];

  void addNewNote(String id, String title, String data, String date,
      String time, String priority, String color) {
    Notes note = Notes(
        id: id,
        title: title,
        data: data,
        date: date,
        time: time,
        priority: priority,
        color: color,
        done: false);
    //allNotes.searchResults.add(note);
    note.save();
    count.channelCounter++;
    _notes.add(note);
    //allNotes.uncompleted.add(note);
    notifyListeners();
  }

  void deleteNote(Notes note) {
    _notes.remove(note);
    note.delete();
    notifyListeners();
  }
}
