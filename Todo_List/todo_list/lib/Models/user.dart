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
    return User(
      id: map['id'] as int,
      email: map['email'] as String,
      name: map['name'] as String,
      // taskMap: Map<String, List<Task>>.from(
      //     Task.fromJson(map['taskMap']) as Map<String, dynamic>),
      taskMap:
          Map<String, List<Task>>.from(map['taskMap'].map((String name, value) {
        return MapEntry(
            name,
            value.map<Task>((e) {
              return Task.fromJson(e);
            }).toList());
      })),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'taskMap': taskMap,
    };
  }

  @override
  String toString() {
    return '$name ($email): $taskMap';
  }

  List<Object> get props => [name, email, id, taskMap];
}
