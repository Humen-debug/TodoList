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

class TaskScreen extends StatefulWidget {
  User user;
  FileHandler file;
  TaskScreen({Key? key, required this.user, required this.file})
      : super(key: key);
  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  final appBarTitle = MainScreenState.currentList;
  late Task task;

  Map<String, List<Task>> dateTimeMap = {
    "Pinned": [],
    "Overdue": [],
    "Next 7 days": [],
    "Later": [],
    "No Date": [],
    "Completed": []
  };

  Map<String, List<Task>?> taskMap = {
    MainScreenState.currentList: [],
  };
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    String currentList = appBarTitle;
    appBarTitle == "All" ? currentList = "Inbox" : currentList = currentList;
    setState(() {
      taskMap[MainScreenState.currentList] =
          widget.user.taskMap[MainScreenState.currentList];
      if (widget.user.taskMap[currentList]!.isNotEmpty) {
        for (var v in widget.user.taskMap[currentList]!) {
          setTaskMap(v);
          setDateMap(v);
        }
      }
    });
    // print("${appBarTitle}: ${widget.user.taskMap[appBarTitle]}");
    // print(taskMap);
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
        if (v.isCompleted) {
          dateTimeMap["Completed"]!.add(v);
          return;
        }
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
    });
  }

  Future setTaskMap(Task v) async {
    if (MainScreenState.currentList != "Completed") {
      taskMap["Completed"] = [];
    }
    setState(() {
      if (v.isCompleted && !taskMap["Completed"]!.contains(v)) {
        // print("${v.title}: ${!taskMap["Completed"]!.contains(v)}");
        taskMap["Completed"]!.add(v);
      }
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
    String currentList = MainScreenState.currentList;
    if (currentList == "All") currentList = "Inbox";
    completeIndex != -1
        ? widget.user.taskMap[currentList]!.insert(completeIndex, newTask)
        : widget.user.taskMap[currentList]!.add(newTask);

    setDateMap(newTask);

    widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
  }

  Map selectMap() {
    switch (widget.user.sortIndex) {
      case 0:
        return MainScreenState.currentList == "All"
            ? widget.user.taskMap
            : taskMap;
      case 1:
        return dateTimeMap;
      case 2:
        return MainScreenState.currentList == "All"
            ? widget.user.taskMap
            : taskMap;
      case 3:
        return taskMap;
    }
    return widget.user.taskMap;
  }

  Icon get sortIcon => sortIcons[widget.user.sortIndex];

  final sortIcons = <Icon>[
    MainScreenState.currentList == "All"
        ? const Icon(Icons.table_rows)
        : const Icon(Icons.sort),
    const Icon(Icons.schedule),
    const Icon(Icons.text_rotate_vertical),
    const Icon(Icons.tag),
  ];

  final sortTitle = <Text>[
    MainScreenState.currentList == "All"
        ? const Text("List")
        : const Text("Custom"),
    const Text("By Time"),
    const Text("By Title"),
    const Text("By Tags"),
  ];

  void filterTasks(int item) {
    setState(() {
      widget.user.sortIndex = item;

      for (var list in selectMap().values) {
        list.sort((a, b) {
          return !b.isCompleted ? 1 : -1;
        });

        list.sort((a, b) {
          return !b.isCompleted ? 1 : -1;
        });
      }

      widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
    });
  }

  void onSelected(int item) {
    setState(() {
      switch (item) {
        case 0:
          widget.user.showDetails = !widget.user.showDetails;
          break;
        case 1:
          widget.user.showComplete = !widget.user.showComplete;
          break;
      }
      widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
    });
  }

  Widget sortButton() {
    return PopupMenuButton<int>(
        onSelected: (item) => filterTasks(item),
        icon: sortIcon,
        itemBuilder: (context) {
          return List.generate(sortIcons.length, (index) {
            return PopupMenuItem(
                value: index,
                child: Row(children: [
                  sortIcons[index],
                  const SizedBox(width: 10),
                  sortTitle[index]
                ]));
          });
        });
  }

  Widget menuButton() {
    return PopupMenuButton<int>(
        onSelected: (item) => onSelected(item),
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    !widget.user.showDetails
                        ? const Icon(Icons.preview)
                        : const Icon(Icons.disabled_by_default_outlined),
                    const SizedBox(width: 10),
                    !widget.user.showDetails
                        ? const Text("Show Details")
                        : const Text("Hide Details"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      !widget.user.showComplete
                          ? const Icon(Icons.preview)
                          : const Icon(Icons.disabled_by_default_outlined),
                      const SizedBox(width: 10),
                      !widget.user.showComplete
                          ? const Text("Show Completed")
                          : const Text("Hide Completed"),
                    ],
                  )),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: const [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text("Select")
                  ],
                ),
              ),
            ]);
  }

  void buildTask(BuildContext context) {
    setDefault();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
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
              sortButton(),
              menuButton(),
              // SortButton(
              //     file: widget.file,
              //     user: widget.user,
              //     list: widget.user.taskMap[appBarTitle]!),
              // MenuButton(file: widget.file, user: widget.user)
            ],
          ),
          TaskListView(
              taskMap: selectMap(), user: widget.user, file: widget.file)
        ],
      ),
    );
  }
}
