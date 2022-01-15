import 'package:flutter/material.dart';
import 'package:todo_list/Models/data.dart';

import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/task.dart';

import 'package:todo_list/Models/user.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticScreen extends StatefulWidget {
  FileHandler file;
  User user;
  StatisticScreen({Key? key, required this.file, required this.user})
      : super(key: key);

  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  late Map<DateTime, int> taskCountsMap = {};

  final List periodBtnTitles = <String>['Day', 'Week', 'Month'];

  List<TaskData> dailyTaskCounts = [];

  int periodChoice = 0;

  void setTaskCountsMap() {
    for (Task task in widget.user.taskMap['Completed']!) {
      DateTime date = DateTime.utc(task.completedTime!.year,
              task.completedTime!.month, task.completedTime!.day)
          .toLocal();

      int count = taskCountsMap[date] ?? 0;
      taskCountsMap[date] = count + 1;
    }
  }

  int getCountForDay(DateTime date) {
    return taskCountsMap[date] ?? 0;
  }

  @override
  void initState() {
    setState(() {
      setTaskCountsMap();
      dailyTaskCounts = List<TaskData>.generate(7, (index) {
        DateTime now = DateTime.now();
        DateTime today = DateTime.utc(now.year, now.month, now.day).toLocal();

        DateTime date = today.subtract(Duration(days: index));
        String time = (date.day).toString();

        return TaskData(time: time, count: getCountForDay(date));
      });
    });
    // print(dailyTaskCounts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          Card(
            child: Column(
              children: [
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: periodBtnTitles.length,
                      itemBuilder: (context, index) {
                        return OutlinedButton(
                            onPressed: () {
                              periodChoice = index;
                            },
                            child: Text(periodBtnTitles[index]));
                      }),
                ),
                SfCartesianChart(
                  // for String as Xasis label
                  primaryXAxis: CategoryAxis(isInversed: true),
                  primaryYAxis: NumericAxis(
                    interval: 1,
                  ),
                  series: <ChartSeries>[
                    LineSeries<TaskData, String>(
                        dataSource: dailyTaskCounts,
                        xValueMapper: (TaskData data, _) => data.time,
                        yValueMapper: (TaskData data, _) => data.count)
                  ],
                ),
              ],
            ),
          )
        ]));
  }
}
