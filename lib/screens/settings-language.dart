import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reminder_app/screens/settings.dart';

class SettingsLanguage extends StatefulWidget {
  const SettingsLanguage({Key? key}) : super(key: key);

  @override
  State<SettingsLanguage> createState() => _SettingsLanguageState();
}

class _SettingsLanguageState extends State<SettingsLanguage> {
  bool? _isChecked = false;
  List<String> languages = [
    'English',
    'Spanish',
    'French',
    'Russian',
    'Arabic',
    'Portuguese',
    'Chinese',
    'German',
    'Hindi',
    'Japanese',
    'Bengali',
    'Korean',
    'Italian',
    'Urdu',
    'Tamil',
    'Telugu',
    'Vietnamese',
    'Marathi',
    'Punjabi',
    'Turkish',
    'Indonesian',
    'Gujarati',
    'Javanese',
    'Polish'
  ];
  List<String> _checkedLang = [];
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
                        'Language',
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: languages.length,
                              itemBuilder: (context, index) {
                                return CheckboxListTile(
                                    side: BorderSide(),
                                    value:
                                        _checkedLang.contains(languages[index]),
                                    onChanged: (val) {
                                      _onSelected(val!, languages[index]);
                                    },
                                    title: Text(languages[index]));
                              }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  void _onSelected(bool selected, String lang) {
    if (_checkedLang.isEmpty) {
      setState(() {
        _checkedLang.add(lang);
      });
    } else if (_checkedLang.length == 1) {
      setState(() {
        _checkedLang.removeAt(0);
        _checkedLang.add(lang);
      });
    }
  }
}
