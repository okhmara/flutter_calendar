import 'package:flutter/material.dart';
import 'package:flutter_calendar/model/model_day.dart';

class PageOfMonth {
  final DateTime month;

  PageOfMonth(this.month);

  DateTimeRange getDaysRange(DateTime selectedDay) {
    final firstDay = DateTime.utc(selectedDay.year, selectedDay.month, 1);
    final daysBefore = (firstDay.weekday + 7) % 7;
    final firstToDisplay = firstDay.subtract(Duration(days: daysBefore));

    final lastDay = _lastDayOfMonth(selectedDay);
    final daysAfter = _getDaysAfter(lastDay);
    final lastToDisplay = lastDay.add(Duration(days: daysAfter));

    return DateTimeRange(start: firstToDisplay, end: lastToDisplay);
  }

  DateTime _lastDayOfMonth(DateTime month) {
    final date = month.month < 12
        ? DateTime.utc(month.year, month.month + 1, 1)
        : DateTime.utc(month.year + 1, 1, 1);
    return date.subtract(const Duration(days: 1));
  }

  int _getDaysAfter(DateTime lastDay) {
    int daysAfter = 7 - ((lastDay.weekday) % 7);
    if (daysAfter == 7) {
      daysAfter = 0;
    }

    return daysAfter;
  }

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  List<DateTime> getDaysInPage(DateTime day) {
    final range = getDaysRange(day);
    return daysInRange(range.start, range.end);
  }
}
