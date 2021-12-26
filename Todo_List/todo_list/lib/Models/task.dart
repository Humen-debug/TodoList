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

  Task(
      {required this.text,
      required this.date,
      required this.isCompleted,
      required this.time,
      required this.createdTime,
      required this.status,
      required this.deadline,
      required this.subtasks});

  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
        text: map['text'],
        date: map['date'] != null ? DateTime.parse(map['date']) : null,
        isCompleted: map['isCompleted'],
        time: map['time'],
        createdTime: DateTime.parse(map['createdTime']),
        status: map['status'],
        deadline: map['deadline'],
        subtasks: map['subtasks'].map<Task>((s) => Task.fromJson(s)).toList());
  }
  // Task.fromJson(Map<String, dynamic> map)
  //     : text = map['text'] != null ? map['text'] as String : "",
  //       date = map['date'] != null ? DateTime.parse(map['date']) : null,
  //       isCompleted =
  //           map['isCompleted'] != null ? map['isCompleted'] as bool : false,
  //       time = map['time'] != null ? map['time'] as String : "",
  //       createdTime = map['createdTime'] != null
  //           ? DateTime.parse(map['createdTime'])
  //           : DateTime.now(),
  //       status = map['status'] != null ? map['status'] as String : "",
  //       deadline =
  //           map['deadline'] != null ? map['deadline'] as String : "No deadline",
  //       subtasks = map['subtasks'] != null ? map['subtasks'] : [];

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
