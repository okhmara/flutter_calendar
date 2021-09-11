import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar/controller/calendar_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  CalendarHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CalendarController _monthController = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _monthController.prevMonth(),
          icon: const Icon(Icons.arrow_left),
        ),
        Row(children: [
          Text(
            '${DateFormat("MMMM").format(_monthController.selected.value)}',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 20),
          Text(
            '${DateFormat("yyyy").format(_monthController.selected.value)}',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
        IconButton(
          onPressed: () => _monthController.nextMonth(),
          icon: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}
