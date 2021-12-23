import "package:flutter/material.dart";

class Task {
  int? id;
  bool isCompleted;
  String text, time, status;
  DateTime? date;
  DateTime createdTime;
  String deadline;
  List<Task> subtasks;

  @override
  String toString() {
    return "$text: $date";
  }

  Task(this.text, this.date, this.isCompleted, this.time, this.createdTime,
      this.status, this.deadline, this.subtasks);

  Task.fromJson(Map<String, dynamic> map)
      : text = map['text'] as String,
        date = map['date'] as DateTime,
        isCompleted = map['isCompleted'] as bool,
        time = map['time'] as String,
        createdTime = map['createdTime'] as DateTime,
        status = map['status'] as String,
        deadline = map['deadline'] as String,
        subtasks = map['subtasks'] as List<Task>;

  Map<String, dynamic> toJson() {
    List<Map>? subtasks = this.subtasks.map((e) => e.toJson()).toList();

    return {
      'text': text,
      'date': date?.toIso8601String(),
      'isCompleted': isCompleted,
      'time': time,
      'createdTime': createdTime.toIso8601String(),
      'status': status,
      'deadline': deadline,
      'subtasks': subtasks,
    };
  }

  List<Object> get prop =>
      [text, date!, isCompleted, time, createdTime, status, deadline, subtasks];
}
