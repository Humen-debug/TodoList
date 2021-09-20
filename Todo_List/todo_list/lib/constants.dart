import 'package:flutter/material.dart';

final ThemeData light_themes = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.transparent,
    secondary: Colors.cyan.shade50,
    background: Colors.cyan,
    brightness: Brightness.light,
  )
);

final ThemeData dark_themes = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.transparent,
    secondary: Colors.cyan.shade50,
    background: Colors.cyan,
    brightness: Brightness.dark,
  )
);
