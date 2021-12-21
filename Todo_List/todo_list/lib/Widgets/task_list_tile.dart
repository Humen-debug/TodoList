import 'package:flutter/material.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Models/task.dart';

class TaskListTile extends StatefulWidget {
  List<Task> tasks;
  Task task;
  TaskListTile({Key? key, required this.tasks, required this.task})
      : super(key: key);

  @override
  _TaskListTileState createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  void updateComplete(bool? flag) {
    setState(() {
      widget.task.isCompleted = flag!;
      if (widget.task.isCompleted == true) {
        widget.tasks.remove(widget.task);
        MainScreenState.taskMap['Completed']!.add(widget.task);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.task.isCompleted,
        onChanged: (bool? value) {
          updateComplete(value);
        },
      ),
      title: Text(widget.task.text),
    );
  }
}
