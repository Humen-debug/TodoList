import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/user.dart';

class ExpandTrailing extends StatefulWidget {
  int index;
  List<Task> list;
  FileHandler file;
  User user;
  bool flag;
  ExpandTrailing(
      {Key? key,
      required this.index,
      required this.list,
      required this.file,
      required this.user,
      required this.flag})
      : super(key: key);

  @override
  _ExpandTrailingState createState() => _ExpandTrailingState();
}

class _ExpandTrailingState extends State<ExpandTrailing> {
  @override
  Widget build(BuildContext context) {
    const Icon show = Icon(Icons.expand_more);
    return widget.flag
        ? IconButton(
            onPressed: () => setState(
              () {
                widget.list[widget.index].isExpand =
                    !widget.list[widget.index].isExpand;
                widget.file
                    .updateUser(id: widget.user.id, updatedUser: widget.user);
              },
            ),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: widget.list[widget.index].isExpand
                    ? Tween<double>(begin: 0, end: 1).animate(animation)
                    : Tween<double>(begin: 1, end: 0.25).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: show,
            ),
          )
        : const SizedBox.shrink();
  }
}
