import 'package:flutter/material.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/user.dart';

class AddListScreen extends StatefulWidget {
  User user;
  FileHandler file;

  // ignore: prefer_const_constructors_in_immutables
  AddListScreen({Key? key, required this.file, required this.user})
      : super(key: key);
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
                      content: const Text("List name is empty"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("I KNOW"))
                      ],
                    ),
                  );
                }
                setState(() {
                  widget.user.taskMap[newListName] = [];
                  widget.file
                      .updateUser(id: widget.user.id, updatedUser: widget.user);
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
