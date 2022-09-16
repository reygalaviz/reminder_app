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

  Future<dynamic> loadAsset() async {
    return await rootBundle.loadString('assets/$mdFileName');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Column(
              children: [
                Expanded(
                    child: FutureBuilder(
                        future: loadAsset(),
                        builder: (context, AsyncSnapshot<dynamic> snapshot) {
                          return Markdown(data: (snapshot.data ?? ''));
                        }))
              ],
            ));
  }
}
