import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reminder_app/screens/settings.dart';

class SettingsSupport extends StatefulWidget {
  const SettingsSupport({Key? key}) : super(key: key);

  @override
  State<SettingsSupport> createState() => _SettingsSupportState();
}

class _SettingsSupportState extends State<SettingsSupport> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => SizedBox(
              height: constraints.maxHeight * .92,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                setState(() {});
                              })),
                      const Text(
                        'Support',
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
                ],
              ),
            ));
  }
}
