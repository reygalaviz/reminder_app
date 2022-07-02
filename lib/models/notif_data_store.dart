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
  return File('$pathName/notifs.txt');
}

Future<File> writeContent(String id, String id2) async {
  final file = await _localFile;
  final fileData = "$id,$id2~";
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
  final item = await db.collection('notifs').doc(id).get();
  return item;
}

class Notifs {
  final String id;
  String id2;
  Notifs({required this.id, required this.id2});

  Map<String, dynamic> toMap() {
    return {'id': id, 'id2': id2};
  }

  factory Notifs.fromMap(Map<String, dynamic> map) {
    return Notifs(
      id: map['id'],
      id2: map['id2'],
    );
  }
}

// int getHashCode(DateTime key) {
//   return key.day * 1000000 + key.month * 10000 + key.year;
// }

// final kEvents = LinkedHashMap<DateTime, List<Notifs>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// );

extension Extnotifs on Notifs {
  Future save() async {
    final db = Localstore.instance;
    return db.collection('notifs').doc(id).set(toMap());
  }

  Future delete() async {
    final db = Localstore.instance;
    return db.collection('notifs').doc(id).delete();
  }
}

final db = Localstore.instance;
void writeData(String id, String id2) {
  final id = db.collection('notifs').doc().id;
  db.collection('notifs').doc(id).set({'id': id, 'id2': id2});
}
