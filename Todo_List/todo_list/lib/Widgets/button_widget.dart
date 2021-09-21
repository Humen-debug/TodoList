import 'package:flutter/material.dart';

class ButtonHeaderWidget extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onClicked;
  final IconData icon;
  final Color color;
  const ButtonHeaderWidget({
    Key? key,
    required this.title,
    required this.text,
    required this.onClicked,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => HeaderWidget(
      title: title,
      child: ButtonWidget(
        text: text,
        onClicked: onClicked,
        icon: icon,
        color: color,
      ));
}

class HeaderWidget extends StatelessWidget {
  final String title;
  final Widget child;
  const HeaderWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(flex: 1, child: child);
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final IconData icon;
  final Color color;
  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.onClicked,
      required this.icon,
      required this.color,
      }): super(key: key);

  @override
  Widget build(BuildContext context) => TextButton.icon(
      onPressed: onClicked, 
      icon: Icon(icon, color: color,), 
      label: Text(text, style: TextStyle(color: color))
      );
}
