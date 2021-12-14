import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Screens/main_screen.dart';

class UpdateTaskScreen extends StatefulWidget {
  final index;
  UpdateTaskScreen({Key? key, required this.index}) : super(key: key);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
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
          ]),
        )));
  }
}
