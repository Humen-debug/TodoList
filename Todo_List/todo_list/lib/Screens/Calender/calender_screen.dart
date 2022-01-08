import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/Models/file_header.dart';
import 'package:todo_list/Models/task.dart';
import 'package:todo_list/Models/user.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  User user;
  FileHandler file;
  CalenderScreen({Key? key, required this.file, required this.user})
      : super(key: key);

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  late final ValueNotifier<List<Task>> selectedEvents;
  late final PageController pageController;
  late Map<DateTime?, List<Task>> kEvents = {};
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  final Set<DateTime> selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );
  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  @override
  void initState() {
    setMap();
    selectedDays.add(focusedDay.value);
    selectedEvents = ValueNotifier(getEventsForDay(focusedDay.value));
    // selectedEvents = ValueNotifier(getEventsForDay(selectedDay!));
    super.initState();
  }

  @override
  void dispose() {
    focusedDay.dispose();
    selectedEvents.dispose();
    super.dispose();
  }

  void setMap() {
    List lists = widget.user.taskMap.values.toList();
    for (int i = 0; i < lists.length - 1; i++) {
      for (Task task in lists[i]) {
        if (!task.isCompleted) {
          DateTime? date;
          if (task.date != null) {
            date =
                DateTime.utc(task.date!.year, task.date!.month, task.date!.day)
                    .toLocal();
          }
          kEvents.containsKey(date)
              ? kEvents[date]!.add(task)
              : kEvents[date] = [task];
        }
      }
    }
  }

  bool get canClearSelection =>
      selectedDays.isNotEmpty || rangeStart != null || rangeEnd != null;

  List<Task> getEventsForDay(DateTime day) {
    return kEvents[day.toLocal()] ?? [];
  }

  List<Task> getEventsForDays(Iterable<DateTime> days) {
    return [
      for (final d in days) ...getEventsForDay(d),
    ];
  }

  List<Task> getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return getEventsForDays(days);
  }

  void onDaySelected(DateTime selectedDay, DateTime _focusedDay) {
    setState(() {
      if (selectedDays.contains(selectedDay)) {
        selectedDays.remove(selectedDay);
      } else {
        selectedDays.add(selectedDay);
      }
      focusedDay.value = _focusedDay;
      rangeStart = null;
      rangeEnd = null;
      rangeSelectionMode = RangeSelectionMode.toggledOff;
    });
    selectedEvents.value = getEventsForDays(selectedDays);
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime _focusedDay) {
    setState(() {
      focusedDay.value = _focusedDay;
      rangeStart = start;
      rangeEnd = end;
      selectedDays.clear();
      rangeSelectionMode = RangeSelectionMode.toggledOn;
    });
    if (start != null && end != null) {
      selectedEvents.value = getEventsForRange(start, end);
    } else if (start != null) {
      selectedEvents.value = getEventsForDay(start);
    } else if (end != null) {
      selectedEvents.value = getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: <Widget>[
        ValueListenableBuilder<DateTime>(
          valueListenable: focusedDay,
          builder: (context, value, _) => CalendarHeader(
              focusedDay: focusedDay.value,
              onLeftArrowTap: () {
                pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              },
              onRightArrowTap: () {
                pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              },
              onTodayButtonTap: () =>
                  setState(() => focusedDay.value = DateTime.now()),
              onClearButtonTap: () {
                setState(() {
                  rangeStart = null;
                  rangeEnd = null;
                  selectedDays.clear();
                  selectedEvents.value = [];
                });
              },
              clearButtonVisible: canClearSelection),
        ),
        TableCalendar<Task>(
            focusedDay: focusedDay.value,
            firstDay: kFirstDay,
            lastDay: kLastDay,
            headerVisible: false,
            selectedDayPredicate: (day) => selectedDays.contains(day),
            rangeStartDay: rangeStart,
            rangeEndDay: rangeEnd,
            rangeSelectionMode: rangeSelectionMode,
            calendarFormat: calendarFormat,
            eventLoader: getEventsForDay,
            onDaySelected: onDaySelected,
            onRangeSelected: onRangeSelected,
            onCalendarCreated: (controller) => pageController = controller,
            onPageChanged: (_focusedDay) => focusedDay.value = _focusedDay,
            onFormatChanged: (format) {
              if (calendarFormat != format) {
                setState(() => calendarFormat = format);
              }
            }),
        const SizedBox(height: 10),
        Expanded(
            child: ValueListenableBuilder<List<Task>>(
          valueListenable: selectedEvents,
          builder: (context, value, _) {
            return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(value[index].title),
                    ),
                  );
                });
          },
        )),
      ]),
    );
  }
}

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: const Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
