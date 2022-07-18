import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reminder_app/main.dart';
import 'package:reminder_app/models/color_data.dart';
import 'package:reminder_app/themes/theme_model.dart';
import 'package:provider/provider.dart';
//import '../models/notes_operation.dart';
import '../themes/theme_model.dart';
import 'package:reminder_app/models/notif_option.dart';

Color col = Colors.white;

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  Widget donate() {
    return TextButton(onPressed: () {}, child: Container());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => SizedBox(
            height: constraints.maxHeight * .92,
            child: Container(
              color: col,
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
                          padding: EdgeInsets.only(
                              right: constraints.maxWidth * .03),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Transform.scale(
                                    scale: .7,
                                    child: Consumer(
                                      builder: (context,
                                              ThemeModel themeNotifier,
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 30.0,
                              thickness: 1.0,
                              endIndent: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: const [
                                Text(
                                  'Notifications',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 30.0,
                              thickness: 1.0,
                              endIndent: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Enable/Disable'),
                                  // Icon(
                                  //   FontAwesomeIcons.arrowRight,
                                  //   size: 20,
                                  // ),
                                  Transform.scale(
                                    scale: .7,
                                    child: CupertinoSwitch(
                                        value: notifChoice,
                                        onChanged: (bool value) {
                                          setState(() {
                                            notifChoice = !notifChoice;
                                          });

                                          NotifSetting n = NotifSetting(
                                              id: '1', choice: value);

                                          n.save();
                                        }),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: const [
                                Text(
                                  'Help and Feedback',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 30.0,
                              thickness: 1.0,
                              endIndent: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: const [
                                Text(
                                  'About',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 30.0,
                              thickness: 1.0,
                              endIndent: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: constraints.maxWidth * .04),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Option'),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  GestureDetector buildNotificationOption(BuildContext context, String title) {
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
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]),
              ),
              const Icon(
                FontAwesomeIcons.arrowRight,
                color: Colors.grey,
              )
            ]),
      ),
    );
  }
}
