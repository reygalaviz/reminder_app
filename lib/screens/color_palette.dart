import 'package:flutter/material.dart';

class ColorBottomSheet extends StatelessWidget {
  const ColorBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 108, 44, 44),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Column(children: <Widget>[]),
      ),
    );
  }
}
