import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reminder_app/screens/add_note.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_app/controllers/Notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

String url = "gradient.jpg";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();
  await NotificationService().init();
  runApp(const MaterialApp(
    home: AddNote(),
    debugShowCheckedModeBanner: false,
  ));
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
