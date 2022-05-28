import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              height: constraints.maxHeight * .92,
              child: Column(
                children: [
                  ListTile(
                    title: Center(
                        child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                  SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey[400],
                      width: constraints.maxWidth * .9,
                      height: constraints.maxHeight * .2,
                      child: Column(
                        children: [
                          TextButton(
                              onPressed: () {}, child: Text('Notifications')),
                          TextButton(onPressed: () {}, child: Text('Calendar')),
                          TextButton(
                              onPressed: () {}, child: Text('Notifications')),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey[400],
                      width: constraints.maxWidth * .9,
                      height: constraints.maxHeight * .2,
                      child: Column(),
                    ),
                  ),
                  SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey[400],
                      width: constraints.maxWidth * .9,
                      height: constraints.maxHeight * .2,
                    ),
                  ),
                ],
              ),
            ));
  }
}
