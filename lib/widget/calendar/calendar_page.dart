import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/controller/calendar_controller.dart';
import 'package:flutter_calendar/model/calendar_model.dart';
import 'package:flutter_calendar/utils/database_helper.dart';
import 'package:flutter_calendar/widget/calendar/calendar_cell.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'calendar_header.dart';

class CalendarPage extends StatelessWidget {
  final CalendarController _controller =
      Get.put(CalendarController(TasksDatabase.instance));

  CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (dragEndDetails) {
          if (dragEndDetails.primaryVelocity! < 0) {
            _controller.nextMonth();
          } else if (dragEndDetails.primaryVelocity! > 0) {
            _controller.prevMonth();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Obx(() {
              return Column(
                children: [
                  CalendarHeader(),
                  SizedBox(height: 10),
                  // calendar body
                  Table(
                    border: TableBorder.all(
                      color: Colors.blue,
                    ),
                    children: [
                      _buildDaysOfWeek(),
                      ..._buildCalendarDays(),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildCalendarDays() {
    return List.generate(Calendar.visibleWeeks, (index) => index)
        .map(
          (index) => TableRow(
            // decoration: BoxDecoration(color: Colors.yellow),
            children: _buildWeekDays(index * 7),
          ),
        )
        .toList();
  }

  List<Widget> _buildWeekDays(int weekOffset) {
    return List.generate(7, (index) => index).map((index) {
      return CalendarCell(
        cell: _controller.days[weekOffset + index],
        displayMonth: _controller.selected.value.month,
      );
    }).toList();
  }

  TableRow _buildDaysOfWeek() {
    return TableRow(
      children: List.generate(7, (index) => index).map((index) {
        return Center(
          heightFactor: 2,
          child: Text(
            DateFormat("EEE").format(_controller.days[index].date).toString(),
          ),
        );
      }).toList(),
    );
  }
}
