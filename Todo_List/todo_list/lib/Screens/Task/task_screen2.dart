import 'package:flutter/material.dart';

import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/task.dart';

import 'package:todo_list/Widgets/drawer.dart';
import 'package:todo_list/Models/theme.dart';
import 'package:todo_list/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Screens/main_screen.dart';

import 'package:todo_list/Widgets/task_listview_widget.dart';
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
// 4. find way to move floating action button into sliver instead of scaffold
// 5. data not changed instantly -> inherited widget? >> changes stored in file, but not instantly pass from user to dateMap
// every update from widge.user to dateTimeMap has to pass to TaskScreen
class TaskScreenState extends State<TaskScreen> {
  final appBarTitle = MainScreenState.currentList;
  late Task task;

  Map<String, List<Task>> dateTimeMap = {
    "Pinned": [],
    "Overdue": [],
    "Next 7 days": [],
    "Later": [],
    "No Date": []
  };
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    setState(() {
      if (widget.user.taskMap[appBarTitle]!.isNotEmpty) {
        for (var v in widget.user.taskMap[appBarTitle]!) {
          setDateMap(v);
        }
      }
    });
    print("${appBarTitle}: ${widget.user.taskMap[appBarTitle]}");
    // super.initState();
  }

  Future setDateMap(Task v) async {
    bool flag = false;
    for (var l in dateTimeMap.values) {
      if (l.contains(v)) {
        flag = true;
        break;
      }
    }
    setState(() {
      if (flag == false) {
        if (v.date != null) {
          int diff = v.date!.difference(DateTime.now()).inDays;
          if (diff < 0) {
            dateTimeMap["Overdue"]!.add(v);
          } else if (diff <= 7) {
            dateTimeMap["Next 7 days"]!.add(v);
          } else {
            dateTimeMap["Later"]!.add(v);
          }
        } else {
          dateTimeMap["No Date"]!.add(v);
        }
      }
      for (var l in dateTimeMap.values) {
        l = l.toSet().toList();
      }
      print(widget.user.taskMap[appBarTitle]);
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
    int completeIndex = widget.user.taskMap[appBarTitle]!
        .indexWhere((task) => task.isCompleted);
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
        ? widget.user.taskMap[appBarTitle]!.insert(completeIndex, newTask)
        : widget.user.taskMap[appBarTitle]!.add(newTask);

    setDateMap(newTask);

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

  @override
  Widget build(BuildContext context) {
    initState();
    final themeProvider = Provider.of<ThemeProvider>(context);

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
              SortButton(
                  file: widget.file,
                  user: widget.user,
                  list: widget.user.taskMap[appBarTitle]!),
              MenuButton(file: widget.file, user: widget.user)
            ],
          ),
          TaskListView(
              taskMap: dateTimeMap, user: widget.user, file: widget.file)
        ],
      ),
    );
  }
}
