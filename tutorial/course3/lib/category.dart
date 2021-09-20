// import 'dart:ffi';
import 'package:flutter/material.dart';
import 'converter_route.dart';
import 'unit.dart';

final _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 5);

class Category extends StatelessWidget {
  final String name;
  final Color color;
  final IconData iconLocation;
  final List<Unit> units;

  const Category({
    Key? key,
    required this.name,
    required this.color,
    required this.iconLocation,
    required this.units,
  });

  void _navigateToConverter(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: color,
            title: Text(name.toUpperCase(), style: TextStyle(fontSize: 24),)
          ),
          body: ConverterScreen(
            units: units,
            color: color,
          )
        );
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: _borderRadius,
      // color: Colors.greenAccent[100],
      child: Container(
        margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        height: _rowHeight,
        child: InkWell(
          borderRadius: _borderRadius,
          highlightColor: color,
          splashColor: color,
          onTap: () => _navigateToConverter(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    iconLocation,
                    size: 60.0,
                  ),
                ),
                Center(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
