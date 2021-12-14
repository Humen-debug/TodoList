import "package:flutter/material.dart";

class Task {
  int? id;
  bool isCompleted;
  String text, time, status;
  DateTime? date;
  DateTime createdTime;
  Text deadline;
  List<Task> subtasks;

  @override
  String toString() {
    return "$text: $date";
  }

  Task(this.text, this.date, this.isCompleted, this.time, this.createdTime,
      this.status, this.deadline, this.subtasks);
}
