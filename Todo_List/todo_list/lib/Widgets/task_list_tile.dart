import 'package:flutter/material.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';

class TaskListTile extends StatefulWidget {
  User user;

  TaskListTile({Key? key, required this.user}) : super(key: key);

  @override
  _TaskListTileState createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile();
  }
}
