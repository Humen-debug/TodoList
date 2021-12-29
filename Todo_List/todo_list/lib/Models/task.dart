class Task {
  int? id;
  double? progress;
  bool isCompleted;
  bool isExpand;
  String title, time, status, deadline;
  DateTime? date;
  DateTime createdTime;
  List<Task> subtasks;
  List<Task> completed;

  List<Tag>? tags;

  @override
  String toString() {
    return "$title: $date, $subtasks";
  }

  double get setProgress => subtasks.isNotEmpty
      ? subtasks.where((s) => s.isCompleted == true).toList().length /
          subtasks.length
      : 0;

  Task(
      {required this.title,
      required this.date,
      required this.isCompleted,
      required this.time,
      required this.createdTime,
      required this.status,
      required this.deadline,
      required this.subtasks,
      required this.completed,
      required this.isExpand,
      required this.progress});

  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
        title: map['title'],
        date: map['date'] != null ? DateTime.parse(map['date']) : null,
        isCompleted: map['isCompleted'],
        isExpand: map['isExpand'] as bool,
        progress: map['progress'] as double,
        time: map['time'],
        createdTime: DateTime.parse(map['createdTime']),
        status: map['status'],
        deadline: map['deadline'],
        completed: map['completed'] != null
            ? map['completed'].map<Task>((s) => Task.fromJson(s)).toList()
            : [],
        subtasks: map['completed'] != null
            ? map['subtasks'].map<Task>((s) => Task.fromJson(s)).toList()
            : []);
  }

  Map<String, dynamic> toJson() {
    List<Map>? subtasks = this.subtasks.map((e) => e.toJson()).toList();

    return {
      'title': title,
      'date': date?.toIso8601String(),
      'isCompleted': isCompleted,
      'time': time,
      'createdTime': createdTime.toIso8601String(),
      'status': status,
      'deadline': deadline,
      'subtasks': subtasks,
      'completed': completed,
      'isExpand': isExpand,
      'progress': progress,
    };
  }

  List<Object> get prop => [
        title,
        date!,
        isCompleted,
        time,
        createdTime,
        status,
        deadline,
        subtasks
      ];
}

class Tag {
  String name;
  Tag({required this.name});
}
