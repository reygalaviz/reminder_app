import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  //dimension for mobile and tablet devices
  final mobileWidth = 600;
  final tabletWidth = 800;

  const ResponsiveWidget({Key? key, required this.mobile, required this.tablet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth < 600) {
        return mobile;
      } else {
        return tablet;
      }
    }));
  }
}
