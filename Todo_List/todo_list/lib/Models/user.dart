// import "package:flutter/material.dart";
import 'dart:convert';

import 'package:todo_list/Models/task.dart';

class User {
  final int id;
  final String name;
  final String email;
  final Map<String, List<Task>> taskMap;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.taskMap,
  });

  User.fromJson(Map<String, dynamic> map)
      : id = (map['id'] as num).toInt(),
        name = map['name'] as String,
        email = map['email'] as String,
        taskMap = map['taskMap'] as Map<String, List<Task>>;
  Map<String, dynamic> toJson() {
    // JsonEncoder().convert(taskMap);
    jsonEncode(taskMap);
    return {
      'id': id,
      'name': name,
      'email': email,
      'taskMap': taskMap,
    };
  }

  String toString() {
    return '$name ($email): $taskMap';
  }

  List<Object> get props => [name, email, id, taskMap];
}
