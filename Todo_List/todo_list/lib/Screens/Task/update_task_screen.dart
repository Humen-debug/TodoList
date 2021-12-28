import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Widgets/task_list_tile.dart';
import 'package:todo_list/Widgets/time_picker_widget.dart';
// MANY PROBLEMS
// 1. can't upload task.progress instantly after clicking checkbox of subtasks
// 2. order of subtasks cannot be sorted after updateCompleted
// 3. subtaskListTile load the wrong widget.index, results in different subtasks

class UpdateTaskScreen extends StatefulWidget {
  int index;
  User user;
  FileHandler file;

  UpdateTaskScreen(
      {Key? key, required this.index, required this.user, required this.file})
      : super(key: key);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  late Task subtask;
  final deadline = Text('No deadline');
  TextEditingController taskController = TextEditingController();

  void setDefault() {
    setState(() => subtask = Task(
        title: "",
        date: null,
        isCompleted: false,
        isExpand: false,
        time: "",
        createdTime: DateTime.now(),
        status: "",
        deadline: "No Dealine",
        progress: 0,
        subtasks: [],
        completed: []));
  }

  void createTask() {
    if (subtask.title == '') return;
    var newTask = Task(
        title: subtask.title,
        date: subtask.date,
        isCompleted: false,
        isExpand: false,
        time: subtask.time,
        createdTime: subtask.createdTime,
        status: subtask.status,
        deadline: subtask.deadline,
        progress: subtask.progress,
        subtasks: subtask.subtasks,
        completed: subtask.completed);
    setDefault();
    widget.user.taskMap[MainScreenState.currentList]![widget.index].subtasks
        .insert(0, newTask);
    widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
  }

  // list: widget.user.taskMap[MainScreenState.currentList]![widget.index].subtasks
  void reload(List list) {
    setState(() {
      list.sort((a, b) {
        return !b.isCompleted ? 1 : -1;
      });
      widget.user.taskMap[MainScreenState.currentList]![widget.index]
          .setProgress();
      list.sort((a, b) {
        return !b.isCompleted ? 1 : -1;
      });
      widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
    });
  }

  void buildTask(BuildContext context) {
    setDefault();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bottomContext) {
          return StatefulBuilder(builder: (context, state) {
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
                      ),
                      onChanged: (String title) {
                        setState(() {
                          subtask.title = title;
                        });
                      },
                      onSubmitted: (String title) {
                        setState(() {
                          subtask.title = title;
                          createTask();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        setState(() => createTask());
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_upward_outlined),
                    ),
                  )
                ],
              ),
              Flex(direction: Axis.horizontal, children: <Widget>[
                Expanded(
                    flex: 1,
                    child: TimePickerWidget(
                      task: subtask,
                      type: 'Date',
                    )),
                Expanded(
                    flex: 1,
                    child: TimePickerWidget(
                      task: subtask,
                      type: 'Time',
                    )),
                Expanded(
                    flex: 1,
                    child: TextButton.icon(
                        // add daily / weekly / monthly options
                        onPressed: () {},
                        icon: const Icon(Icons.repeat_rounded),
                        label: const Text('Repeat'))),
              ])
            ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = MainScreenState.currentList;

    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          actions: <Widget>[
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
          ],
          elevation: 0,
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              value: widget
                  .user
                  .taskMap[MainScreenState.currentList]![widget.index]
                  .progress!,
              minHeight: 48,
              valueColor:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? AlwaysStoppedAnimation<Color>(Colors.grey.shade200)
                      : AlwaysStoppedAnimation<Color>(Colors.grey.shade700),
              backgroundColor: Colors.transparent,
            ),
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(children: [
                TextFormField(
                  maxLines: null,
                  minLines: null,
                  // expands: true,
                  // controller: taskController,
                  initialValue: widget
                      .user
                      .taskMap[MainScreenState.currentList]![widget.index]
                      .title,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  onFieldSubmitted: (String title) => setState(() {
                    widget
                        .user
                        .taskMap[MainScreenState.currentList]![widget.index]
                        .title = title;
                    widget.file.updateUser(
                        id: widget.user.id, updatedUser: widget.user);
                  }),
                ),
                TextFormField(
                  initialValue: widget
                      .user
                      .taskMap[MainScreenState.currentList]![widget.index]
                      .status,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Description"),
                  onChanged: (String descript) => setState(() {
                    widget
                        .user
                        .taskMap[MainScreenState.currentList]![widget.index]
                        .status = descript;
                    widget.file.updateUser(
                        id: widget.user.id, updatedUser: widget.user);
                  }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 298,
                  child: ListView.builder(
                      itemCount: widget
                              .user
                              .taskMap[MainScreenState.currentList]![
                                  widget.index]
                              .subtasks
                              .isEmpty
                          ? 1
                          : (widget
                                  .user
                                  .taskMap[MainScreenState.currentList]![
                                      widget.index]
                                  .subtasks
                                  .length) +
                              1,
                      itemBuilder: (context, index) {
                        if (index ==
                            widget
                                .user
                                .taskMap[MainScreenState.currentList]![
                                    widget.index]
                                .subtasks
                                .length) {
                          return TextButton.icon(
                            onPressed: () => buildTask(context),
                            icon: const Icon(Icons.add),
                            label: const Text("Add subtask"),
                            style: const ButtonStyle(
                              alignment: Alignment.centerLeft,
                            ),
                          );
                        } else {
                          return TaskListTile(
                              list: widget
                                  .user
                                  .taskMap[MainScreenState.currentList]![
                                      widget.index]
                                  .subtasks,
                              user: widget.user,
                              file: widget.file,
                              index: index);
                        }
                      }),
                )
              ]),
            )),
          ],
        ));
  }
}
