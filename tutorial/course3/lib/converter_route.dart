import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'unit.dart';

//TODO Pass the name, color, and units to the ConverterRoute.
//TODO The background color of each unit should be the same as the ConverterRoute's AppBar color.

const rowHeight = 60.0;

class ConverterScreen extends StatefulWidget {
  final Color color;
  final List<Unit> units;

  const ConverterScreen({
    required this.units,
    required this.color,
  });

  @override
  ConverterScreenState createState() => ConverterScreenState();
}

class ConverterScreenState extends State<ConverterScreen> {
  late Unit fromValue;
  late Unit toValue;
  late double inputValue;
  String convertedValue = '';
  late List<DropdownMenuItem> unitMenuItems;
  bool showValidationError = false;

  @override
  void initState() {
    super.initState();
    createDropdownMenuItems();
    setDefaults();
  }

  void createDropdownMenuItems() {
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      newItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      unitMenuItems = newItems;
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s.
  void setDefaults() {
    setState(() {
      fromValue = widget.units[0];
      toValue = widget.units[1];
    });
  }

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  void updateConversion() {
    setState(() {
      convertedValue =
          format(inputValue * (toValue.conversion / fromValue.conversion));
    });
  }

  void updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        convertedValue = '';
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          final inputDouble = double.parse(input);
          showValidationError = false;
          inputValue = inputDouble;
          updateConversion();
        } on Exception catch (e) {
          print('Error: $e');
          showValidationError = true;
        }
      }
    });
  }

  Unit getUnit(String unitName) {
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  void updateFromConversion(dynamic unitName) {
    setState(() {
      fromValue = getUnit(unitName);
    });
    if (inputValue != null) {
      updateConversion();
    }
  }

  void updateToConversion(dynamic unitName) {
    setState(() {
      toValue = getUnit(unitName);
    });
    if (inputValue != null) {
      updateConversion();
    }
  }

  Widget createDropdown(String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: Colors.grey[50],
        border: Border.all(
          color: const Color(000000),
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              items: unitMenuItems,
              onChanged: onChanged,
              // style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final input = Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            // style: Theme.of(context).textTheme.display1,
            decoration: InputDecoration(
              // labelStyle: Theme.of(context).textTheme.display1,
              errorText: showValidationError ? 'Invalid number entered' : null,
              labelText: 'Input',
              border: OutlineInputBorder( borderRadius: BorderRadius.circular(0.0),),
            ),
            keyboardType: TextInputType.number,
            onChanged: updateInputValue,
          ),
          createDropdown(fromValue.name,updateToConversion),
        ],
      )
    );

    final arrows = RotatedBox(
      quarterTurns:1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final output = Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            child: Text(
              convertedValue,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              border:OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          createDropdown(toValue.name ,updateToConversion),
        ],
      )
    );

    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:[
        input,
        arrows,
        output,
      ]
    );
    return Padding (
      padding: EdgeInsets.all(16.0),
      child: converter,
    );
  }
}
