import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  CalenderScreen({Key? key}) : super(key: key);

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  late final ValueNotifier<List<Task>> selectedEvents;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;
  @override
  void initState() {
    super.initState();

    selectedDay = focusedDay;
    // selectedEvents = ValueNotifier(getEventsForDay(selectedDay!));
  }

  void getEventsForDay(DateTime day) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: <Widget>[
        TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime(focusedDay.year - 5),
            lastDay: DateTime(focusedDay.year + 5))
      ]),
    );
  }
}
