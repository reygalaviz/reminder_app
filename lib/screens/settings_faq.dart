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
        child: LayoutBuilder(builder: (context, constraints) => Column()));
  }
}
