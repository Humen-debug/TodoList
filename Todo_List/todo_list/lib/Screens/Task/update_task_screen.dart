import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Widgets/time_picker_widget.dart';

class UpdateTaskScreen extends StatefulWidget {
  final index;
  UpdateTaskScreen({Key? key, required this.index}) : super(key: key);

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
    setState(() {
      setDefault();
      MainScreenState
          .taskMap[MainScreenState.currentList]?[widget.index].subtasks
          .add(newTask);
      // print(MainScreenState.taskMap[appBarTitle].toString());
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

  Widget subtasksListView(BuildContext context, subtasks) {
    return ListView.builder(
      itemCount: subtasks.length,
      itemBuilder: (context, index) => subtasks[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController taskController = TextEditingController();
    String appTitle = MainScreenState.currentList;

    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          actions: <Widget>[
            IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            TextFormField(
              // controller: taskController,
              initialValue:
                  MainScreenState.taskMap[appTitle]![widget.index].text,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              onFieldSubmitted: (String text) => setState(() =>
                  MainScreenState.taskMap[appTitle]![widget.index].text = text),
            ),
            TextFormField(
              initialValue:
                  MainScreenState.taskMap[appTitle]![widget.index].status,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Description"),
              onChanged: (String descript) => setState(
                () => MainScreenState.taskMap[appTitle]![widget.index].status =
                    descript,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 258,
              child: ListView.builder(
                  itemCount: MainScreenState
                          .taskMap[MainScreenState.currentList]![widget.index]
                          .subtasks
                          .isEmpty
                      ? 1
                      : (MainScreenState
                              .taskMap[MainScreenState.currentList]![
                                  widget.index]
                              .subtasks
                              .length) +
                          1,
                  itemBuilder: (context, index) {
                    if (index ==
                        MainScreenState
                            .taskMap[MainScreenState.currentList]![widget.index]
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
                      return ListTile(
                        title: Text(
                          MainScreenState
                              .taskMap[MainScreenState.currentList]![
                                  widget.index]
                              .subtasks[index]
                              .text,
                        ),
                        leading: Checkbox(
                          value: MainScreenState
                              .taskMap[MainScreenState.currentList]![
                                  widget.index]
                              .subtasks[index]
                              .isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              MainScreenState
                                  .taskMap[MainScreenState.currentList]![
                                      widget.index]
                                  .subtasks[index]
                                  .isCompleted = value!;
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
