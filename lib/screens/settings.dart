import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/main.dart';
import 'package:reminder_app/screens/settings-language.dart';
import 'package:reminder_app/themes/theme_model.dart';
import 'package:provider/provider.dart';
import '../themes/theme_model.dart';
import 'package:reminder_app/models/notif_option.dart';
import 'package:reminder_app/screens/settings-support.dart';
import 'all_notes.dart';
import 'package:localstore/localstore.dart';

bool ball = false;
Color col = Colors.white;

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  int currentview = 0;
  late List<Widget> pages;

  @override
  void initState() {
    if (notifSet.isNotEmpty) {
      notifChoice = notifSet[0].choice;
    }

    pages = [
      // settings(),
      const SettingsLanguage(),
      const SettingsSupport(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (notifSet.isNotEmpty) {
      ball = notifSet[0].choice;
    }
    return LayoutBuilder(
        builder: (context, constraints) => SizedBox(
            height: constraints.maxHeight * .92,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding:
                            EdgeInsets.only(right: constraints.maxWidth * .03),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    )
                  ],
                ),
                const Divider(
                  height: 5.0,
                  thickness: 1.0,
                ),
                Expanded(
                  child: SizedBox(
                    height: constraints.maxHeight * 1,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Dark Theme',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Transform.scale(
                                  scale: .7,
                                  child: Consumer(
                                    builder: (context, ThemeModel themeNotifier,
                                            child) =>
                                        CupertinoSwitch(
                                            value: themeNotifier.isDark,
                                            onChanged: (bool value) {
                                              setState(() {});
                                              themeNotifier.isDark =
                                                  !themeNotifier.isDark;
                                            }),
                                  ))
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Text(
                                'General',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 30.0,
                            thickness: 1.0,
                            endIndent: 5.0,
                          ),
                          buildGeneralLanguageOption(
                            context,
                            'Language',
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Text(
                                'Notifications',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 30.0,
                            thickness: 1.0,
                            endIndent: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Enable/Disable'),
                              Transform.scale(
                                scale: .7,
                                child: CupertinoSwitch(
                                    value: ball,
                                    onChanged: (bool value) {
                                      String id0 = Localstore.instance
                                          .collection("notifOption")
                                          .doc()
                                          .id;

                                      if (notifSet.isNotEmpty) {
                                        NotifSetting no = notifSet[0];
                                        no.delete();
                                        notifSet.clear();
                                      }

                                      NotifSetting n =
                                          NotifSetting(id: id0, choice: value);

                                      n.save();
                                      notifSet.add(n);

                                      setState(() {
                                        notifChoice = value;
                                        ball = value;
                                      });

                                      print(ball);
                                    }),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Text(
                                'Help and Feedback',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 30.0,
                            thickness: 1.0,
                            endIndent: 5.0,
                          ),
                          buildHelpSupportOption(context, 'Support'),
                          buildHelpFAQOption(context, 'FAQ'),
                          buildHelpSuggestOption(context, 'Suggest a Feature'),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Text(
                                'About',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 30.0,
                            thickness: 1.0,
                            endIndent: 5.0,
                          ),
                          buildAboutPrivOption(context, 'Privacy Policy'),
                          buildAboutSecOption(context, 'Security Policy'),
                          buildAboutTermsOption(context, 'Terms of Service'),
                          buildAboutAckOption(context, 'Acknowledgments'),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  GestureDetector buildGeneralLanguageOption(
      BuildContext context, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          // currentview = 1;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              )
            ]),
      ),
    );
  }

  GestureDetector buildHelpSupportOption(BuildContext context, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          // currentview = 2;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              )
            ]),
      ),
    );
  }

  GestureDetector buildHelpFAQOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              )
            ]),
      ),
    );
  }

  GestureDetector buildHelpSuggestOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              )
            ]),
      ),
    );
  }

  GestureDetector buildAboutOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              )
            ]),
      ),
    );
  }

  GestureDetector buildAboutPrivOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              )
            ]),
      ),
    );
  }

  GestureDetector buildAboutSecOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              )
            ]),
      ),
    );
  }

  GestureDetector buildAboutTermsOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              )
            ]),
      ),
    );
  }

  GestureDetector buildAboutAckOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColor),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              )
            ]),
      ),
    );
  }
}
