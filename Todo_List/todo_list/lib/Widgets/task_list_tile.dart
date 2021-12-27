import 'package:flutter/material.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Screens/Task/task_screen.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';

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
  void updateComplete(List<Task> list, int index, bool? flag) {
    setState(() {
      list[index].isCompleted = flag!;
      if (list[index].isCompleted == true) {
        widget.user.taskMap['Completed']!.add(list[index]);
        list.removeAt(index);
        widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
      }
    });
  }

  Widget expandTrailing(BuildContext context, int index) {
    Icon show = const Icon(Icons.expand_more);
    return TaskScreenState.showComplete &&
            widget.list[index].subtasks.isNotEmpty
        ? IconButton(
            onPressed: () => setState(
              () {
                widget.list[index].isExpand = !widget.list[index].isExpand;
                widget.file
                    .updateUser(id: widget.user.id, updatedUser: widget.user);
              },
            ),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: widget.list[index].isExpand
                    ? Tween<double>(begin: 0, end: 1).animate(animation)
                    : Tween<double>(begin: 1, end: 0.25).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: show,
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 5,
      minLeadingWidth: 10,
      leading: Checkbox(
        value: widget.list[widget.index].isCompleted,
        onChanged: (bool? value) {
          updateComplete(widget.list, widget.index, value);
        },
      ),
      trailing: expandTrailing(context, widget.index),
      title: Text(widget.list[widget.index].title),
    );
  }
}
