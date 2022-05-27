import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:todo_list/Models/theme.dart';
import 'package:todo_list/Widgets/add_reminder_dialog.dart';
import 'package:todo_list/Widgets/time_picker_widget.dart';
import 'package:todo_list/Widgets/repeat_setter.dart';
import 'package:provider/provider.dart';

class BuildTaskSheet extends StatefulWidget {
  BuildContext context;
  Task task;
  VoidCallback createTask;
  BuildTaskSheet(
      {Key? key,
      required this.context,
      required this.task,
      required this.createTask})
      : super(key: key);

  @override
  _BuildTaskSheetState createState() => _BuildTaskSheetState();
}

class _BuildTaskSheetState extends State<BuildTaskSheet> {
  TextEditingController taskController = TextEditingController();

  Widget addTaskField(BuildContext context) {
    return TextField(
      controller: taskController,
      decoration: const InputDecoration(labelText: 'Add Task'),
      onChanged: (String title) => setState(() => widget.task.title = title),
      onSubmitted: (String title) {
        setState(() {
          widget.task.title = title;
          widget.createTask();
        });
        Navigator.pop(context);
      },
    );
  }

  Widget submitTaskBtn(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(widget.createTask);
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_upward_outlined),
    );
  }

  Widget allDaySwitcher(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.event),
        const SizedBox(width: 16),
        const Text('All Day', style: TextStyle(fontSize: 16)),
        const Spacer(),
        FlutterSwitch(
            height: 30,
            width: 64,
            activeColor: Theme.of(context).colorScheme.primary,
            value: widget.task.isAllDay,
            onToggle: (value) {
              setState(() {
                widget.task.isAllDay = value;
              });
            })
      ],
    );
  }

  Widget selectDateTime(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 30),
        TimePickerWidget(task: widget.task, type: "Date"),
        const Spacer(),
        widget.task.isAllDay
            ? TimePickerWidget(task: widget.task, type: 'Time')
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget addRepeatBtn(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.repeat_rounded),
        const SizedBox(width: 6),
        TextButton(
          style: ButtonStyle(
              alignment: Alignment.centerLeft,
              minimumSize: MaterialStateProperty.all<Size?>(
                  Size(MediaQuery.of(context).size.width - 60, 45))),
          // add daily / weekly / monthly options
          onPressed: () => showDialog(
              context: context,
              builder: (context) => RepeatSetter(task: widget.task)),
          child: const Text(
            'Repeat',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget addReminderBtn() {
    return Row(
      children: [
        const Icon(Icons.alarm),
        const SizedBox(width: 6),
        TextButton(
          style: ButtonStyle(
              alignment: Alignment.centerLeft,
              minimumSize: MaterialStateProperty.all<Size?>(
                  Size(MediaQuery.of(context).size.width - 60, 45))),
          // add daily / weekly / monthly options
          onPressed: () => showDialog(
              context: context,
              builder: (context) => AddReminderDialog(task: widget.task)),
          child: const Text(
            'Add Reminder',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 10,
            right: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(flex: 6, child: addTaskField(context)),
                  Expanded(flex: 1, child: submitTaskBtn(context))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: allDaySwitcher(context),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: selectDateTime(context)),
              addRepeatBtn(context),
              addReminderBtn(),
            ]),
      );
    });
  }
}
