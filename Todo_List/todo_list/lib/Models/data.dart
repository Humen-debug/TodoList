class TaskData {
  DateTime time;
  int count;

  TaskData({required this.time, required this.count});
  @override
  String toString() {
    return '$time: $count';
  }
}
