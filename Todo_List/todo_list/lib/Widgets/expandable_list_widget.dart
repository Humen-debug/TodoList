import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';

class ExpandableList extends StatefulWidget {
  final List<Task> list;
  bool isExpanded = true;
  ExpandableList({Key? key, required this.list}) : super(key: key);

  @override
  _ExpandableListState createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList> {
  Widget taskListView(BuildContext context, tasks) {
    return ListView.builder(
        itemCount: tasks.lenght,
        itemBuilder: (BuildContext context, int index) {
          return Card();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ConstrainedBox(
          constraints: widget.isExpanded
              ? BoxConstraints()
              : BoxConstraints(maxHeight: 50.0),
          child: Card())
    ]);
  }
}
