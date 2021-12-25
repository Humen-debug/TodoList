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

  factory User.fromJson(Map<String, dynamic> map) {
    // print(map['taskMap']['Inbox'] is List);
    Map<String, List<Task>> taskMap =
        Map.fromEntries((map['taskMap']).map((taskBox, taskLists) {
      print(taskLists.isEmpty);
      if (taskLists.isNotEmpty) {
        // print(taskLists);
        List<Task> list = taskLists.map((e) {
          // print(e);
          return Task.fromJson(e);
        }).toList();
        return MapEntry(taskBox, list);
      } else {
        return MapEntry(taskBox, taskLists);
      }
    }));

    return User(
      id: map['id'] as int,
      email: map['email'] as String,
      name: map['name'] as String,
      taskMap: taskMap,
    );
  }

  // User.fromJson(Map<String, dynamic> map)
  //     : id = (map['id'] as num).toInt(),
  //       name = map['name'] as String,
  //       email = map['email'] as String,
  //       // taskMap = Map<String, List<Task>>.from(map['taskMap']);
  //       taskMap = (map['taskMap']).cast<Map<String,List<Task>>>();

  Map<String, dynamic> toJson() {
    // JsonEncoder().convert(taskMap);
    // jsonEncode(taskMap);
    return {
      'id': id,
      'name': name,
      'email': email,
      'taskMap': jsonEncode(taskMap),
    };
  }

  String toString() {
    return '$name ($email): $taskMap';
  }

  List<Object> get props => [name, email, id, taskMap];
}
