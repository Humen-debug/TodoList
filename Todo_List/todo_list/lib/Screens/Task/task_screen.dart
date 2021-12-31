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

class TaskScreen extends StatefulWidget {
  User user;
  FileHandler file;
  TaskScreen({Key? key, required this.user, required this.file})
      : super(key: key);
  @override
  TaskScreenState createState() => TaskScreenState();
}

// 1. Create temperoary map for sorting tasks into completed and processing/ Dates / Tags
// 2. Tidy up the widgets plzzz
// 3. wrap the tasks into card
// 4. find way to move floating action button into sliver instead of scaffold
class TaskScreenState extends State<TaskScreen> {
  final appBarTitle = MainScreenState.currentList;
  late Task task;
  late List<Task> list;

  TextEditingController taskController = TextEditingController();
  static bool showDetails = true;
  static bool showComplete = false;
  bool reOrder = false;
  Icon sortIcon = const Icon(Icons.sort);
  static const sortIcons = <Icon>[
    Icon(Icons.sort),
    Icon(Icons.schedule),
    Icon(Icons.text_rotate_vertical),
    Icon(Icons.tag),
  ];
  static const sortTitle = <Text>[
    Text("Custom"),
    Text("By Time"),
    Text("By Title"),
    Text("By Tags"),
  ];

  void filterTasks(BuildContext context, int item) {
    setState(() {
      sortIcon = sortIcons[item];
      list.sort((a, b) {
        return !b.isCompleted ? 1 : -1;
      });
      switch (item) {
        case 0:
          // reOrder = !reOrder;
          break;
        case 1:
          list.sort((a, b) {
            if (a.date == b.date) {
              return 0;
            } else if ((a.date == null && b.date != null)) {
              return -1;
            } else if (a.date != null && b.date == null) {
              return 1;
            } else {
              return a.date!.compareTo(b.date!);
            }
          });
          break;
        case 2:
          list.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 3:
          break;
      }
      list.sort((a, b) {
        return !b.isCompleted ? 1 : -1;
      });
      widget.user.taskMap[appBarTitle] = list;
      widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
    });
  }

  void onSelected(BuildContext context, int item) {
    setState(() {
      switch (item) {
        case 0:
          showDetails = !showDetails;
          break;
        case 1:
          showComplete = !showComplete;
          break;
      }
    });
  }

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
    list.insert(0, newTask);
    widget.user.taskMap[appBarTitle] = list;
    widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
  }

  void updateComplete(List<Task> list, int index, bool? flag) {
    final Task temp = list[index];
    setState(() {
      list[index].isCompleted = flag!;
      if (list[index].isCompleted == true) {
        widget.user.taskMap['Completed']!.add(list[index]);
        list.removeAt(index);

        list.add(temp);
      } else {
        int completeIndex = list.indexWhere((task) => task.isCompleted == true);
        widget.user.taskMap['Completed']!.remove(list[index]);
        list.remove(temp);
        completeIndex != -1 ? list.insert(completeIndex, temp) : list.add(temp);
      }
      widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
    });
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

  Widget expandTrailing(int index, List<Task> list) {
    const Icon show = Icon(Icons.expand_more);
    return showDetails && list[index].subtasks.isNotEmpty
        ? IconButton(
            onPressed: () => setState(
              () {
                list[index].isExpand = !list[index].isExpand;
                widget.file
                    .updateUser(id: widget.user.id, updatedUser: widget.user);
              },
            ),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: list[index].isExpand
                    ? Tween<double>(begin: 0, end: 1).animate(animation)
                    : Tween<double>(begin: 1, end: 0.25).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: show,
            ),
          )
        : const SizedBox.shrink();
  }

  Widget taskListTile(int index, List<Task> list) {
    return Opacity(
      opacity: list[index].isCompleted ? 0.5 : 1,
      child: ListTile(
        horizontalTitleGap: 5,
        minLeadingWidth: 10,
        leading: Checkbox(
          value: list[index].isCompleted,
          onChanged: (bool? value) {
            updateComplete(list, index, value);
          },
        ),
        trailing: expandTrailing(index, list),
        title: Text(list[index].title),
      ),
    );
  }

  PopupMenuButton<int> sortButton() {
    return PopupMenuButton<int>(
        onSelected: (item) => filterTasks(context, item),
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

  PopupMenuButton<int> menuButton() {
    return PopupMenuButton<int>(
        onSelected: (item) => onSelected(context, item),
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    !showDetails
                        ? const Icon(Icons.preview)
                        : const Icon(Icons.disabled_by_default_outlined),
                    const SizedBox(width: 10),
                    !showDetails
                        ? const Text("Show Details")
                        : const Text("Hide Details"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      !showComplete
                          ? const Icon(Icons.preview)
                          : const Icon(Icons.disabled_by_default_outlined),
                      const SizedBox(width: 10),
                      !showComplete
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    initState();
    return Scaffold(
      drawer: SideDrawer(
        user: widget.user,
        file: widget.file,
      ),
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
            ],
          ),
          ReorderableSliverList(
            delegate: ReorderableSliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) return Text("Tasks");
                if (index <= widget.user.taskMap[appBarTitle]!.length) {
                  if (!showComplete &&
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
                                  child: taskListTile(index - 1,
                                      widget.user.taskMap[appBarTitle]!)),
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
                                        showDetails
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
                                              child: taskListTile(
                                                  num,
                                                  widget
                                                      .user
                                                      .taskMap[appBarTitle]![
                                                          index - 1]
                                                      .subtasks),
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
