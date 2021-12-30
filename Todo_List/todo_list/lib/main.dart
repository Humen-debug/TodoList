import 'package:flutter/material.dart';
import 'package:todo_list/Models/theme.dart';
import 'Screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(Themes.lighttheme),
      builder: (context, _) {
        final theme = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo List',
          themeMode: ThemeProvider.themeMode,
          theme: Themes.lighttheme,
          darkTheme: Themes.darktheme,
          home: MainScreen(),
        );
      });
}
