import 'package:flutter/material.dart';
import 'Screens/Task/task_screen.dart';
import 'Screens/Home/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      // darkTheme: ThemeDeta.dark(),
      home: HomeScreen(),
    );
  }
}
