import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/user.dart';
import 'package:todo_list/Screens/main_screen.dart';

class SortButton extends StatefulWidget {
  FileHandler file;
  User user;
  List<Task> list;
  SortButton(
      {Key? key, required this.file, required this.user, required this.list})
      : super(key: key);

  @override
  _SortButtonState createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  Icon sortIcon = const Icon(Icons.sort);

  final sortIcons = <Icon>[
    MainScreenState.currentList == "All"
        ? const Icon(Icons.table_rows)
        : const Icon(Icons.sort),
    const Icon(Icons.schedule),
    const Icon(Icons.text_rotate_vertical),
    const Icon(Icons.tag),
  ];
  final sortTitle = <Text>[
    MainScreenState.currentList == "All"
        ? const Text("List")
        : const Text("Custom"),
    const Text("By Time"),
    const Text("By Title"),
    const Text("By Tags"),
  ];
  void filterTasks(int item) {
    setState(() {
      widget.user.sortIndex = item;
      sortIcon = sortIcons[item];
      widget.list.sort((a, b) {
        return !b.isCompleted ? 1 : -1;
      });
      switch (item) {
        case 0:

          // reOrder = !reOrder;
          break;
        case 1:
          widget.list.sort((a, b) {
            if (a.date == b.date) {
              return 0;
            } else if ((a.date == null && b.date != null)) {
              return -1;
            } else if (a.date != null && b.date == null) {
              return 1;
            } else {
              return a.date!.compareTo(b.date!);
            }
          });
          break;
        case 2:
          widget.list.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 3:
          break;
      }
      widget.list.sort((a, b) {
        return !b.isCompleted ? 1 : -1;
      });

      widget.file.updateUser(id: widget.user.id, updatedUser: widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        onSelected: (item) => filterTasks(item),
        icon: sortIcon,
        itemBuilder: (context) {
          return List.generate(sortIcons.length, (index) {
            return PopupMenuItem(
                value: index,
                child: Row(children: [
                  sortIcons[index],
                  const SizedBox(width: 10),
                  sortTitle[index]
                ]));
          });
        });
  }
}
