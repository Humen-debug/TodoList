import 'package:flutter/material.dart';
import '/Widgets/date_picker.dart';
import '/Widgets/time_picker.dart';


class TaskScreen extends StatefulWidget {
  TaskScreen({Key? key}) : super(key: key);
  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  final appBarTitle = "Welcome";

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
    }
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
                    decoration: InputDecoration(
                      labelText: 'Add Task',
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {},
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
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
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
          )
        ],
      ),
    );
  }
}
