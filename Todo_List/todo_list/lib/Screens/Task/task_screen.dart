import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Screens/Task/update_task_screen.dart';
import 'package:todo_list/Widgets/drawer.dart';
import 'package:todo_list/Models/theme.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Widgets/time_picker_widget.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({Key? key}) : super(key: key);
  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  final appBarTitle = MainScreenState.currentList;
  late Task task;
  List<Task> list = [];
  TextEditingController taskController = TextEditingController();
  bool showComplete = true;
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
    setState(() => sortIcon = sortIcons[item]);
    switch (item) {
      case 0:
        setState(() => reOrder = !reOrder);
        break;
      case 1:
        list.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case 2:
        list.sort((a, b) => a.text.compareTo(b.text));
        break;
      case 3:
        break;
    }
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        setState(() {
          showComplete = !showComplete;
        });
    }
  }

  void setDefault() {
    setState(() => task = Task("", null, false, "", DateTime.now(), "",
        const Text("No Deadline"), []));
  }

  void createTask() {
    if (task.text == '') return;
    var newTask = Task(task.text, task.date, false, task.time, task.createdTime,
        task.status, task.deadline, task.subtasks);
    setDefault();
    list.add(newTask);
    MainScreenState.taskMap[appBarTitle] = list;
    // setState(() {
    //   setDefault();
    //   list.add(newTask);
    //   MainScreenState.taskMap[appBarTitle] = list;
    //   // print(MainScreenState.taskMap[appBarTitle].toString());
    // });
  }

  void updateComplete(int index, bool? flag) {
    setState(() {
      MainScreenState.taskMap[appBarTitle]![index].isCompleted = flag!;
      if (MainScreenState.taskMap[appBarTitle]![index].isCompleted == true) {
        MainScreenState.taskMap['Completed']!
            .add(MainScreenState.taskMap[appBarTitle]![index]);
        MainScreenState.taskMap[appBarTitle]!.removeAt(index);
      }
    });
  }

  void buildTask(BuildContext context) {
    setDefault();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bottomContext) {
          return StatefulBuilder(builder: (buttomContext, state) {
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
                      onChanged: (String text) {
                        setState(() => task.text = text);
                      },
                      onSubmitted: (String text) {
                        setState(() {
                          task.text = text;
                          createTask();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      // NOT WORK
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
            ]);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // ScrollController _scrollController =
    //     PrimaryScrollController.of(context) ?? ScrollController();

    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        Task row = list.removeAt(oldIndex);
        list.insert(newIndex, row);
      });
    }

    return Scaffold(
      drawer: SideDrawer(),
      floatingActionButton: FloatingActionButton(
          splashColor: Colors.white60,
          elevation: 4.0,
          highlightElevation: 0.0,
          child: const Icon(Icons.add),
          onPressed: () {
            buildTask(context);
          }),
      body: CustomScrollView(
        // controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            elevation: 0.0,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(appBarTitle),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                );
              },
            ),
            actions: <Widget>[
              PopupMenuButton<int>(
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
                  }),
              PopupMenuButton<int>(
                  onSelected: (item) => onSelected(context, item),
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              showComplete == true
                                  ? const Icon(Icons.preview)
                                  : const Icon(
                                      Icons.disabled_by_default_outlined),
                              const SizedBox(width: 10),
                              showComplete == true
                                  ? const Text("Show Completed")
                                  : const Text("Hide Completed"),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            children: const [
                              Icon(Icons.edit),
                              SizedBox(width: 10),
                              Text("Select")
                            ],
                          ),
                        ),
                      ])
            ],
          ),
          ReorderableSliverList(
            delegate: ReorderableSliverChildBuilderDelegate(
              // index: taskMap[currentList][index]
              (context, index) {
                if (index == 0) return Text("Tasks");
                index--;
                if (index <= MainScreenState.taskMap[appBarTitle]!.length) {
                  return Card(
                      elevation: 0.1,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: themeProvider.islight
                                ? MaterialStateProperty.all<Color>(Colors.white)
                                : MaterialStateProperty.all<Color>(
                                    Colors.grey.shade800)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateTaskScreen(
                                  task: MainScreenState
                                      .taskMap[appBarTitle]![index],
                                ),
                              ));
                        },
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 45,
                              child: ListTile(
                                leading: Checkbox(
                                  value: MainScreenState
                                      .taskMap[appBarTitle]![index].isCompleted,
                                  onChanged: (bool? value) {
                                    updateComplete(index, value);
                                  },
                                ),
                                title: Text(MainScreenState
                                    .taskMap[appBarTitle]![index].text),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 80),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: MainScreenState
                                          .taskMap[appBarTitle]![index]
                                          .deadline),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                }
                return const Text("Completed");
              },
              childCount: MainScreenState.taskMap[appBarTitle]!.isEmpty
                  ? 1
                  : MainScreenState.taskMap[appBarTitle]!.length + 1,
            ),
            onReorder: _onReorder,
          )
        ],
      ),
    );
  }
}
