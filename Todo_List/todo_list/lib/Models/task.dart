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

  Task.fromJson(Map<String, dynamic> map)
      : text = map['text'] as String,
        date = (map['date']),
        isCompleted = map['isCompleted'] as bool,
        time = map['time'] as String,
        createdTime = (map['createdTime']),
        status = map['status'] as String,
        deadline = map['deadline'],
        subtasks = map['subtasks'];

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'date': date,
      'isCompleted': isCompleted,
      'time': time,
      'createdTime': createdTime,
      'status': status,
      'deadline': deadline,
      'subtasks': subtasks,
    };
  }

  List<Object> get prop =>
      [text, date!, isCompleted, time, createdTime, status, deadline, subtasks];
}
