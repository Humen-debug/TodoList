import 'package:flutter/material.dart';
import 'package:todo_list/Models/data.dart';

import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/theme.dart';
import 'package:provider/provider.dart';

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
  final DateTime today = DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day)
      .toLocal();
  final int periodNum = 7;
  int periodChoice = 0;

  late Map<DateTime, int> taskCountsMap = {};

  final List periodBtnTitles = const <String>['Day', 'Week', 'Month'];

  final List months = const <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  List<TaskData> dailyTaskCounts = [];
  List<TaskData> weeklyTaskCounts = [];
  List<TaskData> monthlyTaskCounts = [];

  late List<TaskData> selectTaskCounts = dailyTaskCounts;

  final choiceBtnStyle = ButtonStyle(
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
    minimumSize: MaterialStateProperty.all(const Size(64, 30)),
    side: MaterialStateProperty.all(
        const BorderSide(color: Colors.grey, width: 0.8)),
  );

  final choiceBtnTextStyle = const TextStyle(fontSize: 12);

  void selectPeriod(int index) {
    setState(() {
      periodChoice = index;
      switch (index) {
        case 0:
          selectTaskCounts = dailyTaskCounts;
          break;
        case 1:
          selectTaskCounts = weeklyTaskCounts;
          break;
        case 2:
          selectTaskCounts = monthlyTaskCounts;
          break;
      }
    });
  }

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

  int getCountForWeek(DateTime date) {
    int count = 0;
    for (int day = 0; day < periodNum; day++) {
      count += getCountForDay(date.subtract(Duration(days: day)));
    }
    return count;
  }

  int getCountForMonth(DateTime date) {
    int count = 0;
    int diff = date.difference(findFirstDayinMonth(date)).inDays;
    for (int day = 0; day <= diff; day++) {
      count += getCountForDay(date.subtract(Duration(days: day)));
    }
    return count;
  }

  void setDailyTaskCount() {
    dailyTaskCounts = List<TaskData>.generate(periodNum, (index) {
      DateTime date = today.subtract(Duration(days: index));
      bool isToday = date == today;
      String time = isToday ? 'Today' : (date.day).toString() + 'th';

      return TaskData(time: time, count: getCountForDay(date));
    });
  }

  void setWeeklyTaskCount() {
    weeklyTaskCounts = List<TaskData>.generate(periodNum, (index) {
      DateTime date = findSaturday(
          today.subtract(Duration(days: DateTime.daysPerWeek * index)));
      bool isThisWeek = findSunday(date) == findSunday(today);
      String time =
          isThisWeek ? 'This Week' : (findSunday(date).day).toString() + 'th';
      return TaskData(time: time, count: getCountForWeek(date));
    });
  }

  void setMonthlyTaskCount() {
    monthlyTaskCounts = List<TaskData>.generate(periodNum, (index) {
      DateTime date = findLastDayinMonth(
          DateTime.utc(today.year, today.month - index, today.day).toLocal());
      bool isThisMonth =
          findFirstDayinMonth(date) == findFirstDayinMonth(today);
      String time = isThisMonth ? 'This Month' : months[date.month - 1];
      return TaskData(time: time, count: getCountForMonth(date));
    });
  }

  DateTime findSunday(DateTime date) =>
      date.subtract(Duration(days: date.weekday));

  DateTime findSaturday(DateTime date) =>
      date.add(Duration(days: DateTime.daysPerWeek - (date.weekday + 1)));

  DateTime findFirstDayinMonth(DateTime date) =>
      DateTime(date.year, date.month, 1).toLocal();

  DateTime findLastDayinMonth(DateTime date) =>
      DateTime.utc(date.year, date.month + 1, 0).toLocal();

  @override
  void initState() {
    setState(() {
      setTaskCountsMap();
      setDailyTaskCount();
      setWeeklyTaskCount();
      setMonthlyTaskCount();
    });
    // print(dailyTaskCounts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: SizedBox(
                    height: 30,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemCount: periodBtnTitles.length,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                              onPressed: () {
                                selectPeriod(index);
                              },
                              style: periodChoice == index
                                  ? choiceBtnStyle.copyWith(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              themeProvider.lighttheme
                                                  .colorScheme.secondary
                                                  .withOpacity(0.2)))
                                  : choiceBtnStyle,
                              child: Text(periodBtnTitles[index],
                                  style: choiceBtnTextStyle));
                        }),
                  ),
                ),
                SfCartesianChart(
                  title: ChartTitle(
                      text: 'Recent Completion Curve',
                      alignment: ChartAlignment.near),
                  // for String as Xasis label
                  primaryXAxis: CategoryAxis(isInversed: true),
                  primaryYAxis: NumericAxis(
                    interval: 1,
                  ),
                  series: <ChartSeries>[
                    LineSeries<TaskData, String>(
                        dataSource: selectTaskCounts,
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
