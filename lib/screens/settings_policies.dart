import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SettingsPolicies extends StatelessWidget {
  SettingsPolicies({super.key, required this.mdFileName})
      : assert(mdFileName.contains('.md'),
            'The file must contain the .md extension');

  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Column(
              children: [
                Expanded(
                    child: FutureBuilder(
                        future: rootBundle.loadString('assets/$mdFileName'),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          return Markdown(data: (snapshot.data ?? ''));
                        }))
              ],
            ));
  }
}
