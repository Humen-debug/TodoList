import 'package:flutter/material.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/user.dart';

class MenuButton extends StatefulWidget {
  FileHandler file;
  User user;

  MenuButton({Key? key, required this.file, required this.user})
      : super(key: key);

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  void onSelected(int item) {
    setState(() {
      switch (item) {
        case 0:
          widget.user.showDetails = !widget.user.showDetails;
          break;
        case 1:
          widget.user.showComplete = !widget.user.showComplete;
          break;
      }
      widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        onSelected: (item) => onSelected(item),
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    !widget.user.showDetails
                        ? const Icon(Icons.preview)
                        : const Icon(Icons.disabled_by_default_outlined),
                    const SizedBox(width: 10),
                    !widget.user.showDetails
                        ? const Text("Show Details")
                        : const Text("Hide Details"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      !widget.user.showComplete
                          ? const Icon(Icons.preview)
                          : const Icon(Icons.disabled_by_default_outlined),
                      const SizedBox(width: 10),
                      !widget.user.showComplete
                          ? const Text("Show Completed")
                          : const Text("Hide Completed"),
                    ],
                  )),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: const [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text("Select")
                  ],
                ),
              ),
            ]);
  }
}
