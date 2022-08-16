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
  return File('$pathName/repeat.txt');
}

Future<File> writeContent(String id, String option) async {
  final file = await _localFile;
  final fileData = "$id,$option~";
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
  final item = await db.collection('repeat').doc(id).get();
  return item;
}

class Repeat {
  final String id;
  String option;
  Repeat({required this.id, required this.option});

  Map<String, dynamic> toMap() {
    return {'id': id, 'option': option};
  }

  factory Repeat.fromMap(Map<String, dynamic> map) {
    return Repeat(
      id: map['id'],
      option: map['option'],
    );
  }
}

extension ExtRepeat on Repeat {
  Future save() async {
    final db = Localstore.instance;
    return db.collection('repeat').doc(id).set(toMap());
  }

  Future delete() async {
    final db = Localstore.instance;
    return db.collection('repeat').doc(id).delete();
  }
}

final db = Localstore.instance;
void writeData(String id, String option) {
  final id3 = db.collection('repeat').doc().id;
  db.collection('repeat').doc(id3).set({'id': id, 'option': option});
}
