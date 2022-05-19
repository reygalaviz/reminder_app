import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  // This widget is the root of your application.

  //form validation
  final formKey = GlobalKey<FormState>(); //key for form

  //urgency button variable
  bool click = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 215, 205, 119),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: <Widget>[
              //     Container(
              //       margin: const EdgeInsets.all(10.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: <Widget>[
              //           TextButton(
              //               onPressed: () {},
              //               child: const Text(
              //                 'Add note',
              //                 style: TextStyle(color: Colors.white),
              //               ),
              //               style: ButtonStyle(
              //                   backgroundColor: MaterialStateProperty.all(
              //                       Colors.transparent))),
              //           IconButton(
              //             //calendar icon
              //             onPressed: () {},
              //             icon: const Icon(Icons.calendar_month, size: 40),
              //             color: Colors.white,
              //           ),
              //           IconButton(
              //             //settings icon
              //             onPressed: () {},
              //             icon: const Icon(Icons.settings, size: 40),
              //             color: Colors.white,
              //           ),
              //           IconButton(
              //             //urgency icon
              //             onPressed: () {
              //               setState(() {
              //                 click = !click;
              //               });
              //             },
              //             icon: Icon(
              //                 (click == false)
              //                     ? Icons.abc_rounded
              //                     : Icons.settings,
              //                 size: 40),
              //             color: Colors.white,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            )));
  }
}
