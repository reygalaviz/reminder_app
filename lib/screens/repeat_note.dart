import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RepeatNote extends StatefulWidget {
  const RepeatNote({Key? key}) : super(key: key);

  @override
  State<RepeatNote> createState() => _RepeatNoteState();
}

class _RepeatNoteState extends State<RepeatNote> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Form(
        child: SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight * .4,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: constraints.maxHeight * .35,
                  child: Flexible(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.repeat),
                          title: const Text('Hourly'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.repeat),
                          title: const Text('Daily'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.repeat),
                          title: const Text('Weekly'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.repeat),
                          title: const Text('Monthly'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.repeat),
                          title: const Text('Yearly'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(FontAwesomeIcons.repeat),
                          title: const Text('Custom'),
                          trailing: IconButton(
                            icon: const Icon(FontAwesomeIcons.arrowRight),
                            onPressed: () {},
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
