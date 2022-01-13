import 'package:todo_list/Models/task.dart';
import 'package:flutter/material.dart';

class RepeatSetter extends StatefulWidget {
  Task task;
  RepeatSetter({Key? key, required this.task}) : super(key: key);

  @override
  _RepeatSetterState createState() => _RepeatSetterState();
}

class _RepeatSetterState extends State<RepeatSetter> {
  final repeatTitle = const <Text>[
    Text("Never"),
    Text("Daily"),
    Text("Weekly"),
    Text("Monthly"),
    Text("Yearly"),
    Text("Custom")
  ];

  Future<void> handleRadioValue(value) async {
    setState(() {
      widget.task.repeatChoice = value;
      // need to pop up dialog for choosing custom
      if (value == repeatTitle.length - 1) {}
      // might need to update task repeat here
      // so that repeatChoice can be set to -1 again
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
            itemCount: repeatTitle.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                title: repeatTitle[index],
                value: index,
                groupValue: widget.task.repeatChoice,
                onChanged: handleRadioValue,
              );
            }),
      );
    });
  }
}
