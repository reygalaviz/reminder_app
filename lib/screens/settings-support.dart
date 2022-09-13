import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reminder_app/screens/settings.dart';
import 'package:reminder_app/themes/theme_model.dart';

class SettingsSupport extends StatefulWidget {
  const SettingsSupport({Key? key}) : super(key: key);

  @override
  State<SettingsSupport> createState() => _SettingsSupportState();
}

class _SettingsSupportState extends State<SettingsSupport> {
  TextEditingController description = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _showSnackBar(BuildContext context) {
      final snackbar = SnackBar(
        padding: const EdgeInsets.only(top: 15),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        duration: const Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Successfully Submitted',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.green[200],
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Material(
        child: LayoutBuilder(
            builder: (context, constraints) => Container(
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            color: Colors.blue[100],
                            height: constraints.maxHeight * .15,
                            width: double.infinity,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: constraints.maxHeight * .05),
                            child: Center(
                                child: Text(
                              'Hey, how can we help?',
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'),
                            )),
                          )
                        ],
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Describe the problem you are having',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: description,
                                    validator: (val) {
                                      if (val!.isEmpty ||
                                          !RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
                                              .hasMatch(val)) {
                                        return 'Please enter a valid input';
                                      } else {
                                        return null;
                                      }
                                    },
                                    cursorColor: Theme.of(context).primaryColor,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                        errorBorder: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red)),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                        contentPadding:
                                            const EdgeInsets.all(6.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor))),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Give us more details',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: details,
                                    validator: (val) {
                                      if (val!.isEmpty ||
                                          !RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
                                              .hasMatch(val)) {
                                        return 'Please enter a valid input';
                                      } else {
                                        return null;
                                      }
                                    },
                                    cursorColor: Theme.of(context).primaryColor,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                        errorBorder: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red)),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                        contentPadding: EdgeInsets.all(6.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor))),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Enter Email Address',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: email,
                                    validator: (val) {
                                      if (val!.isEmpty ||
                                          !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(val)) {
                                        return 'Please enter a valid email address';
                                      } else {
                                        return null;
                                      }
                                    },
                                    cursorColor: Theme.of(context).primaryColor,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        errorBorder: const OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red)),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                        contentPadding:
                                            const EdgeInsets.all(6.0),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor))),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue[100])),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        description.clear();
                                        details.clear();
                                        email.clear();
                                        return _showSnackBar(context);
                                      }
                                    },
                                    child: Text('Submit',
                                        style: TextStyle(color: Colors.black))),
                              ),
                            ],
                          )),
                    ],
                  ),
                )),
      ),
    );
  }
}
