import 'package:flutter/material.dart';
import 'package:todo_list/Screens/Calender/calender_screen.dart';
import 'package:todo_list/Screens/Task/task_screen.dart';
import 'package:todo_list/Models/task.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static String currentList = "Inbox";
  static var taskMap = <String, List<Task>>{
    'Inbox': [],
    'Completed': [],
  };
  @override
  Widget build(BuildContext context) {
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
            // print(taskMap[currentList].toString());
          });
        },
      ),
    );
  }
}
