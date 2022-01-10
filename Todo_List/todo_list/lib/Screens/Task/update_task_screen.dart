import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Widgets/task_list_tile.dart';
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
      time: subtask.time,
      createdTime: subtask.createdTime,
      status: subtask.status,
      deadline: subtask.deadline,
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
        list.removeAt(index);
        list.add(temp);
      } else {
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
        builder: (BuildContext bottomContext) {
          return StatefulBuilder(builder: (context, state) {
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
              ]),
            );
          });
        });
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
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
        ],
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              LinearProgressIndicator(
                value: widget.task.setProgress,
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
                    child: widget.task.deadline == "No Deadline"
                        ? const Text(
                            "Date",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )
                        : Text(widget.task.deadline,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700))),
              ),
            ],
          ),
          Column(
            children: [
              TextFormField(
                initialValue: widget.task.title,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (String title) => setState(() {
                  if (title != "") {
                    widget.task.title = title;
                    widget.file.updateUser(
                        id: widget.user.id, updatedUser: widget.user);
                  }
                }),
                onFieldSubmitted: (String title) => setState(() {
                  widget.task.title = title;
                  widget.file
                      .updateUser(id: widget.user.id, updatedUser: widget.user);
                }),
              ),
              TextFormField(
                maxLines: null,
                minLines: null,
                initialValue: widget.task.status,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: "Description"),
                onChanged: (String descript) => setState(() {
                  widget.task.status = descript;
                  widget.file
                      .updateUser(id: widget.user.id, updatedUser: widget.user);
                }),
              ),
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
