class Task {
  int? id;
  bool isCompleted;
  String title, time, status;
  DateTime? date;
  DateTime createdTime;
  String deadline;
  List<Task> subtasks;
  List<Tag>? tags;
  bool isExpand;

  @override
  String toString() {
    return "$title: $date, $subtasks";
  }

  Task(
      {required this.title,
      required this.date,
      required this.isCompleted,
      required this.time,
      required this.createdTime,
      required this.status,
      required this.deadline,
      required this.subtasks,
      required this.isExpand});

  factory Task.fromJson(Map<String, dynamic> map) {
    return Task(
        title: map['title'],
        date: map['date'] != null ? DateTime.parse(map['date']) : null,
        isCompleted: map['isCompleted'],
        isExpand: map['isExpand'] as bool,
        time: map['time'],
        createdTime: DateTime.parse(map['createdTime']),
        status: map['status'],
        deadline: map['deadline'],
        subtasks: map['subtasks'].map<Task>((s) => Task.fromJson(s)).toList());
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
      'isExpand': isExpand,
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
