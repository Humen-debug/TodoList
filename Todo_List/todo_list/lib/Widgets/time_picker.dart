import 'package:flutter/material.dart';
import 'package:todo_list/Widgets/button_widget.dart';

class TimePicker extends StatefulWidget {
  TimePicker({Key? key}) : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay? time;

  String getText() {
    if (time == null) {
      return 'Select time';
    } else {
      return '${time!.hour}:${time!.minute}';
    }
  }

  @override
  Widget build(BuildContext context) => ButtonHeaderWidget(
      title: 'Time',
      text: getText(),
      onClicked: () => pickTime(context),
      icon: Icons.alarm);

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 8, minute: 0);
    final newTime =
        await showTimePicker(context: context, initialTime: initialTime);
    if (newTime == null) return;
    setState(() => time = newTime);
  }
}
