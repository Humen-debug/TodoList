import 'package:todo_list/Models/task.dart';
import 'package:flutter/material.dart';

class AddReminderDialog extends StatefulWidget {
  Task task;
  AddReminderDialog({Key? key, required this.task}) : super(key: key);

  @override
  _AddReminderDialogState createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  final reminderTitle = const <Text>[
    Text("10 minutes before"),
    Text("15 minutes before"),
    Text("20 minutes before"),
    Text("30 minutes before"),
    Text("1 hour before"),
    Text("1 day before"),
    Text("Custom")
  ];

  Future<void> handleRadioValue(value) async {
    setState(() {
      // widget.task.repeatChoice = value;
      // need to pop up dialog for choosing custom
      if (value == reminderTitle.length - 1) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 16,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: reminderTitle.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                title: reminderTitle[index],
                value: index,
                groupValue: widget.task.repeatChoice,
                onChanged: handleRadioValue,
              );
            }),
      );
    });
  }
}
