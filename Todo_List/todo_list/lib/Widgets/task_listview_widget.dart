import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/user.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/theme.dart';
import 'package:todo_list/Screens/Task/update_task_screen.dart';
import 'package:todo_list/Screens/main_screen.dart';
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

  void dissmissTask(Task task, String key) {
    setState(() {
      if (widget.user.taskMap.containsKey(key)) {
        widget.user.taskMap[key]!.remove(task);
      } else {
        for (var list in widget.user.taskMap.values) {
          if (list.contains(task)) {
            list.remove(task);
          }
        }
      }
    });
    widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
  }

  void updateComplete(List<Task> list, int index, bool? flag) {
    final Task temp = list[index];
    setState(() {
      list[index].isCompleted = flag!;
      if (list[index].isCompleted == true) {
        list[index].completedTime = DateTime.now();

        widget.user.taskMap['Completed']!.add(temp);
        // update taskMap immediately
        if (widget.user.taskMap['Completed'] != widget.taskMap['Completed']) {
          widget.taskMap['Completed'].add(temp);
        }
      } else {
        list[index].completedTime = null;

        widget.user.taskMap['Completed']!.remove(temp);
        if (widget.user.taskMap['Completed'] != widget.taskMap['Completed']) {
          widget.taskMap['Completed'].remove(temp);
        }
      }

      widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
    });
  }

  Widget listTitleBar(String key) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            key.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget taskListTile(Task task, List<Task> list, int index) {
    return Opacity(
      opacity: task.isCompleted ? 0.5 : 1,
      child: ListTile(
        horizontalTitleGap: 5,
        minLeadingWidth: 10,
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            updateComplete(list, index, value);
          },
        ),
        trailing: expandTrailing(
            task, widget.user.showDetails && task.subtasks.isNotEmpty, true),
        title: Text(task.title),
      ),
    );
  }

  Widget expandTrailing(Task task, bool flag, bool isTask) {
    const Icon show = Icon(Icons.expand_more);
    return flag
        ? IconButton(
            onPressed: () => setState(
              () {
                if (isTask) {
                  task.isExpand = !task.isExpand;
                  widget.file
                      .updateUser(id: widget.user.id, updatedUser: widget.user);
                }
              },
            ),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: task.isExpand
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final taskBtnStyle = ButtonStyle(
        padding:
            MaterialStateProperty.all<EdgeInsetsGeometry?>(EdgeInsets.zero),
        elevation: MaterialStateProperty.all<double>(0.0),
        backgroundColor: themeProvider.islight
            ? MaterialStateProperty.all<Color>(Colors.white)
            : MaterialStateProperty.all<Color>(Colors.grey.shade800));

    List keys = widget.taskMap.keys.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          String key = keys[index];
          int count = widget.taskMap[key]
              .where((e) => e.isCompleted == true)
              .toList()
              .length;
          bool showList = (key != "Completed" || widget.user.showComplete) ||
              key == MainScreenState.currentList;
          bool showNotEmptyList = !(widget.taskMap[key].isEmpty ||
              count == widget.taskMap[key].length && key != "Completed");
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              elevation: 0.0,
              child: showList
                  ? showNotEmptyList
                      ? Column(
                          children: [
                            Container(
                                height: 30,
                                alignment: Alignment.center,
                                child: listTitleBar(key)),
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: widget.taskMap[key].length,
                                itemBuilder: (context, lindex) {
                                  final Task item = widget.taskMap[key][lindex];
                                  final taskKey = Key(
                                      item.title + item.createdTime.toString());
                                  return (key != "Completed" &&
                                          item.isCompleted)
                                      ? const SizedBox.shrink()
                                      : Dismissible(
                                          key: taskKey,
                                          onDismissed: (direction) {
                                            dissmissTask(item, key);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        '${item.title} dismissed')));
                                          },
                                          background:
                                              const Card(color: Colors.red),
                                          child: Column(
                                            children: [
                                              ElevatedButton(
                                                  style: taskBtnStyle,
                                                  onPressed: () =>
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                UpdateTaskScreen(
                                                                    user: widget
                                                                        .user,
                                                                    file: widget
                                                                        .file,
                                                                    task: widget
                                                                            .taskMap[key]
                                                                        [
                                                                        lindex]),
                                                          )),
                                                  child: taskListTile(
                                                      widget.taskMap[key]
                                                          [lindex],
                                                      widget.taskMap[key],
                                                      lindex)),
                                              Column(
                                                children: [
                                                  StatementWidget(
                                                    task: widget
                                                        .taskMap[key]![lindex],
                                                  ),
                                                  widget.taskMap[key]![lindex]
                                                          .isExpand
                                                      ? ListView.builder(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  25, 0, 0, 0),
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemBuilder: (context,
                                                              int num) {
                                                            return TextButton(
                                                              onPressed: () {},
                                                              child: SizedBox(
                                                                  height: 45,
                                                                  child: taskListTile(
                                                                      widget.taskMap[key][lindex].subtasks[
                                                                          num],
                                                                      widget
                                                                          .taskMap[
                                                                              key]
                                                                              [
                                                                              lindex]
                                                                          .subtasks,
                                                                      num)),
                                                            );
                                                          },
                                                          itemCount: widget
                                                              .taskMap[key]![
                                                                  lindex]
                                                              .subtasks
                                                              .length,
                                                        )
                                                      : const SizedBox.shrink()
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                }),
                          ],
                        )
                      : const SizedBox.shrink()
                  : const SizedBox.shrink());
        },
        childCount: widget.taskMap.length,
      ),
      // onReorder: _onReorder,
    );
  }
}
