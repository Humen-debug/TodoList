import 'package:flutter/material.dart';
import 'package:todo_list/Screens/Task/add_list_screen.dart';
// import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';

import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Screens/profile_screen.dart';
import 'package:todo_list/Screens/setting_screen.dart';

class SideDrawer extends StatefulWidget {
  User user;
  // Map<String, List<Task>> taskMap;
  SideDrawer({Key? key, required this.user}) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  Widget tasklistListView(BuildContext context, categories) {
    return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return categories[index];
        });
  }

  @override
  Widget build(BuildContext context) {
    final categories = <Widget>[];
    for (int index = 0; index < widget.user.taskMap.length; index++) {
      List<String> listNames = widget.user.taskMap.keys.toList();
      categories.add(ListTile(
        title: Text(listNames[index]),
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
                        icon: Icon(Icons.person),
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
                        builder: (context) =>
                            AddListScreen(taskMap: widget.user.taskMap))),
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
