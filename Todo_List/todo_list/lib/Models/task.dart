import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

class Task {
  int? id;
  bool isCompleted;
  bool isExpand;
  String title, time, status;
  DateTime? date;
  DateTime createdTime;
  List<Task> subtasks;
  List<Tag>? tags;

  int repeatChoice = -1;

  @override
  String toString() {
    return "$title: $isCompleted";
  }

  double get getProgress => subtasks.isNotEmpty
      ? subtasks.where((s) => s.isCompleted == true).toList().length /
          subtasks.length
      : 0;

  String get getDeadline {
    String deadline = "none";
    if (date != null) {
      var diff = (date)?.difference(DateTime.now()).inDays ?? 0;
      if (diff > 0) {
        if (diff == 1) {
          deadline = 'Due Tomorrow';
        } else {
          deadline =
              '${date!.day}/${date!.month}/${date!.year}: $diff days left';
        }
      } else if (diff == 0) {
        var diffHour = (date!).difference(DateTime.now()).inHours;
        if (diffHour >= 0) {
          deadline = '$diffHour hrs left';
        } else {
          diffHour = -diffHour;
          deadline = '$diffHour hrs late';
        }
      } else {
        diff = -diff;
        deadline = '${date!.day}/${date!.month}/${date!.year}: $diff days late';
      }
    }

    return deadline;
  }

  set setRepeatChoice(int choice) {
    repeatChoice = choice;
  }

  Task({
    int? id,
    required this.title,
    required this.date,
    required this.isCompleted,
    required this.time,
    required this.createdTime,
    required this.status,
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
        // deadline: map['deadline'],
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
