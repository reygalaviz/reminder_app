import 'package:flutter/material.dart';
import 'package:reminder_app/themes/theme_model.dart';
import 'package:provider/provider.dart';
//import '../models/notes_operation.dart';
import '../themes/theme_model.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  Widget buildDarkMode() {
    return Consumer(
        builder: (context, ThemeModel themeNotifier, child) => SwitchListTile(
            title: const Text('Change Theme'),
            value: themeNotifier.isDark,
            onChanged: (value) {
              themeNotifier.isDark = value;
            }));
  }

  Widget donate() {
    return TextButton(onPressed: () {}, child: Container());
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
                  donate()
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
