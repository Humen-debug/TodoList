import 'package:flutter/material.dart';
import 'category.dart';
import 'unit.dart';

class CategoryScreen extends StatefulWidget{
  const CategoryScreen();

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen> {
  
  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];
  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];
  static const _iconLocations = <IconData>[
    Icons.straighten,
    Icons.format_shapes,
    Icons.grid_on,
    Icons.monitor_weight,
    Icons.access_time,
    Icons.folder,
    Icons.battery_full,
    Icons.attach_money,
  ];

// In order to easily call out the catergories,
// here build a List<Widget>
  Widget _buildCategoryWidgets(List<Widget> categories) {
    return ListView.builder(
        itemCount: _categoryNames.length,
        itemBuilder: (BuildContext context, int index) => categories[index],
        );
  }

  /// Returns a list of mock [Unit]s.
  List<Unit> _retrieveUnitList(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  Widget build(BuildContext context) {
    final categories = <Category>[];

    for (int index = 0; index < _categoryNames.length; index++) {
      categories.add(Category(
        name: _categoryNames[index],
        color: _baseColors[index],
        iconLocation: _iconLocations[index],
        units: _retrieveUnitList(_categoryNames[index]),
      ));
    }

    final listView = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: _buildCategoryWidgets(categories),
    );

    final appBar = AppBar(
      title: Text(
        'Unit Converter',
        style: TextStyle(fontSize: 30, color: Colors.blueGrey[800]),
      ),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    );

    return Scaffold(
      appBar: appBar,
      body: listView,
    );
  }
}
