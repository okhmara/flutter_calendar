import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar/model/dayTasks_model.dart';
import 'package:flutter_calendar/utils/date_utils.dart';
import 'package:flutter_calendar/widget/calendar/task_badge.dart';
import 'package:flutter_calendar/widget/task/task_page.dart';

class CalendarCell extends StatelessWidget {
  final int displayMonth;
  final DayTasks cell;
  const CalendarCell({Key? key, required this.cell, required this.displayMonth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height / 12;

    final dayCaption = cell.date.day.toString();
    final dayStyle = _dayStyle(cell.date);

    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TaskPage(day: cell.date)));
      },
      child: Container(
        height: h,
        child: Stack(
          children: [
            Center(
              child: Text(
                dayCaption,
                style: dayStyle,
              ),
            ),
            // task badge
            TaskBandge(taskAmount: cell.amountTasks),
          ],
        ),
      ),
    );
  }

  TextStyle _dayStyle(DateTime day) {
    if (day.isSameDate(DateTime.now())) {
      return TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900);
    }
    if (day.month == displayMonth) {
      return TextStyle(fontWeight: FontWeight.bold);
    }
    return TextStyle();
  }
}
