import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;
import 'package:reminder_app/main.dart';

String? selectedNotificationPayload;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notifsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('gradient');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              didReceiveLocalNotificationSubject.add(
                ReceivedNotification(
                  id: id,
                  title: title,
                  body: body,
                  payload: payload,
                ),
              );
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await notifsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      openMain(payload: payload);
      //notification tapped logic needs to be implemented still
    });
  }

  void displayNotification({required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        "Test_Channel 1", //Required for Android 8.0 or after
        "Notif Memo", //Required for Android 8.0 or after
        channelDescription:
            "THis is for notifications created by the app", //Required for Android 8.0 or after
        importance: Importance.max,
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      presentAlert:
          false, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentSound:
          true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      sound: null, // Specifics the file path to play (only from iOS 10 onwards)
      badgeNumber: 15, // The application's icon badge number
      //attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
      subtitle: "Your note", //Secondary description  (only from iOS 10 onwards)
      //threadIdentifier: String? (only from iOS 10 onwards)
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await notifsPlugin.show(
      0,
      'Reminder:',
      body,
      platformChannelSpecifics,
      payload: body,
    );
  }
}
