import 'package:flutter/material.dart';
import 'package:todo_list/Models/task.dart';

void setDefault(StateSetter setState, Task task) {
  setState(() => task = Task(
        title: "",
        date: null,
        isCompleted: false,
        isExpand: false,
        time: "",
        createdTime: DateTime.now(),
        status: "",
        // deadline: "No Deadline",
        subtasks: [],
      ));
}
