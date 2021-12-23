import 'package:flutter/material.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Models/task.dart';

class AddListScreen extends StatefulWidget {
  Map<String, List<Task>> taskMap;

  // ignore: prefer_const_constructors_in_immutables
  AddListScreen({Key? key, required this.taskMap}) : super(key: key);
  @override
  AddListScreenState createState() => AddListScreenState();
}

class AddListScreenState extends State<AddListScreen> {
  TextEditingController textFieldController = TextEditingController();
  String newListName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add List"),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close)),
        actions: [
          IconButton(
              onPressed: () async {
                if (newListName == "") {
                  return showDialog(
                    context: context,
                    builder: (contex) => AlertDialog(
                      content: Text("List name is empty"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("I KNOW"))
                      ],
                    ),
                  );
                }
                setState(() {
                  widget.taskMap[newListName] = [];
                  print(widget.taskMap);
                });
                Navigator.pop(context);
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          TextField(
            controller: textFieldController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'List Name',
            ),
            onChanged: (String text) {
              setState(() {
                newListName = text;
              });
            },
          )
        ]),
      ),
    );
  }
}
