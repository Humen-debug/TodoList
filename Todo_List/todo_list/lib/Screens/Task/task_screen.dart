import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Screens/Task/update_task_screen.dart';
import 'package:todo_list/Widgets/drawer.dart';
import 'package:todo_list/Models/theme.dart';
import 'package:todo_list/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Widgets/statment_widget.dart';
import 'package:todo_list/Widgets/task_list_tile.dart';
import 'package:todo_list/Widgets/time_picker_widget.dart';
import 'package:todo_list/Widgets/menu_button.dart';
import 'package:todo_list/Widgets/sort_button.dart';

class TaskScreen extends StatefulWidget {
  User user;
  FileHandler file;
  TaskScreen({Key? key, required this.user, required this.file})
      : super(key: key);
  @override
  TaskScreenState createState() => TaskScreenState();
}

// 1. Create temperoary map for sorting tasks into completed and processing/ Dates / Tags
// 2. Tidy up the widgets plzzz (almost)
// 3. wrap the tasks into card
// 4. find way to move floating action button into sliver instead of scaffold
class TaskScreenState extends State<TaskScreen> {
  final appBarTitle = MainScreenState.currentList;
  late Task task;
  late List<Task> list;

  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    // super.initState();
    setState(() {
      list = widget.user.taskMap[appBarTitle] != null
          ? widget.user.taskMap[appBarTitle]!
          : [];

      // setDefault();
    });
  }

  void setDefault() {
    setState(() => task = Task(
          title: "",
          date: null,
          isCompleted: false,
          isExpand: false,
          time: "",
          createdTime: DateTime.now(),
          status: "",
          deadline: "No Deadline",
          subtasks: [],
        ));
  }

  void createTask() {
    int completeIndex = list.indexWhere((task) => task.isCompleted);
    if (task.title == '') return;
    var newTask = Task(
      title: task.title,
      date: task.date,
      isCompleted: false,
      isExpand: false,
      time: task.time,
      createdTime: task.createdTime,
      status: task.status,
      deadline: task.deadline,
      subtasks: task.subtasks,
    );
    setDefault();
    completeIndex != -1
        ? list.insert(completeIndex, newTask)
        : list.add(newTask);
    widget.user.taskMap[appBarTitle] = list;
    widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
  }

  void buildTask(BuildContext context) {
    setDefault();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bottomContext) {
          return StatefulBuilder(builder: (buttomContext, state) {
            return Padding(
              padding: EdgeInsets.only(
                  // 330 as keyboard height
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: taskController,
                        decoration:
                            const InputDecoration(labelText: 'Add Task'),
                        onChanged: (String title) =>
                            setState(() => task.title = title),
                        onSubmitted: (String title) {
                          setState(() {
                            task.title = title;
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
                    child: TimePickerWidget(task: task, type: "Date"),
                  ),
                  Expanded(
                    flex: 1,
                    child: TimePickerWidget(task: task, type: 'Time'),
                  ),
                  Expanded(
                      flex: 1,
                      child: TextButton.icon(
                          // add daily / weekly / monthly options
                          onPressed: () {},
                          icon: const Icon(Icons.repeat_rounded),
                          label: const Text('Repeat'))),
                ])
              ]),
            );
          });
        });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      Task row = list.removeAt(oldIndex);
      list.insert(newIndex, row);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    initState();
    return Scaffold(
      drawer: SideDrawer(user: widget.user, file: widget.file),
      floatingActionButton: FloatingActionButton(
          splashColor: Colors.white60,
          elevation: 4.0,
          highlightElevation: 0.0,
          child: const Icon(Icons.add),
          onPressed: () {
            buildTask(context);
          }),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            elevation: 0.0,
            expandedHeight: 85.0,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(appBarTitle,
                    style: TextStyle(
                        color: themeProvider.lighttheme.colorScheme.primary))),
            leading: Builder(
                builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu))),
            actions: <Widget>[
              // sortButton(),
              SortButton(
                  file: widget.file,
                  user: widget.user,
                  list: widget.user.taskMap[appBarTitle]!),
              MenuButton(file: widget.file, user: widget.user)
            ],
          ),
          ReorderableSliverList(
            delegate: ReorderableSliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) return Text("Tasks");
                if (index <= widget.user.taskMap[appBarTitle]!.length) {
                  if (!widget.user.showComplete &&
                      widget
                          .user.taskMap[appBarTitle]![index - 1].isCompleted) {
                    return const SizedBox.shrink();
                  } else {
                    final item = widget.user.taskMap[appBarTitle]![index - 1];
                    return Dismissible(
                      key: Key(
                          widget.user.taskMap[appBarTitle]![index - 1].title +
                              widget.user.taskMap[appBarTitle]![index - 1]
                                  .createdTime
                                  .toString()),
                      onDismissed: (direction) {
                        setState(() {
                          widget.user.taskMap[appBarTitle]!.remove(item);
                          widget.file.updateUser(
                              id: widget.user.id, updatedUser: widget.user);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.title} dismissed')));
                      },
                      background: const Card(color: Colors.red),
                      child: Card(
                        elevation: 0.0,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry?>(EdgeInsets.zero),
                                      elevation:
                                          MaterialStateProperty.all<double>(
                                              0.0),
                                      backgroundColor: themeProvider.islight
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.white)
                                          : MaterialStateProperty.all<Color>(
                                              Colors.grey.shade800)),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateTaskScreen(
                                          index: index - 1,
                                          user: widget.user,
                                          file: widget.file,
                                        ),
                                      )),
                                  child: TaskListTile(
                                      list: widget.user.taskMap[appBarTitle]!,
                                      user: widget.user,
                                      file: widget.file,
                                      index: index - 1)),
                            ),
                            Column(
                              children: [
                                // show deadline, process, tomato clock (if has one)
                                // and next line might show tags
                                StatementWidget(
                                  task: widget
                                      .user.taskMap[appBarTitle]![index - 1],
                                ),
                                widget.user.taskMap[appBarTitle]![index - 1]
                                            .isExpand &&
                                        widget.user.showDetails
                                    ? ListView.builder(
                                        padding: const EdgeInsets.fromLTRB(
                                            25, 0, 0, 0),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int num) {
                                          return TextButton(
                                            onPressed: () {},
                                            child: SizedBox(
                                              height: 45,
                                              child: TaskListTile(
                                                  list: widget
                                                      .user
                                                      .taskMap[appBarTitle]![
                                                          index - 1]
                                                      .subtasks,
                                                  user: widget.user,
                                                  file: widget.file,
                                                  index: num),
                                            ),
                                          );
                                        },
                                        itemCount: widget
                                            .user
                                            .taskMap[appBarTitle]![index - 1]
                                            .subtasks
                                            .length,
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
                return const Text("Completed");
              },
              childCount: widget.user.taskMap[appBarTitle]!.isEmpty
                  ? 2
                  : widget.user.taskMap[appBarTitle]!.length + 2,
            ),
            onReorder: _onReorder,
          )
        ],
      ),
    );
  }
}
