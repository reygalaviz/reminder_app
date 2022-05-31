import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:reminder_app/models/color_data.dart';
import 'package:reminder_app/models/note_data.dart';
import 'package:reminder_app/models/datetime_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:reminder_app/screens/add_note.dart';
import 'package:reminder_app/screens/all_notes.dart';
import 'package:reminder_app/screens/calendar.dart';
import 'package:reminder_app/controllers/Notifications.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/screens/settings.dart';
import 'package:reminder_app/main.dart' as count;
import 'package:reminder_app/themes/theme_shared_prefs.dart';
import 'package:reminder_app/themes/theme_model.dart';
import 'package:switcher_button/switcher_button.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String body = "";

  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel themeNotifier, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            themeNotifier.isDark ? 'Dark Theme' : 'Light Theme',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          actions: [
            SwitcherButton(
              value: themeNotifier.isDark ? false : true,
              onChange: (value) {
                themeNotifier.isDark
                    ? themeNotifier.isDark = false
                    : themeNotifier.isDark = true;
              },
            ),
            SizedBox(width: 20),
            IconButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => showSettingsModal(),
                icon: Icon(Icons.settings)),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            AllNotes(),
            Calendar(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              backgroundColor: Theme.of(context).backgroundColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.house,
                      color: Theme.of(context).primaryColor),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.calendar,
                      color: Theme.of(context).primaryColor),
                  label: 'Calendar',
                ),
              ],
              currentIndex: _selectedIndex,
              // selectedItemColor: Colors.white,
              // unselectedItemColor: Color.fromARGB(255, 122, 122, 122),
              onTap: onTapped,
            ),
          ),
        ),
      ),
    );
  }

  void showSettingsModal() {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        builder: (context) {
          return SettingsTab();
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
          return AddNote();
        });
  }
}
