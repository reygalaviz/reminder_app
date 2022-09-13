import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingsFAQ extends StatefulWidget {
  const SettingsFAQ({super.key});

  @override
  State<SettingsFAQ> createState() => _SettingsFAQState();
}

class _SettingsFAQState extends State<SettingsFAQ> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: LayoutBuilder(
            builder: (context, constraints) => Container(
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                children: <Widget>[
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Text(
                                        'Creating Reminders',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: const Text('Adding a Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: const [
                                            Text(
                                              'Adding a New Reminder\n\nTo create a new reminder:\n Simply press the +',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: Text(
                                        'Setting Date and Time for Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              'Adding a New Reminder',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: Text('Setting Color for Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('sdf'),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title:
                                        Text('Setting Recurrent for Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text(
                                                'Setting Recurrent for Reminder'),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Text(
                                        'Editing Reminders',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: Text('Editing a Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('Adding a New Reminder'),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: Text('Adding a Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('Adding a New Reminder'),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: Text('Adding a Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('Adding a New Reminder'),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: Text('Adding a Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('Adding a New Reminder'),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Text(
                                        'Calendar',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: Text('Adding a Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('Adding a New Reminder'),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: Text('Adding a Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('Adding a New Reminder'),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: Text('Adding a Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('Adding a New Reminder'),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.only(left: 0),
                                    iconColor: Theme.of(context).primaryColor,
                                    collapsedIconColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).primaryColor,
                                    collapsedTextColor:
                                        Theme.of(context).primaryColor,
                                    title: Text('Adding a Reminder'),
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('Adding a New Reminder'),
                                            const SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )))
                    ],
                  ),
                )));
  }
}
