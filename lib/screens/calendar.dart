import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:reminder_app/screens/home.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:reminder_app/screens/home.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          CalendarTimeline(
            showYears: true,
            initialDate: _selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365000)),
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date!;
              });
            },
            leftMargin: 20,
            monthColor: Theme.of(context).primaryColor,
            dayColor: Theme.of(context).primaryColor,
            dayNameColor: Color(0xFF333A47),
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.redAccent[100],
            dotsColor: Color(0xFF333A47),
            selectableDayPredicate: (date) => date.day != 23,
            locale: 'en',
          ),
          SizedBox(height: 20),
          Padding(
              padding: EdgeInsets.only(left: 16),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.teal[200])),
                child:
                    Text('Today', style: TextStyle(color: Color(0xFF333A47))),
                onPressed: () => setState(() => _resetSelectedDate()),
              )),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
