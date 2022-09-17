import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:reminder_app/screens/settings.dart';
import 'package:reminder_app/themes/theme_model.dart';

class SettingsSuggest extends StatefulWidget {
  const SettingsSuggest({Key? key}) : super(key: key);

  @override
  State<SettingsSuggest> createState() => _SettingsSuggestState();
}

class _SettingsSuggestState extends State<SettingsSuggest> {
  TextEditingController name = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future sendEmail({
    required String name,
    required String email,
    required String title,
    required String details,
  }) async {
    final serviceId = 'service_2blaq5a';
    final templateId = 'template_jeae11k';
    final userId = 'tIDerQVuCEbJSxIE_';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'https://localhost',
        'Content-type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_title': title,
          'user_details': details,
        }
      }),
    );

    print(response.body);
  }

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

    _showErrorSnackBar(BuildContext context) {
      final snackbar = SnackBar(
        padding: const EdgeInsets.only(top: 15),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        duration: const Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Unable to Send',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.red[200],
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
                                top: constraints.maxHeight * .04),
                            child: Center(
                                child: Text(
                              'Your ideas matter,',
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'),
                            )),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: constraints.maxHeight * .04),
                            child: Center(
                                child: Text(
                              '\nTell us how we can improve',
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
                                    'Name',
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
                                    controller: name,
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
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Email Address',
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
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Title',
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
                                    controller: title,
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
                                    maxLines: 1,
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
                                  'How can we improve?',
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blue[100])),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        sendEmail(
                                            name: name.text,
                                            email: email.text,
                                            title: title.text,
                                            details: details.text);
                                        name.clear();
                                        details.clear();
                                        title.clear();
                                        email.clear();
                                        return _showSnackBar(context);
                                      } else {
                                        _showErrorSnackBar(context);
                                      }
                                    },
                                    child: const Text('Submit',
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
