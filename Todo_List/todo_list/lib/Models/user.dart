import "package:flutter/material.dart";
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
        taskMap = map['taskMap'];
}
