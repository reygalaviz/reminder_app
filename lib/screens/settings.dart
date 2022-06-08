import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => SizedBox(
              height: constraints.maxHeight * .92,
              child: Column(
                children: [
                  const ListTile(
                    title: Center(
                        child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey[400],
                      width: constraints.maxWidth * .9,
                      height: constraints.maxHeight * .2,
                      child: Column(
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: const Text('Notifications')),
                          TextButton(
                              onPressed: () {}, child: const Text('Calendar')),
                          TextButton(
                              onPressed: () {},
                              child: const Text('Notifications')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey[400],
                      width: constraints.maxWidth * .9,
                      height: constraints.maxHeight * .2,
                      child: Column(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Colors.grey[400],
                      width: constraints.maxWidth * .9,
                      height: constraints.maxHeight * .2,
                    ),
                  ),
                ],
              ),
            ));
  }
}
