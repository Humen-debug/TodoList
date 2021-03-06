import 'package:flutter/material.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Screens/Calender/calender_screen.dart';
import 'package:todo_list/Screens/Statistic/statistic_screen.dart';
import 'package:todo_list/Screens/Task/task_screen.dart';
import 'package:todo_list/Models/user.dart';
import 'package:todo_list/Models/task.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  FileHandler fileHandler = FileHandler.instance;
  late User user = User(
      id: 0,
      name: "",
      email: "",
      showComplete: true,
      showDetails: false,
      sortIndex: 0,
      taskMap: <String, List<Task>>{'All': [], 'Inbox': [], 'Completed': []});
  late List<User> users = [];

  @override
  void initState() {
    // fileHandler.deleteUser(user);

    fileHandler.readUsers().then((List<User> userList) {
      setState(() {
        try {
          users = userList;
          int id = 0;
          if (users.isNotEmpty) {
            for (int i = 0; i < users.length; i++) {
              if (id == i) {
                user = users[i];
                // print(user);
                break;
              }
            }
          } else {
            user = User(
                id: id,
                name: "",
                email: "",
                showComplete: true,
                showDetails: false,
                sortIndex: 0,
                taskMap: <String, List<Task>>{
                  'All': [],
                  'Inbox': [],
                  'Completed': []
                });
          }
        } on Exception catch (e) {
          print(e);
          fileHandler.deleteUser(user);
        }
      });
    });
    super.initState();
  }

  int _selectedIndex = 0;
  static String currentList = "All";

  @override
  Widget build(BuildContext context) {
    final _pages = [
      TaskScreen(user: user, file: fileHandler),
      StatisticScreen(
        user: user,
        file: fileHandler,
      ),
      CalenderScreen(
        user: user,
        file: fileHandler,
      ),
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
