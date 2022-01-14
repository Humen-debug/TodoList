import 'package:flutter/material.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Screens/Task/add_list_screen.dart';

import 'package:todo_list/Models/user.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Screens/Settings/profile_screen.dart';
import 'package:todo_list/Screens/Settings/setting_screen.dart';

class SideDrawer extends StatefulWidget {
  User user;
  FileHandler file;

  SideDrawer({Key? key, required this.user, required this.file})
      : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final categories = <Widget>[];
  List<String> get listNames => widget.user.taskMap.keys.toList();
  List<int> get taskNum {
    List<int> counts = [];
    for (List list in widget.user.taskMap.values) {
      counts.add(list.length);
    }
    return counts;
  }

  Widget tasklistListView(BuildContext context, categories) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: categories.length,
        itemBuilder: (context, int index) {
          return categories[index];
        });
  }

  Widget listTitle(int index) {
    return Row(
      children: [
        Text(listNames[index]),
        const Spacer(),
        Text(taskNum[index] == 0
            ? ''
            : taskNum[index] > 99
                ? '99+'
                : taskNum[index].toString())
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Problem: lists are not instantly update state
    for (int index = 0; index < widget.user.taskMap.length; index++) {
      categories.add(ListTile(
        title: listTitle(index),
        onTap: () {
          setState(() {
            MainScreenState.currentList = listNames[index];
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        },
      ));
    }
    return Drawer(
        child: Column(
      children: [
        SizedBox(
          height: 175,
          child: DrawerHeader(
              child: Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  margin: const EdgeInsets.only(right: 10, left: 5),
                  child: CircleAvatar(
                      radius: 24,
                      child: IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen())),
                        icon: const Icon(Icons.person),
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.user.name,
                          style: const TextStyle(fontSize: 20.0)),
                      const SizedBox(height: 2),
                      Text(widget.user.email),
                    ],
                  ),
                ),
              ]),
              // might move to the bottom of drawer, following Add List
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen())),
                    icon: const Icon(Icons.settings),
                    splashRadius: 15,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                      splashRadius: 15),
                ],
              ),
            ],
          )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 313,
          child: tasklistListView(context, categories),
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 4,
              child: TextButton.icon(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddListScreen(
                            user: widget.user, file: widget.file))),
                icon: const Icon(Icons.add),
                label: const Text("Add List"),
                style: const ButtonStyle(
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
            Expanded(
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.toc))),
          ],
        ),
      ],
    ));
  }
}
