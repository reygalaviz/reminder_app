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
    return Material(
      child: LayoutBuilder(
          builder: (context, constraints) => Column(
                children: [
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
              )),
    );
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
