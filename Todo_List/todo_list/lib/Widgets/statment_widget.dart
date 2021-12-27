import 'package:flutter/material.dart';

class StatementWidget extends StatelessWidget {
  final String deadline;
  const StatementWidget({Key? key, required this.deadline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Text deadlineText() {
      Text deadline_text = Text(deadline);
      if (deadline.contains('late') || deadline.contains('hrs left')) {
        deadline_text = Text(
          deadline,
          style: const TextStyle(color: Colors.red),
        );
      }
      return deadline_text;
    }

    return Container(
      margin: const EdgeInsets.only(left: 80),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: deadline != 'No Deadline'
                  ? deadlineText()
                  : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
