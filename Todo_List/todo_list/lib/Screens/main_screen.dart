import 'dart:io';
import 'dart:convert';
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
  late User user;
  late List<User> users;
  int _selectedIndex = 0;
  static String currentList = "Inbox";
  static var taskMap = <String, List<Task>>{
    'Inbox': [],
    'Completed': [],
  };
  @mustCallSuper
  void initState() {
    // super.initState();
    fileHandler.readUsers().then((List<User> userList) {
      setState(() {
        user = User(id: 1, email: "", name: "", taskMap: taskMap);
        users = userList;
        for (int i = 0; i < users.length; i++) {
          if (users[i].id == user.id) break;
        }
      });
    });
    // fileHandler.writeUser(user);
  }

  @override
  Widget build(BuildContext context) {
    fileHandler.file;
    initState();
    // print(fileHandler.toString());

    final _pages = [
      TaskScreen(),
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
            print(taskMap[currentList].toString());
          });
        },
      ),
    );
  }
}
