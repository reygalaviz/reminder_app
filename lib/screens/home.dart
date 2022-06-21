import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
//import 'package:reminder_app/models/datetime_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localstore/localstore.dart';
import 'package:reminder_app/models/notes_operation.dart';
import 'package:reminder_app/screens/add_note.dart';
import 'package:reminder_app/screens/all_notes.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/screens/settings.dart';
import 'package:reminder_app/themes/theme_model.dart';
import 'package:reminder_app/screens/table_calendar.dart';
import 'package:reminder_app/screens/clean_calendar.dart';
import 'package:reminder_app/models/note_data_store.dart' as store;

import '../models/note_data_store.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String body = "";

  int _selectedIndex = 0;
  final _db = Localstore.instance;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'RemindMe',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: [
          IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(),
                );
              },
              icon: const Icon(FontAwesomeIcons.magnifyingGlass)),
          const SizedBox(width: 20),
          IconButton(
              color: Theme.of(context).primaryColor,
              onPressed: () => showSettingsModal(),
              icon: const Icon(FontAwesomeIcons.gear)),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          AllNotes(),
          Table_Calendar(),
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

  void showSettingsModal() {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.grey[800],
        builder: (context) {
          return const SettingsTab();
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

//search functions
class MySearchDelegate extends SearchDelegate {
  final _items = <String, store.Notes>{};

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null), //close search bar
      icon: const Icon(FontAwesomeIcons.arrowLeft));

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget buildResults(BuildContext context) => Center();

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

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

    pageController2.jumpToPage(index);
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
            IconButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: MySearchDelegate(),
                  );
                },
                icon: const Icon(FontAwesomeIcons.magnifyingGlass)),
            const SizedBox(width: 20),
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
          children: const [
            Table_Calendar(),
            AllNotes(),
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
        backgroundColor: Colors.white,
        builder: (context) {
          return const SettingsTab();
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
