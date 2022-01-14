import 'package:flutter/services.dart';
import 'package:todo_list/Models/task.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/Models/theme.dart';
import 'package:todo_list/Widgets/time_picker_widget.dart';

class RepeatSetter extends StatefulWidget {
  Task task;
  RepeatSetter({Key? key, required this.task}) : super(key: key);

  @override
  _RepeatSetterState createState() => _RepeatSetterState();
}

class _RepeatSetterState extends State<RepeatSetter> {
  int freq = 0;
  int endChoice = 0;
  late List<Widget> endChoiceWidgets = [];
  final btnTextStyle = const TextStyle(
      fontFamily: 'Roboto Condensed', fontSize: 13, color: Colors.grey);

  final frequenciesBtnStyle = ButtonStyle(
      side: MaterialStateProperty.all(
          const BorderSide(color: Colors.grey, width: 3)),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      minimumSize: MaterialStateProperty.all(const Size(80, 80)),
      shape: MaterialStateProperty.all<OutlinedBorder?>(const CircleBorder()));

  final weekDayBtnStyle = ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      elevation: MaterialStateProperty.all(0.0),
      side: MaterialStateProperty.all(
          const BorderSide(color: Colors.grey, width: 2)),
      shape: MaterialStateProperty.all<OutlinedBorder?>(const CircleBorder()));

  final monthlyBtnStyle = ButtonStyle(
    fixedSize: MaterialStateProperty.all(const Size(130, 30)),
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    side: MaterialStateProperty.all(
        const BorderSide(color: Colors.grey, width: 2)),
    elevation: MaterialStateProperty.all(0.0),
  );

  final repeatTitle = const <Text>[
    Text("Never"),
    Text("Daily"),
    Text("Weekly"),
    Text("Monthly"),
    Text("Yearly"),
    Text("Custom")
  ];

  final frequencies = <String>['DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY'];
  final periods = <String>['day', 'week', 'month', 'year'];
  final weekDays = <String>[
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  Future<void> handleRadioValue(value, setState) async {
    setState(() {
      widget.task.repeatChoice = value;
      // need to pop up dialog for choosing custom
      if (value == repeatTitle.length - 1) {}
      // might need to update task repeat here
      // so that repeatChoice can be set to -1 again
    });
  }

  Future<void> handleFrequencies(index, setState) async {
    setState(() {
      freq = index;
      widget.task.repeatChoice = index;
    });
  }

  Widget frequencyBtn(int index) {
    return OutlinedButton(
        style: freq == index
            ? frequenciesBtnStyle.copyWith(
                side: MaterialStateProperty.all(BorderSide(
                    color: ThemeProvider().lighttheme.colorScheme.primary,
                    width: 3)))
            : frequenciesBtnStyle,
        onPressed: () {
          handleFrequencies(index, setState);
        },
        child: Text(
          frequencies[index],
          style: freq == index
              ? btnTextStyle.copyWith(
                  color: ThemeProvider().lighttheme.colorScheme.primary)
              : btnTextStyle,
        ));
  }

  Widget numberInputBox() {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 44,
      width: 70,
      child: TextFormField(
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(gapPadding: 2),
        ),
        textAlign: TextAlign.center,
        initialValue: '1',
        keyboardType: TextInputType.number,
        autocorrect: false,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLength: 2,
      ),
    );
  }

  Widget weekDayBtn(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 36,
        width: 36,
        child: ElevatedButton(
          onPressed: () {},
          child: Text(
            weekDays[index][0],
            style: btnTextStyle.copyWith(fontSize: 12),
          ),
          style: weekDayBtnStyle,
        ),
      ),
    );
  }

  Widget weekDaysBtns() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          return weekDayBtn(index);
        });
  }

  Text get monthlyCurrentDay {
    return Text(
      widget.task.date == null
          ? formatedDay(DateTime.now())
          : formatedDay(widget.task.date!),
      style: btnTextStyle.copyWith(fontSize: 12),
    );
  }

  Text get monthlyCurrentWeekday {
    return Text(
        widget.task.date == null
            ? formatedWeekday(DateTime.now())
            : formatedWeekday(widget.task.date!),
        style: btnTextStyle.copyWith(fontSize: 12));
  }

  String formatedDay(DateTime date) {
    return "Monthly on day ${date.day}";
  }

  String formatedWeekday(DateTime date) {
    String weekday = '';
    switch (date.weekday) {
      case 7:
        weekday = weekDays[0];
        break;
      case 1:
        weekday = weekDays[1];
        break;
      case 2:
        weekday = weekDays[2];
        break;
      case 3:
        weekday = weekDays[3];
        break;
      case 4:
        weekday = weekDays[4];
        break;
      case 5:
        weekday = weekDays[5];
        break;
      case 6:
        weekday = weekDays[6];
        break;
    }
    return "Monthly on $weekday";
  }

  Widget monthlyBtns() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: () {},
                child: monthlyCurrentDay,
                style: monthlyBtnStyle,
              ),
            )),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: ElevatedButton(
                  onPressed: () {},
                  child: monthlyCurrentWeekday,
                  style: monthlyBtnStyle),
            ))
      ],
    );
  }

  Widget confirmBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
            onPressed: () {
              setState(() {
                widget.task.repeatChoice = -1;
              });
              Navigator.pop(context);
            },
            child: const Text('CANCEL')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'))
      ],
    );
  }

  @override
  void initState() {
    endChoiceWidgets = [
      const Text('Never'),
      Row(
        children: [
          const Text('On'),
          // can't use TimePickerWidget as task.date will be updated here
          // TimePickerWidget(task: widget.task, type: 'Date')
        ],
      ),
      Row(
        children: [
          const Text('After'),
          numberInputBox(),
          const Text('Occurenece')
        ],
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: frequencies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: frequencyBtn(index));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Repeats Every'),
                      const Spacer(),
                      numberInputBox(),
                      Text(periods[freq])
                    ],
                  ),
                  const SizedBox(height: 15),
                  freq == 1 || freq == 2
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Repeats On'),
                            SizedBox(
                                height: 60,
                                child:
                                    freq == 1 ? weekDaysBtns() : monthlyBtns()),
                            const SizedBox(height: 15),
                          ],
                        )
                      : const SizedBox.shrink(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ends'),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: endChoiceWidgets.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                                title: endChoiceWidgets[index],
                                value: index,
                                groupValue: endChoice,
                                onChanged: (value) {
                                  setState(() {
                                    endChoice = value as int;
                                  });
                                });
                          }),
                      const SizedBox(height: 15),
                    ],
                  )
                ],
              ),
            ),
            confirmBar(),
          ],
        ),
      );
    });
  }
}
