import 'package:flutter/material.dart';
import 'package:todo_list/Widgets/button_widget.dart';

class DatePicker extends StatefulWidget {
  String date;
  // DatePicker({Key? key}) : super(key: key);
  DatePicker(this.date);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? date;

  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      return '${date!.day}/${date!.month}/${date!.year}';
    }
  }

  @override
  Widget build(BuildContext context) => ButtonHeaderWidget(
        title: 'Date',
        text: getText(),
        onClicked: () => pickDate(context),
        icon: Icons.event,
        color: Colors.grey,
      );

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (newDate == null) return;
    setState(() {
      date = newDate;
      widget.date = '${date!.day}/${date!.month}/${date!.year}';
    });
  }
}
