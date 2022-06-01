import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final pathName = await _localPath;
  return File('$pathName/notes.txt');
}

Future<File> writeContent(int id, String title, String data, DateTime date,
    String priority, Color color) async {
  final file = await _localFile;
  final fileData = "$id,$title,$data,$date,$priority,$color~";
  return file.writeAsString(fileData);
}

Future<String> readcontent() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    return 'There was an issue reading the notes';
  }
}

class Notes {
  final String id;
  String title;
  String data;
  String date;
  String priority;
  String color;
  Notes(
      {required this.id,
      required this.title,
      required this.data,
      required this.date,
      required this.priority,
      required this.color});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'data': data,
      'date': date,
      'priority': priority,
      'color': color
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
        id: map['id'],
        title: map['title'],
        data: map['data'],
        date: map['date'],
        priority: map["priority"],
        color: map["color"]);
  }
}

extension ExtNotes on Notes {
  Future save() async {
    final _db = Localstore.instance;
    return _db.collection('notes').doc(id).set(toMap());
  }

  Future delete() async {
    final _db = Localstore.instance;
    return _db.collection('notes').doc(id).delete();
  }
}

final db = Localstore.instance;
void writeData(
    String title, String data, String date, String priority, String color) {
  final id = db.collection('notes').doc().id;
  db.collection('notes').doc(id).set({
    'title': title,
    'data': data,
    'datetime': date,
    'priority': priority,
    'color': color
  });
}
