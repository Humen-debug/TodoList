import 'package:flutter/material.dart';
import 'package:todo_list/Screens/Task/add_list_screen.dart';
import 'package:todo_list/Screens/Task/task_screen.dart';
import 'package:todo_list/Screens/main_screen.dart';
import 'package:todo_list/Screens/profile_screen.dart';
import 'package:todo_list/Screens/setting_screen.dart';

class SideDrawer extends StatefulWidget {
  SideDrawer({Key? key}) : super(key: key);

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
    for (int index = 0; index < MainScreenState.taskMap.length; index++) {
      List<String> listNames = MainScreenState.taskMap.keys.toList();
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
          height: 172,
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
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      // ignore: prefer_const_constructors
                      Text('User_name',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                      SizedBox(height: 2),
                      Text('user@gmail.com'),
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
          height: MediaQuery.of(context).size.height - 310,
          child: tasklistListView(context, categories),
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 4,
              child: TextButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddListScreen())),
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
