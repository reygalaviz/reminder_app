import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/controllers/notifications.dart';
import 'package:localstore/localstore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:reminder_app/screens/add_note.dart';
import 'package:reminder_app/screens/all_notes.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/screens/search_notes.dart';
import 'package:reminder_app/screens/settings.dart';
import 'package:reminder_app/themes/theme_model.dart';
import 'package:reminder_app/screens/table_calendar.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;
import 'package:reminder_app/models/notif_option.dart';
import 'package:reminder_app/models/repeat_store.dart';
import 'package:reminder_app/models/notif_data_store.dart';
import '../models/note_data_store.dart';
import 'package:reminder_app/main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String body = "";
  DateFormat format2 = DateFormat("yyyy-MM-dd");
  final _db = Localstore.instance;
  PageController pageController = PageController();
  int _selectedIndex = 0;

  //static List<Notes> itemList = [];
  final db = Localstore.instance;
  final items = <String, store.Notes>{};

  StreamSubscription<Map<String, dynamic>>? _subscription;
  // @override
  // void initState() {
  //super.initState();

  //   _db.collection('notes').get().then((value) {
  //     _subscription = _db.collection('notes').stream.listen((event) {
  //       final item = store.Notes.fromMap(event);
  //       if (!notes.contains(item.id)) {
  //         notes.add(item.id);
  //         searchResults.add(item);

  //         if (item.done == false) {
  //           if (uncompleted.indexWhere((element) => element.id == item.id) ==
  //               -1) {
  //             uncompleted.add(item);
  //           }
  //         }
  //       }
  //       DateTime dateOfNote = DateTime.parse(item.date);
  //       if (items1.indexWhere((element) => element.id == item.id) == -1) {
  //         items1.add(item);
  //       }
  //       bool biff = done.contains(dateOfNote);
  //       if (biff == false) {
  //         done.add(dateOfNote);
  //       }

  //       items.putIfAbsent(item.id, () => item);
  //     });
  //   });

  //   _db
  //       .collection("notifs")
  //       .doc()
  //       .get()
  //       .then((value) => _db.collection('notifs').stream.listen((event) {
  //             final item = Notifs.fromMap(event);
  //             notifs.putIfAbsent(item.id, () => item);
  //           }));

  //   _db
  //       .collection('notifOption')
  //       .get()
  //       .then((value) => _db.collection("notifOption").stream.listen((event) {
  //             final item = NotifSetting.fromMap(event);
  //             notifSet.add(item);
  //           }));
  //   _db.collection('repeat').get().then((value) =>
  //       _subscription = _db.collection('repeat').stream.listen((event) {
  //         final item = Repeat.fromMap(event);
  //         items3.putIfAbsent(item.id, () => item);
  //       }));
  // }

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (pageController.hasClients) {
        pageController.jumpToPage(index);
      }
    });
  }

  DateTime timeConvert(String normTime) {
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);
    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return DateTime(2022, 1, 1, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Te.',
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 25),
        ),
        actions: [
          SearchNote(
            key: UniqueKey(),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () => showSettingsModal(),
              icon: const Icon(FontAwesomeIcons.gear)),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const AllNotes(),
          Table_Calendar(
            key: UniqueKey(),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        onPressed: () {
          return showTextboxKeyboard();
        },
        child: const Icon(FontAwesomeIcons.plus),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            //change nav bar top radius
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0.0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                activeIcon: Icon(
                  FontAwesomeIcons.house,
                  color: Theme.of(context).primaryColor,
                ),
                icon: const Icon(FontAwesomeIcons.house, color: Colors.grey),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  FontAwesomeIcons.calendar,
                  color: Theme.of(context).primaryColor,
                ),
                icon: const Icon(FontAwesomeIcons.calendar, color: Colors.grey),
                label: 'Calendar',
              ),
            ],
            currentIndex: _selectedIndex,
            // selectedItemColor: Colors.white,
            // unselectedItemColor: Colors.black,
            onTap: onTapped,
          ),
        ),
      ),
    );
  }

  void showSettingsModal() async {
    showCupertinoModalBottomSheet(
        context: context,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (context) {
          return SettingsTab(key: UniqueKey());
        });
  }

  //keyboard textfield attachment
  void showTextboxKeyboard() {
    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        context: context,
        builder: (context) {
          return const AddNote();
        });
  }
}

class Home2 extends StatefulWidget {
  const Home2({Key? key, required this.boo}) : super(key: key);
  final bool boo;
  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  String body = "";

  int _selectedIndex = 1;
  int _selectedIndex2 = 0;
  PageController pageController2 = PageController();

  void onTapped(int index) {
    setState(() {
      if (_selectedIndex2 == 1) {
        index = 0;
        _selectedIndex2 = 0;
        _selectedIndex = 1;
      } else {
        index = 1;
        _selectedIndex2 = 1;
        _selectedIndex = 0;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (pageController2.hasClients) {
        pageController2.jumpToPage(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.boo == true) {
      setState(() {});
    }
    return Consumer(
        builder: (context, ThemeModel themeNotifier, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                title: Text(
                  'RemindMe',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 30),
                ),
                actions: [
                  const SearchNote(),
                  IconButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () => showSettingsModal(),
                      icon: const Icon(FontAwesomeIcons.gear)),
                ],
              ),
              resizeToAvoidBottomInset: false,
              body: PageView(
                controller: pageController2,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Table_Calendar(
                    key: UniqueKey(),
                  ),
                  const AllNotes(),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                elevation: 2,
                onPressed: () {
                  return showTextboxKeyboard();
                },
                child: const Icon(Icons.add),
              ),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    //change nav bar top radius
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    elevation: 0.0,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    backgroundColor: Theme.of(context)
                        .bottomNavigationBarTheme
                        .backgroundColor,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        activeIcon: Icon(
                          FontAwesomeIcons.house,
                          color: Theme.of(context).primaryColor,
                        ),
                        icon: const Icon(FontAwesomeIcons.house,
                            color: Colors.grey),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        activeIcon: Icon(
                          FontAwesomeIcons.calendar,
                          color: Theme.of(context).primaryColor,
                        ),
                        icon: const Icon(FontAwesomeIcons.calendar,
                            color: Colors.grey),
                        label: 'Calendar',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    // selectedItemColor: Colors.white,
                    // unselectedItemColor: Colors.black,
                    onTap: onTapped,
                  ),
                ),
              ),
            ));
  }

  void showSettingsModal() {
    showCupertinoModalBottomSheet(
        expand: true,
        context: context,
        enableDrag: true,
        // shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: col,
        builder: (context) {
          return SettingsTab(key: UniqueKey());
        });
  }

  //keyboard textfield attachment
  void showTextboxKeyboard() {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        context: context,
        builder: (context) {
          return const AddNote();
        });
  }
}
