import 'package:flutter/material.dart';

int themeKey = 0;
set setThemeKey(key) => themeKey = key;
final List<List<Color>> themeColors = <List<Color>>[
  [
    Colors.teal.shade400,
    Colors.teal.shade600,
    Colors.teal.shade200,
    Colors.teal.shade300,
    Colors.teal.shade50,
  ],
  [
    Colors.orange.shade400,
    Colors.orange.shade600,
    Colors.orange.shade200,
    Colors.orange.shade300,
    Colors.orange.shade50,
  ],
  [
    Colors.pink.shade400,
    Colors.pink.shade600,
    Colors.pink.shade200,
    Colors.pink.shade300,
    Colors.pink.shade50
  ],
  [
    Colors.blue.shade400,
    Colors.blue.shade600,
    Colors.blue.shade200,
    Colors.blue.shade300,
    Colors.blue.shade50,
  ],
  [
    Colors.amber.shade400,
    Colors.amber.shade600,
    Colors.amber.shade200,
    Colors.amber.shade300,
    Colors.amber.shade50,
  ],
  [
    Colors.green.shade400,
    Colors.green.shade600,
    Colors.green.shade200,
    Colors.green.shade300,
    Colors.green.shade50,
  ],
  [
    Colors.purple.shade400,
    Colors.purple.shade600,
    Colors.purple.shade200,
    Colors.purple.shade300,
    Colors.purple.shade50,
  ],
  [
    Colors.red.shade400,
    Colors.red.shade600,
    Colors.red.shade200,
    Colors.red.shade300,
    Colors.red.shade50,
  ],
  [
    Colors.grey.shade400,
    Colors.grey.shade600,
    Colors.grey.shade200,
    Colors.grey.shade300,
    Colors.grey.shade50,
  ],
];

// final textTheme = const TextTheme(
//   headline1: TextStyle(),

// );

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  ThemeProvider();

  bool get islight {
    if (themeMode == ThemeMode.light) return true;
    return false;
  }

  void setThemeKey(int key) {
    themeKey = key;
    notifyListeners();
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  ThemeData get darktheme => ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade900,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff121212), elevation: 0.0),
        colorScheme: ColorScheme.dark(
          primary: themeColors[themeKey][0],
          primaryVariant: themeColors[themeKey][1],
          secondary: themeColors[themeKey][2],
          secondaryVariant: themeColors[themeKey][3],
          // onPrimary: themeColors[themeKey][0],
          onSurface: themeColors[themeKey][3],
          onBackground: themeColors[themeKey][2],
        ),
      );
  ThemeData get lighttheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          backgroundColor: Colors.grey.shade50,
          foregroundColor: themeColors[themeKey][0],
        ),
        colorScheme: ColorScheme.light(
          // onPrimary: themeColors[themeKey][0],
          primary: themeColors[themeKey][0],
          primaryVariant: themeColors[themeKey][1],
          secondary: themeColors[themeKey][2],
          secondaryVariant: themeColors[themeKey][3],
        ),
      );
}
