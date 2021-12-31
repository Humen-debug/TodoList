import 'package:flutter/material.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';
import 'package:todo_list/Widgets/expand_trailing.dart';
import 'package:todo_list/Screens/Task/task_screen.dart';

class TaskListTile extends StatefulWidget {
  int index;
  List<Task> list;
  User user;
  FileHandler file;
  TaskListTile(
      {Key? key,
      required this.list,
      required this.user,
      required this.file,
      required this.index})
      : super(key: key);

  @override
  _TaskListTileState createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  int get completeIndex =>
      widget.list.indexWhere((task) => task.isCompleted == true);

  void updateComplete(List<Task> list, int index, bool? flag) {
    final Task temp = list[index];

    setState(() {
      list[index].isCompleted = flag!;
      if (list[index].isCompleted == true) {
        widget.user.taskMap['Completed']!.add(temp);
        list.remove(temp);

        list.add(temp);
      } else {
        widget.user.taskMap['Completed']!.remove(temp);
        list.remove(temp);

        completeIndex != -1 ? list.insert(completeIndex, temp) : list.add(temp);
      }

      widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.list[widget.index].isCompleted ? 0.5 : 1,
      child: ListTile(
        horizontalTitleGap: 5,
        minLeadingWidth: 10,
        leading: Checkbox(
          value: widget.list[widget.index].isCompleted,
          onChanged: (bool? value) {
            updateComplete(widget.list, widget.index, value);
          },
        ),
        trailing: ExpandTrailing(
            index: widget.index,
            list: widget.list,
            file: widget.file,
            user: widget.user,
            flag: widget.user.showDetails &&
                widget.list[widget.index].subtasks.isNotEmpty),
        title: Text(widget.list[widget.index].title),
      ),
    );
  }
}
