import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';

class StatementWidget extends StatelessWidget {
  final Task task;
  const StatementWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget deadlineText() {
      Text deadline_text = Text(task.deadline);
      if (task.deadline.contains('late') ||
          task.deadline.contains('hrs left')) {
        deadline_text = Text(
          task.deadline,
          style: const TextStyle(color: Colors.red),
        );
      }
      return Row(children: [deadline_text, const SizedBox(width: 8)]);
    }

    return Opacity(
      opacity: 0.6,
      child: Container(
        margin: const EdgeInsets.only(left: 68),
        child: Row(
          children: <Widget>[
            task.deadline != 'No Deadline'
                ? deadlineText()
                : const SizedBox.shrink(),
            task.subtasks.isNotEmpty
                ? Row(
                    children: [
                      SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            value: task.setProgress,
                            strokeWidth: 3.2,
                            backgroundColor: Colors.grey,
                          )),
                      const SizedBox(width: 8),
                      Text("${(task.setProgress * 100).toStringAsFixed(0)}%")
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
