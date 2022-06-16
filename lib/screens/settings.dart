import 'package:flutter/material.dart';
import 'package:reminder_app/themes/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import '../models/notes_operation.dart';
import '../themes/theme_model.dart';

class SettingsTab extends StatelessWidget {
  Widget buildDarkMode() {
    return Consumer(
        builder: (context, ThemeModel themeNotifier, child) => SwitchListTile(
            title: Text('Change Theme'),
            value: themeNotifier.isDark,
            onChanged: (value) {
              themeNotifier.isDark = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => SizedBox(
              height: constraints.maxHeight * .92,
              child: Column(
                children: [
                  ListTile(
                    leading: Text('Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                  const Divider(
                    thickness: 1.0,
                  ),
                  buildDarkMode(),
                  const SizedBox(height: 8),
                ],
              ),
            ));
  }
}

// SwitcherButton(
//                             value: themeNotifier.isDark ? false : true,
//                             onChange: (value) {
//                               themeNotifier.isDark
//                                   ? themeNotifier.isDark = false
//                                   : themeNotifier.isDark = true;
//                             },
//                           ),
