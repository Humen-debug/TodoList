import 'package:flutter/material.dart';
import 'package:todo_list/Models/theme.dart';
import 'Screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  FileHandler fileHandler = FileHandler.instance;
  late User user = User(
      id: 0,
      name: "",
      email: "",
      showComplete: true,
      showDetails: false,
      taskMap: <String, List<Task>>{'All': [], 'Inbox': [], 'Completed': []});
  late List<User> users = [];

  void initState() {
    fileHandler.deleteFile();
    print(user);

    fileHandler.readUsers().then((List<User> userList) {
      try {
        print(user);
        users = userList;
        int id = 0;
        if (users.isNotEmpty) {
          for (int i = 0; i < users.length; i++) {
            if (id == i) {
              user = users[i];
              // print("$currentList: ${user.taskMap['currentList']}");
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
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        initState();
        final theme = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo List',
          themeMode: theme.themeMode,
          theme: theme.lighttheme,
          darkTheme: theme.darktheme,
          home: MainScreen(file: fileHandler, user: user),
        );
      });
}
