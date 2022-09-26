import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:reminder_app/main.dart';
import 'package:reminder_app/screens/settings-language.dart';
import 'package:reminder_app/screens/settings_faq.dart';
import 'package:reminder_app/screens/settings_policies.dart';
import 'package:reminder_app/screens/settings_sec.dart';
import 'package:reminder_app/screens/settings_suggest.dart';
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
  bool ball = false;

  @override
  void initState() {
    if (notifSet.isNotEmpty) {
      notifChoice = notifSet[0].choice;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext rootContext) {
    if (notifSet.isNotEmpty) {
      ball = notifSet[0].choice;
    }
    return Material(
      child: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
              builder: (context2) => Builder(
                  builder: (context) => CupertinoPageScaffold(
                      navigationBar: CupertinoNavigationBar(
                        backgroundColor: Theme.of(context).backgroundColor,
                        middle: Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor),
                        ),
                        trailing: TextButton(
                          child: const Text(
                            'Done',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                          onPressed: () => Navigator.of(rootContext).pop(),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView(
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Dark Theme',
                                        style: TextStyle(
                                            fontSize: 20,
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
                                  const SizedBox(height: 20),
                                  Row(
                                    children: const [
                                      Text(
                                        'Notifications',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    height: 30.0,
                                    thickness: 1.0,
                                    endIndent: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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

                                              NotifSetting n = NotifSetting(
                                                  id: id0, choice: value);

                                              n.save();
                                              notifSet.add(n);

                                              setState(() {
                                                notifChoice = value;
                                                ball = value;
                                              });
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    height: 30.0,
                                    thickness: 1.0,
                                    endIndent: 5.0,
                                  ),
                                  buildHelpSupportOption(
                                      context, 'Contact Support'),
                                  buildHelpSuggestOption(
                                      context, 'Suggest a Feature'),
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
                                  buildAboutPrivOption(
                                      context, 'Privacy Policy'),
                                  buildAboutTermsOption(
                                      context, 'Terms of Service'),
                                  buildAboutAckOption(
                                      context, 'Acknowledgments'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))))),
    );
  }

  // GestureDetector buildGeneralLanguageOption(
  //     BuildContext context, String title) {
  //   return GestureDetector(
  //     behavior: HitTestBehavior.translucent,
  //     onTap: () {
  //       setState(() {
  //         Navigator.of(context).push(MaterialPageRoute(
  //             builder: (context) => CupertinoPageScaffold(
  //                 navigationBar: CupertinoNavigationBar(
  //                   backgroundColor: Theme.of(context).backgroundColor,
  //                   middle: Text(
  //                     'language'.tr,
  //                     style: TextStyle(
  //                         color: Theme.of(context).primaryColor, fontSize: 20),
  //                   ),
  //                 ),
  //                 child: SettingsLanguage())));
  //       });
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 10),
  //       child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: <Widget>[
  //             Text(
  //               title,
  //               style: TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w400,
  //                   color: Theme.of(context).primaryColor),
  //             ),
  //             const Icon(
  //               Icons.arrow_forward_ios,
  //               color: Colors.grey,
  //               size: 20,
  //             )
  //           ]),
  //     ),
  //   );
  // }

  GestureDetector buildHelpSupportOption(BuildContext context, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                      middle: Text(
                        'Contact Support',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20),
                      ),
                      backgroundColor: Theme.of(context).backgroundColor),
                  child: SettingsSupport())));
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

  // GestureDetector buildHelpFAQOption(BuildContext context, String title) {
  //   return GestureDetector(
  //     behavior: HitTestBehavior.translucent,
  //     onTap: () {
  //       setState(() {
  //         Navigator.of(context).push(MaterialPageRoute(
  //             builder: (context) => CupertinoPageScaffold(
  //                 navigationBar: CupertinoNavigationBar(
  //                     middle: Text(
  //                       'FAQ',
  //                       style: TextStyle(
  //                           color: Theme.of(context).primaryColor,
  //                           fontSize: 20),
  //                     ),
  //                     backgroundColor: Theme.of(context).backgroundColor),
  //                 child: SettingsFAQ())));
  //       });
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 10),
  //       child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: <Widget>[
  //             Text(
  //               title,
  //               style: TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w400,
  //                   color: Theme.of(context).primaryColor),
  //             ),
  //             const Icon(
  //               Icons.arrow_forward_ios,
  //               color: Colors.grey,
  //               size: 20,
  //             )
  //           ]),
  //     ),
  //   );
  // }

  GestureDetector buildHelpSuggestOption(BuildContext context, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                      middle: Text(
                        'Suggest a Feature',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20),
                      ),
                      backgroundColor: Theme.of(context).backgroundColor),
                  child: SettingsSuggest())));
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

  GestureDetector buildAboutPrivOption(BuildContext context, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                      middle: Text(
                        'Privacy Policy',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20),
                      ),
                      backgroundColor: Theme.of(context).backgroundColor),
                  child: SettingsPolicies(
                    mdFileName: 'privacy_policy.md',
                  ))));
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

  GestureDetector buildAboutSecOption(BuildContext context, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                      middle: Text(
                        'Security Policy',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20),
                      ),
                      backgroundColor: Theme.of(context).backgroundColor),
                  child: SettingsSecurity())));
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

  GestureDetector buildAboutTermsOption(BuildContext context, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                      middle: Text(
                        'Terms of Service',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20),
                      ),
                      backgroundColor: Theme.of(context).backgroundColor),
                  child: SettingsPolicies(
                    mdFileName: 'terms_conditions.md',
                  ))));
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

  GestureDetector buildAboutAckOption(BuildContext context, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                      middle: Text(
                        'Acknowledgments',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20),
                      ),
                      backgroundColor: Theme.of(context).backgroundColor),
                  child: SettingsPolicies(
                    mdFileName: 'acknowledgments.md',
                  ))));
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
}
