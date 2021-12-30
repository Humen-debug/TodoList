import 'package:flutter/material.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Screens/Calender/calender_screen.dart';
import 'package:todo_list/Screens/Task/task_screen.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  FileHandler fileHandler = FileHandler.instance;
  late User user = const User(
      id: 0,
      name: "",
      email: "",
      taskMap: <String, List<Task>>{'All': [], 'Inbox': [], 'Completed': []});
  late List<User> users = [];
  int _selectedIndex = 0;
  static String currentList = "All";
  @override
  void initState() {
    // super.initState();
    // fileHandler.deleteFile();
    fileHandler.readUsers().then((List<User> userList) {
      setState(() {
        try {
          users = userList;
          int id = 0;
          if (users.isNotEmpty) {
            for (int i = 0; i < users.length; i++) {
              if (id == i) {
                user = users[i];
                break;
              }
            }
          } else {
            user = User(
                id: id,
                name: "",
                email: "",
                taskMap: <String, List<Task>>{
                  'All': [],
                  'Inbox': [],
                  'Completed': []
                });
          }
        } on Exception catch (e) {
          print(e);
          // fileHandler.deleteUser(user);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initState();
    // print('${MediaQuery.of(context).platformBrightness}');
    // print('${Theme.of(context).brightness}');
    final _pages = [
      TaskScreen(user: user, file: fileHandler),
      Center(child: Text('Home')),
      CalenderScreen(),
      Center(child: Text('Person')),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_rounded), label: 'Task'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calender'),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity), label: 'Person'),
        ],
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
