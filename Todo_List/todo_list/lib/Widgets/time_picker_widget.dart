import 'package:todo_list/Models/task.dart';
import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  Task task;
  String type;

  TimePickerWidget({
    Key? key,
    required this.task,
    required this.type,
  }) : super(key: key);

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  final textStyle = const TextStyle(color: Colors.grey, fontSize: 16);

  void updateDate(date) {
    if (date == null) return;
    setState(() {
      widget.task.date = date;
    });
  }

  void updateTime(time) {
    if (time == null) return;
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    setState(() {
      widget.task.date = DateTime(
          widget.task.date!.year,
          widget.task.date!.month,
          widget.task.date!.day,
          time.hour,
          time.minute);
      widget.task.time = '$hours:$minutes';
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: widget.type == 'Time'
          ? widget.task.time == ""
              ? Text("Time", style: textStyle)
              : Text(widget.task.time, style: textStyle)
          : widget.task.date == null
              ? Text("Selected Date", style: textStyle)
              : Text(
                  '${widget.task.date!.day}/${widget.task.date!.month}/${widget.task.date!.year}',
                  style: textStyle),
      onPressed: () async {
        switch (widget.type) {
          case 'Date':
            {
              final initialDate = DateTime.now();
              await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(DateTime.now().year - 5),
                      lastDate: DateTime(DateTime.now().year + 5),
                      currentDate: DateTime.now())
                  .then((date) {
                updateDate(date);
              });
            }
            break;
          case 'Time':
            {
              const initialTime = TimeOfDay(hour: 8, minute: 0);
              await showTimePicker(
                context: context,
                initialTime: initialTime,
              ).then((time) {
                updateTime(time);
              });
            }
            break;
        }
      },
    );
  }
}
