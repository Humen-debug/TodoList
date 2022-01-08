import 'package:todo_list/Models/task.dart';
import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  Task task;
  String type;
  // Text deadline;
  TimePickerWidget({
    Key? key,
    required this.task,
    required this.type,
  }) : super(key: key);

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  void updateDate(date) {
    if (date == null) return;
    setState(() {
      widget.task.date = date;
      updateDeadline();
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
      updateDeadline();
    });
  }

  void updateDeadline() {
    var diff = (widget.task.date)?.difference(DateTime.now()).inDays ?? 0;

    if (diff > 0) {
      if (diff == 1) {
        widget.task.deadline = 'Due Tomorrow';
      } else {
        widget.task.deadline =
            '${widget.task.date!.day}/${widget.task.date!.month}/${widget.task.date!.year}: $diff days left';
      }
    } else if (diff == 0) {
      var diffHour = (widget.task.date!).difference(DateTime.now()).inHours;
      if (diffHour >= 0) {
        widget.task.deadline = '$diffHour hrs left';
      } else {
        diffHour = -diffHour;
        widget.task.deadline = '$diffHour hrs late';
      }
    } else {
      diff = -diff;
      widget.task.deadline =
          '${widget.task.date!.day}/${widget.task.date!.month}/${widget.task.date!.year}: $diff days late';
    }
  }

  static const icons = <String, IconData>{
    "Date": (Icons.event),
    "Time": (Icons.alarm),
  };
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () async {
          switch (widget.type) {
            case 'Date':
              {
                final initialDate = DateTime.now();
                await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(DateTime.now().year - 5),
                        lastDate: DateTime(DateTime.now().year + 5))
                    .then((date) {
                  // print('date: $date');
                  updateDate(date);
                  // print('task.date: $widget.task.date');
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
        icon: Icon(icons[widget.type]),
        label: widget.type == 'Time'
            ? widget.task.time == ""
                ? const Text("Select Time",
                    style: TextStyle(color: Colors.grey))
                : Text(widget.task.time)
            : widget.task.date == null
                ? const Text("Select Date",
                    style: TextStyle(color: Colors.grey))
                : Text(
                    '${widget.task.date!.day}/${widget.task.date!.month}/${widget.task.date!.year}',
                    style: const TextStyle(color: Colors.grey)));
  }
}
