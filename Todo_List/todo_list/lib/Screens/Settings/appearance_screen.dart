import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/Models/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({Key? key}) : super(key: key);

  @override
  _AppearanceScreenState createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
    Colors.grey,
  ];
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.grey)),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
              Widget>[
            const Text("Switch mode"),
            FlutterSwitch(
                value: themeProvider.islight,
                activeColor: Colors.amber.shade800,
                activeIcon: const Icon(Icons.light_mode, color: Colors.amber),
                inactiveIcon: const Icon(Icons.dark_mode, color: Colors.black),
                onToggle: (value) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                })
          ]),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(30),
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            crossAxisCount: 5,
            children: List.generate(_baseColors.length, (index) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    final provider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    provider.setThemeKey(index);
                  });
                },
                child: const SizedBox(),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    splashFactory: InkRipple.splashFactory,
                    side: index == themeKey
                        ? const BorderSide(width: 3, color: Colors.white54)
                        : BorderSide.none,
                    primary: _baseColors[index],
                    elevation: 0.5),
              );
            }),
          ),
        ],
      ),
    );
  }
}
