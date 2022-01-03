import 'package:flutter/material.dart';
import 'package:todo_list/Models/theme.dart';
import 'Screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final theme = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo List',
          themeMode: theme.themeMode,
          theme: theme.lighttheme,
          darkTheme: theme.darktheme,
          home: MainScreen(),
        );
      });
}
