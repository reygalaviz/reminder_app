// import 'package:flutter/material.dart';
// import 'package:reminder_app/responsive/responsive_helper.dart';
// import 'package:reminder_app/responsive/tablet_body.dart';
// import 'package:reminder_app/responsive/mobile_body.dart';

// class AddNote extends StatefulWidget {
//   const AddNote({Key? key}) : super(key: key);

//   @override
//   State<AddNote> createState() => _AddNoteState();
// }

// class _AddNoteState extends State<AddNote> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ResponsiveWidget(mobile: MobileBody(), tablet: TabletBody()),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:reminder_app/models/color_data.dart';
import 'package:reminder_app/models/note_data.dart';
import 'package:reminder_app/models/datetime_data.dart';
import 'package:flutter/cupertino.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  //form validation
  final formKey = GlobalKey<FormState>(); //key for form

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
            color: Colors.green,
          ),
          SizedBox(height: 20),
          Container(
            height: 100,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            color: Colors.yellow,
          ),
        ],
      ),
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: NetworkImage(
      //       'https://images.unsplash.com/photo-1507499739999-097706ad8914?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=60&raw_url=true&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHNwYWNlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800',
      //     ),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      // child: LayoutBuilder(
      //   builder: (context, constraints) => Form(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         SizedBox(height: 5.0),
      //         Container(
      //           height: 75,
      //           margin: EdgeInsets.fromLTRB(constraints.maxWidth * .05, 0,
      //               constraints.maxWidth * .05, 0),
      //           decoration: BoxDecoration(
      //             //color var used to change note color
      //             color: color,
      //             borderRadius: BorderRadius.all(
      //               Radius.circular(10),
      //             ),
      //           ),
      //           child: NoteData_(),
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //             ElevatedButton(
      //               onPressed: () {},
      //               child: Text('Save'),
      //             ),
      //             ElevatedButton(
      //               onPressed: () => showModalBottomSheet(
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.vertical(
      //                         top: Radius.circular(25.0))),
      //                 context: context,
      //                 builder: (context) {
      //                   return Container(
      //                     height: constraints.maxHeight * .4,
      //                     padding: EdgeInsets.all(constraints.maxHeight * .05),
      //                     child: GridView.count(
      //                         crossAxisCount: 4,
      //                         crossAxisSpacing: 4,
      //                         mainAxisSpacing: 8.0,
      //                         children: List.generate(colors.length, (index) {
      //                           return ElevatedButton(
      //                             onPressed: () {
      //                               setState(() {
      //                                 color = colors[index];
      //                               });
      //                             },
      //                             child: null,
      //                             style: ElevatedButton.styleFrom(
      //                               shape: CircleBorder(),
      //                               primary: colors[index],
      //                             ),
      //                           );
      //                         })),
      //                   );
      //                 },
      //               ),
      //               child: Text(
      //                 'Color',
      //               ),
      //             ),
      //             ElevatedButton(
      //               onPressed: () => showModalBottomSheet(
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.vertical(
      //                         top: Radius.circular(25.0))),
      //                 context: context,
      //                 builder: (context) => Container(
      //                   height: constraints.maxHeight * .4,
      //                   padding: EdgeInsets.fromLTRB(
      //                       0, constraints.maxHeight * .05, 0, 0),
      //                   child: Column(
      //                     children: [
      //                       DateTimePicker(),
      //                       Container(
      //                         margin: EdgeInsets.fromLTRB(0, 2.0, 0, 0),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               child: Text('DateTime'),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {},
      //               child: Text('Repeat'),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
