import 'package:flutter/cupertino.dart';
import 'package:reminder_app/models/note_data_store.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:reminder_app/Screens/all_notes.dart' as allNotes;

class NotesOperation extends ChangeNotifier {
  final List<Notes> _notes = <Notes>[];
  final _items = <String, store.Notes>{};

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
// void addToCal() {
// if (dCont.text.isEmpty && cCont.text.isEmpty) {
//       return;
//     } else if (cCont.text.isNotEmpty && dCont.text.isNotEmpty ) {
//       return;
//     } else {
      
//     }
// }

