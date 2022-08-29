import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:localstore/localstore.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final pathName = await _localPath;
  return File('$pathName/notifOption.txt');
}

Future<File> writeContent(String id, bool choice) async {
  final file = await _localFile;
  final fileData = "$id,$choice~";
  return file.writeAsString(fileData);
}

Future<String> readcontent() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    return 'There was an issue reading the notifs';
  }
}

getData(String id) async {
  final item = await db.collection('notifOption').doc(id).get();
  return item;
}

class NotifSetting {
  final String id;
  final bool choice;
  NotifSetting({required this.id, required this.choice});

  Map<String, dynamic> toMap() {
    return {'id': id, 'choice': choice};
  }

  factory NotifSetting.fromMap(Map<String, dynamic> map) {
    return NotifSetting(
      id: map['id'],
      choice: map['choice'],
    );
  }
}

extension Extnotifs on NotifSetting {
  Future save() async {
    final db = Localstore.instance;
    return db.collection('notifOption').doc(id).set(toMap());
  }

  Future delete() async {
    final db = Localstore.instance;
    return db.collection('notifOption').doc(id).delete();
  }
}

final db = Localstore.instance;
void writeData(String id, String id2) {
  final id = db.collection('notifOption').doc().id;
  db.collection('notifOption').doc(id).set({'id': id, 'id2': id2});
}
