import 'dart:async';
import 'dart:math';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/models/notes_operation.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:reminder_app/themes/theme_model.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reminder_app/controllers/notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
//import 'package:reminder_app/themes/theme_shared_prefs.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:intl/date_symbol_data_local.dart';
import 'package:reminder_app/models/notif_option.dart';
import 'package:reminder_app/models/note_data_store.dart';
import 'package:reminder_app/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

int channelCounter = 0;
bool notifChoice = false;
List<Notes> searchResults = <Notes>[];
List<String> notes = <String>[];
List<Notes> uncompleted = <Notes>[];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();
  await NotificationService().init();
  var items = await store.db.collection('notes').get();
  try {
    var nChoice = await store.db.collection('notifSetting').doc('1').get();
  } catch (e) {
    NotifSetting n = NotifSetting(id: '1', choice: notifChoice);
    n.save();
  }
  if (items != null) {
    channelCounter = items.length;
  }
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

Future<void> openMain({required String? payload}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureLocalTimeZone();
  await NotificationService().init();
  runApp(const MyApp());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<NotesOperation>(
              create: (_) => NotesOperation()),
          ChangeNotifierProvider(
            create: (_) => ThemeModel(),
          )
        ],
        child: Consumer(
          builder: (context, ThemeModel themeModel, child) => MaterialApp(
            supportedLocales: L10n.all,
            builder: (context, child) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, child!),
              maxWidth: 1200,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(450, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
            ),
            theme: themeModel.isDark
                ? ThemeModel.darkTheme
                : ThemeModel.lightTheme,
            home: const Home(),
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}
