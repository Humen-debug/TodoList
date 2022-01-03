import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/user.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/theme.dart';
import 'package:todo_list/Screens/Task/update_task_screen.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Widgets/task_list_tile.dart';
import 'package:todo_list/Widgets/statment_widget.dart';

class TaskListView extends StatefulWidget {
  Map taskMap;
  User user;
  FileHandler file;
  TaskListView(
      {Key? key, required this.taskMap, required this.user, required this.file})
      : super(key: key);

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      // List<Task> row = widget.taskMap.remove(key);
      // widget.taskMap[key] = row;
    });
  }

  int? dismissedIndex(Task item) {
    int? pos;
    for (var v in widget.user.taskMap[MainScreenState.currentList]!) {
      if (v == item) {
        pos = widget.user.taskMap[MainScreenState.currentList]!.indexOf(v);
        break;
      }
    }
    return pos;
  }

  // @override
  // initState() {}

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    List keys = widget.taskMap.keys.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          String key = keys[index];
          return Card(
              elevation: 0.0,
              child: widget.taskMap[key].isNotEmpty
                  ? Column(
                      children: [
                        Text(key),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: widget.taskMap[key].length,
                            itemBuilder: (context, lindex) {
                              final Task item = widget.taskMap[key][lindex];
                              return Dismissible(
                                key: Key(
                                    item.title + item.createdTime.toString()),
                                onDismissed: (direction) {
                                  int? pos = dismissedIndex(item);
                                  setState(() {
                                    widget.taskMap[key]!.removeAt(lindex);

                                    widget.user
                                        .taskMap[MainScreenState.currentList]!
                                        .removeAt(pos!);

                                    widget.file.updateUser(
                                        id: widget.user.id,
                                        updatedUser: widget.user);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('${item.title} dismissed')));
                                },
                                background: const Card(color: Colors.red),
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsetsGeometry?>(
                                              EdgeInsets.zero),
                                          elevation:
                                              MaterialStateProperty.all<double>(
                                                  0.0),
                                          backgroundColor: themeProvider.islight
                                              ? MaterialStateProperty.all<
                                                  Color>(Colors.white)
                                              : MaterialStateProperty.all<
                                                  Color>(Colors.grey.shade800)),
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateTaskScreen(
                                                    index: lindex,
                                                    user: widget.user,
                                                    file: widget.file,
                                                    task: widget.taskMap[key]
                                                        [lindex]),
                                          )),
                                      child: TaskListTile(
                                          list: widget.taskMap[key],
                                          user: widget.user,
                                          file: widget.file,
                                          index: lindex),
                                    ),
                                    Column(
                                      children: [
                                        // show deadline, process, tomato clock (if has one)
                                        // and next line might show tags
                                        StatementWidget(
                                          task: widget.taskMap[key]![lindex],
                                        ),
                                        widget.taskMap[key]![lindex].isExpand &&
                                                widget.user.showDetails
                                            ? ListView.builder(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        25, 0, 0, 0),
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int num) {
                                                  return TextButton(
                                                    onPressed: () {},
                                                    child: SizedBox(
                                                      height: 45,
                                                      child: TaskListTile(
                                                          list: widget
                                                              .taskMap[key]![
                                                                  lindex]
                                                              .subtasks,
                                                          user: widget.user,
                                                          file: widget.file,
                                                          index: num),
                                                    ),
                                                  );
                                                },
                                                itemCount: widget
                                                    .taskMap[key]![lindex]
                                                    .subtasks
                                                    .length,
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    )
                  : SizedBox.shrink());
        },
        childCount: widget.taskMap.length,
      ),
      // onReorder: _onReorder,
    );
  }
}
