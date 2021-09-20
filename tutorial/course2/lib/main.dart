import 'package:flutter/material.dart';
import 'category.dart';

const _categoryName = 'Cake';
const _categoryIcon = Icons.cake;
const _categoryColor = Colors.green;

/* This is my first app created by flutter on 30.August.2021
It follows the steps of tutorial in udacity.com */
void main() {
  runApp(UnitConvertApp());
}

class UnitConvertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Convrtor',
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Category(
            key: UniqueKey(),
            name: _categoryName,
            color: _categoryColor,
            iconLocation: _categoryIcon
          ),
        ),
      ),
    );
  }
}
