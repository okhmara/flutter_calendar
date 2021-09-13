import 'package:flutter/material.dart';

class Calendar {
  static final stratWeekDay = DateTime.monday;
  static final visibleWeeks = 6;

  Calendar();

  static DateTimeRange getDaysRange(DateTime selectedDay) {
    final firstDay = DateTime.utc(selectedDay.year, selectedDay.month, 1);
    final lastDay = lastDayOfMonth(selectedDay);

    final daysBefore = (firstDay.weekday + 7 - stratWeekDay) % 7;
    final firstToDisplay = firstDay.subtract(Duration(days: daysBefore));

    final dayBetween = daysBetween(firstToDisplay, lastDay) + 1;
    final daysAfter = visibleWeeks * 7 - dayBetween;
    final lastToDisplay = lastDay.add(Duration(days: daysAfter));

    return DateTimeRange(start: firstToDisplay, end: lastToDisplay);
  }

  static DateTime lastDayOfMonth(DateTime month) {
    final date = month.month < 12
        ? DateTime.utc(month.year, month.month + 1, 1)
        : DateTime.utc(month.year + 1, 1, 1);
    return date.subtract(const Duration(days: 1));
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  static List<DateTime> getDays(DateTime day) {
    final range = getDaysRange(day);
    return daysInRange(range.start, range.end);
  }
}
