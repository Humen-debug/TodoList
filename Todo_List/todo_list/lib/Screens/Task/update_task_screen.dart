import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Widgets/task_list_tile.dart';
import 'package:todo_list/Widgets/time_picker_widget.dart';

class UpdateTaskScreen extends StatefulWidget {
  Task task;
  UpdateTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  late Task subtask;
  TextEditingController taskController = TextEditingController();

  void setDefault() {
    setState(() => subtask = Task("", null, false, "", DateTime.now(), "",
        const Text("No Deadline"), []));
  }

  void createTask() {
    if (subtask.text == '') return;
    var newTask = Task(
        subtask.text,
        subtask.date,
        false,
        subtask.time,
        subtask.createdTime,
        subtask.status,
        subtask.deadline,
        subtask.subtasks);
    setDefault();
    widget.task.subtasks.add(newTask);
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
                      onChanged: (String text) {
                        setState(() => subtask.text = text);
                      },
                      onSubmitted: (String text) {
                        setState(() {
                          subtask.text = text;
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
            IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
          ],
          elevation: 0,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            TextFormField(
              // controller: taskController,
              initialValue: widget.task.text,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              onFieldSubmitted: (String text) =>
                  setState(() => widget.task.text = text),
            ),
            TextFormField(
              initialValue: widget.task.status,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Description"),
              onChanged: (String descript) => setState(
                () => widget.task.status = descript,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 258,
              child: ListView.builder(
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
                      return
                          // TaskListTile(
                          //     tasks: widget.task.subtasks,
                          //     task: widget.task.subtasks[index]);
                          ListTile(
                        title: Text(
                          widget.task.subtasks[index].text,
                        ),
                        leading: Checkbox(
                          value: widget.task.subtasks[index].isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              widget.task.subtasks[index].isCompleted = value!;
                            });
                          },
                        ),
                      );
                    }
                  }),
            )
          ]),
        )));
  }
}
