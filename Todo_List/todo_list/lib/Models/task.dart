import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

class Task {
  int? id;
  bool isCompleted;
  bool isExpand;
  String title, time, status, deadline;
  DateTime? date;
  DateTime createdTime;
  List<Task> subtasks;
  List<Tag>? tags;

  @override
  String toString() {
    return "$title: $date, $createdTime,$subtasks";
  }

  double get setProgress => subtasks.isNotEmpty
      ? subtasks.where((s) => s.isCompleted == true).toList().length /
          subtasks.length
      : 0;

  Task({
    int? id,
    required this.title,
    required this.date,
    required this.isCompleted,
    required this.time,
    required this.createdTime,
    required this.status,
    required this.deadline,
    required this.subtasks,
    required this.isExpand,
  });

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
        subtasks: map['subtasks'] != null
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
      'isExpand': isExpand,
    };
  }
}

class Tag {
  String name;
  Tag({required this.name});
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kEvents = LinkedHashMap<DateTime, List<Task>>(
    equals: isSameDay, hashCode: getHashCode)
  ..addAll(kEventSource);

final kEventSource =
    Map<DateTime, List<Task>>.fromIterable(List.generate(50, (index) => index),
        key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
        value: (item) => List.generate(
            item % 4 + 1,
            (index) => Task(
                  title: '$item | $index',
                  date: null,
                  isCompleted: false,
                  isExpand: false,
                  time: "",
                  createdTime: DateTime.now(),
                  status: "",
                  deadline: "No Deadline",
                  subtasks: [],
                )))
      ..addAll({
        kToday: [],
      });

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 5);
final kLastDay = DateTime(kToday.year + 5);
