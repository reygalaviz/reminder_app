import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:reminder_app/responsive/responsive_helper.dart';
import 'package:reminder_app/screens/color_palette.dart';

class MobileBody extends StatefulWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  //urgency button variable
  bool click = true;
  //form validation
  final formKey = GlobalKey<FormState>(); //key for form

  //color picker
  Color color = Color.fromARGB(255, 215, 205, 119);
  Widget buildColorPicker() => Padding(
        padding: const EdgeInsets.only(top: 60),
        child: BlockPicker(
          pickerColor: color,
          availableColors: [
            Colors.green,
            Colors.orange,
            Colors.blue,
            Colors.pink,
            Colors.cyanAccent,
            Colors.purple,
            Colors.amber,
            Colors.teal,
            Colors.green,
            Colors.orange,
            Colors.blue,
            Colors.pink,
            Colors.cyanAccent,
            Colors.purple,
            Colors.amber,
            Colors.teal,
          ],
          onColorChanged: (color) => setState(() => this.color = color),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1507499739999-097706ad8914?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=60&raw_url=true&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHNwYWNlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 5.0),
                  Container(
                    margin: EdgeInsets.fromLTRB(constraints.maxWidth * .05, 0,
                        constraints.maxWidth * .05, 0),
                    decoration: BoxDecoration(
                      color: color, //change color for urgency
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                        hintText: 'Enter Reminder',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter valid reminder';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {},
                        color: Colors.transparent,
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              children: [
                                buildColorPicker(),
                              ],
                            );
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0, primary: Colors.transparent),
                        child: Text(
                          'Pick Color',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
