import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Widgets/buildTaskSheet.dart';
import 'package:todo_list/Widgets/time_picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Models/theme.dart';

class UpdateTaskScreen extends StatefulWidget {
  Task task;
  User user;
  FileHandler file;

  UpdateTaskScreen(
      {Key? key, required this.user, required this.file, required this.task})
      : super(key: key);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  late Task subtask;
  int get completeIndex =>
      widget.task.subtasks.indexWhere((task) => task.isCompleted == true);

  TextEditingController taskController = TextEditingController();

  final menuElementTitles = const <String>['Edit'];

  final menuElementIcons = const <Icon>[Icon(Icons.edit)];

  void setDefault() {
    setState(() => subtask = Task(
          title: "",
          date: null,
          isCompleted: false,
          isExpand: false,
          isAllDay: true,
          time: "",
          createdTime: DateTime.now(),
          completedTime: null,
          status: "",
          subtasks: [],
        ));
  }

  void createTask() {
    if (subtask.title == '') return;
    var newTask = Task(
      title: subtask.title,
      date: subtask.date,
      isCompleted: false,
      isExpand: false,
      isAllDay: true,
      time: subtask.time,
      createdTime: subtask.createdTime,
      completedTime: subtask.completedTime,
      status: subtask.status,
      subtasks: subtask.subtasks,
    );
    setDefault();
    completeIndex != -1
        ? widget.task.subtasks.insert(completeIndex, newTask)
        : widget.task.subtasks.add(newTask);
    widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
  }

  void updateComplete(List<Task> list, int index, bool? flag) {
    final Task temp = list[index];
    setState(() {
      list[index].isCompleted = flag!;
      if (list[index].isCompleted == true) {
        list[index].completedTime = DateTime.now();
        list.removeAt(index);
        list.add(temp);
      } else {
        list[index].completedTime = null;
        list.removeAt(index);
        completeIndex != -1 ? list.insert(completeIndex, temp) : list.add(temp);
      }
      widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
    });
  }

  void buildTask(BuildContext context) {
    setDefault();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BuildTaskSheet(
              context: context, task: subtask, createTask: createTask);
        });
  }

  Widget menuBtn() {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (context) {
        return List.generate(
            menuElementTitles.length,
            (index) => PopupMenuItem(
                onTap: () {
                  switch (index) {
                    case 0:
                      break;
                    default:
                  }
                },
                child: Row(
                  children: [
                    menuElementIcons[index],
                    const SizedBox(width: 10),
                    Text(menuElementTitles[index])
                  ],
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String appTitle = MainScreenState.currentList;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        elevation: 0.0,
        title: Text(appTitle),
        actions: <Widget>[menuBtn()],
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              LinearProgressIndicator(
                value: widget.task.getProgress,
                minHeight: 50,
                valueColor: AlwaysStoppedAnimation<Color>(themeProvider.islight
                    ? Colors.grey.shade300
                    : Colors.grey.shade800),
                backgroundColor: Colors.transparent,
              ),
              Checkbox(value: widget.task.isCompleted, onChanged: (value) {}),
              Positioned(
                left: 48,
                child: TextButton(
                    onPressed: () {},
                    child: widget.task.getDeadline == "none"
                        ? const Text(
                            "Date",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )
                        : Text(widget.task.getDeadline,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700))),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: widget.task.title,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        onChanged: (String title) => setState(() {
                          if (title != "") {
                            widget.task.title = title;
                            widget.file.updateUser(
                                id: widget.user.id, updatedUser: widget.user);
                          }
                        }),
                        onFieldSubmitted: (String title) => setState(() {
                          widget.task.title = title;
                          widget.file.updateUser(
                              id: widget.user.id, updatedUser: widget.user);
                        }),
                      ),
                      TextFormField(
                        maxLines: null,
                        minLines: null,
                        initialValue: widget.task.status,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: "Note"),
                        onChanged: (String descript) => setState(() {
                          widget.task.status = descript;
                          widget.file.updateUser(
                              id: widget.user.id, updatedUser: widget.user);
                        }),
                      ),
                    ],
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: widget.task.subtasks.isEmpty
                        ? 1
                        : (widget.task.subtasks.length) + 1,
                    itemBuilder: (context, index) {
                      if (index == widget.task.subtasks.length) {
                        return TextButton.icon(
                          onPressed: () => buildTask(context),
                          icon: const Icon(Icons.add),
                          label: const Text("Add subtask"),
                          style: const ButtonStyle(
                            alignment: Alignment.centerLeft,
                          ),
                        );
                      } else {
                        final item = widget.task.subtasks[index];
                        return Dismissible(
                          key: Key(item.title + item.createdTime.toString()),
                          onDismissed: (direction) {
                            setState(() {
                              widget.task.subtasks.remove(item);
                              widget.file.updateUser(
                                  id: widget.user.id, updatedUser: widget.user);
                            });
                          },
                          background: const Card(color: Colors.red),
                          child: Opacity(
                              opacity: widget.task.subtasks[index].isCompleted
                                  ? 0.5
                                  : 1,
                              child: ListTile(
                                horizontalTitleGap: 5,
                                minLeadingWidth: 10,
                                leading: Checkbox(
                                  value:
                                      widget.task.subtasks[index].isCompleted,
                                  onChanged: (value) => updateComplete(
                                      widget.task.subtasks, index, value),
                                ),
                                title: Text(widget.task.subtasks[index].title),
                              )),
                        );
                      }
                    }),
              ),
            ],
          )
        ]),
      ),
    ]));
  }
}
