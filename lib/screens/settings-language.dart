import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:reminder_app/languages/en_US.dart';
import 'package:reminder_app/languages/es_SPA.dart';
import 'package:reminder_app/screens/settings.dart';

class SettingsLanguage extends StatefulWidget {
  const SettingsLanguage({Key? key}) : super(key: key);

  @override
  State<SettingsLanguage> createState() => _SettingsLanguageState();
}

class _SettingsLanguageState extends State<SettingsLanguage> {
  // bool? _isChecked = false;
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
                              itemCount: LocalizationService.langs.length,
                              itemBuilder: (context, index) {
                                return CheckboxListTile(
                                    value: _checkedLang.contains(
                                        LocalizationService.langs[index]),
                                    onChanged: (val) {
                                      _onSelected(val!,
                                          LocalizationService.langs[index]);
                                      setState(() {
                                        LocalizationService().changeLocale(
                                            LocalizationService.langs[index]);
                                      });
                                    },
                                    title:
                                        Text(LocalizationService.langs[index]));
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

class LocalizationService extends Translations {
  static final local = Locale('en', 'US');
  static final fallBackLocale = Locale('en', 'US');

  static final langs = ['English', 'Spanish'];
  static final locales = [
    Locale('en', 'US'),
    Locale('es', 'SPA'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'es_SPA': esSPA,
      };

  void changeLocale(String lang) {
    final locale = getLocaleFromLanguage(lang);
    Get.updateLocale(locale!);
  }

  Locale? getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) {
        return locales[i];
      }
    }
    return Get.locale;
  }
}
