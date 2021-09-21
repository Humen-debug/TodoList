import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import '/Widgets/date_picker.dart';
import '/Widgets/time_picker.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({Key? key}) : super(key: key);
  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  final appBarTitle = "Welcome";
  late Task task;
  late List<Task> taskList;
  TextEditingController taskController = TextEditingController();

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
    }
  }

  void updateTask() {
    task.task = taskController.text;
  }

  void buildTask(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bottomContext) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Add Task',
                    ),
                    onChanged: (value) => updateTask(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_upward_outlined),
                  ),
                )
              ],
            ),
            Flex(direction: Axis.horizontal, children: <Widget>[
              DatePicker(),
              TimePicker(),
              Expanded(
                  flex: 1,
                  child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.repeat_rounded),
                      label: const Text('Repeat'))),
            ])
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          splashColor: Colors.white60,
          elevation: 4.0,
          highlightElevation: 0.0,
          child: const Icon(Icons.add),
          onPressed: () => buildTask(context)),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(appBarTitle, style: TextStyle(color: Colors.grey)),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu, color: Colors.grey),
                );
              },
            ),
            actions: <Widget>[
              PopupMenuButton<int>(
                  onSelected: (item) => onSelected(context, item),
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  itemBuilder: (context) => [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Text("Change Theme"),
                        )
                      ])
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                // leading: Builder(builder: (context) {
                //   return Checkbox(
                //       value: task.isCompleted,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           task.isCompleted = value!;
                //         });
                //       });
                // }),
                title: Text('Item $index'),
              ),
              childCount: 2,
            ),
          )
        ],
      ),
    );
  }
}
