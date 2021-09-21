import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Screens/Task/task_screen.dart';
import '/Widgets/date_picker.dart';
import '/Widgets/time_picker.dart';

class NewTask extends StatefulWidget {
  final Task task;
  TaskScreenState taskScreenState;
  NewTask(this.task, this.taskScreenState);
  @override
  _NewTaskState createState() => _NewTaskState(task, taskScreenState);
}

class _NewTaskState extends State<NewTask> {
  Task task;
  TaskScreenState taskScreenState;
  _NewTaskState(this.task, this.taskScreenState);

  bool marked = false;

  TextEditingController taskController = TextEditingController();

  void updateTask() {
    task.task = taskController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: 'Add Task',
                labelStyle: TextStyle(fontSize: 20,),
              ),
              onChanged: (value) => updateTask(),
            ),
          ),

          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_upward_outlined),
            ),
          )
        ],
      ),

      Flex(direction: Axis.horizontal, children: <Widget>[
        DatePicker(),
        TimePicker(),
        Expanded(
            flex: 1,
            child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.repeat_rounded),
                label: const Text('Repeat'))),
      ])
    ]);
  }
}
