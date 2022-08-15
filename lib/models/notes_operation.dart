import 'package:flutter/cupertino.dart';
import 'package:reminder_app/models/note_data_store.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:reminder_app/screens/all_notes.dart';
import 'package:reminder_app/main.dart';
import 'package:reminder_app/screens/table_calendar.dart';

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
    items.putIfAbsent(note.id, () => note);
    notes.add(note.id);
    count.channelCounter++;
    _notes.add(note);
    searchResults.add(note);
    uncompleted.add(note);
    //items.putIfAbsent(id, () => note);
    items1.add(note);
    //allNotes.uncompleted.add(note);
    notifyListeners();
  }

  void deleteNote(Notes note) {
    _notes.remove(note);
    note.delete();
    notifyListeners();
  }
}
