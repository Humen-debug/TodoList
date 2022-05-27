import 'package:todo_list/Models/task.dart';

class User {
  final int id;
  final String name;
  final String email;
  bool showComplete;
  bool showDetails;
  int sortIndex;

  final Map<String, List<Task>> taskMap;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.showComplete,
    required this.showDetails,
    required this.sortIndex,
    required this.taskMap,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      email: map['email'] as String,
      name: map['name'] as String,
      showComplete: map['showComplete'] as bool,
      showDetails: map['showComplete'] as bool,
      sortIndex: map['sortIndex'] as int,
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
      'showComplete': showComplete,
      'showDetails': showDetails,
      'sortIndex': sortIndex,
      'taskMap': taskMap,
    };
  }

  @override
  String toString() {
    return '$name ($email): $taskMap';
  }
}
