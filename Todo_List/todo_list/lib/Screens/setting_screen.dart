import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_list/Screens/Settings/appearance_screen.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final blocks = <Widget>[];
  static const duration = Duration(milliseconds: 150);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: ListView(
          children: <Widget>[
            // Account: password
            Card(
                child: Column(
              children: [
                ListTile(
                  title: const Text("Password"),
                  leading: const Icon(Icons.lock),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                )
              ],
            )),
            // Preference: Appearence -> theme & fontsize, Language, Notifications
            Card(
                child: Column(
              children: [
                ListTile(
                  title: const Text("Appearance"),
                  leading: const Icon(Icons.format_paint_outlined),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          child: AppearanceScreen(),
                          type: PageTransitionType.bottomToTop,
                          duration: duration,
                          reverseDuration: duration,
                        ));
                  },
                ),
                const Divider(),
                ListTile(
                    title: const Text("Language"),
                    leading: const Icon(Icons.language),
                    // trailing: const Icon(Icons.chevron_right),
                    onTap: () {}),
                const Divider(),
                ListTile(
                    title: const Text("Notifications"),
                    leading: const Icon(Icons.notifications_outlined),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {}),
              ],
            )),
            // Version, about, feedback
            Card(
                child: Column(
              children: [
                ListTile(
                    title: const Text("Help"),
                    leading: const Icon(Icons.help_sharp),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {}),
                const Divider(),
                ListTile(
                    title: const Text("Feedback & Suggestion"),
                    leading: const Icon(Icons.feedback_outlined),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {}),
                const Divider(),
                ListTile(
                    title: const Text("Version"),
                    leading: const Icon(Icons.update_outlined)),
              ],
            )),
          ],
        )
        // ListView.builder(
        //   itemCount: blocks.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return ListTile();
        //   },
        // ),
        // Container(
        //     decoration: BoxDecoration(
        //         color: Colors.grey,
        //         borderRadius: const BorderRadius.all(Radius.circular(20))),
        //   ),
        );
  }
}
