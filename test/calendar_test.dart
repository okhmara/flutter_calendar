import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:flutter_calendar/model/calendar_model.dart';

void main() {
  test('Calendar.getDaysRange for 2021 09', () {
    final day = DateTime(2021, 09, 12);
    final range = DateTimeRange(
      start: DateTime(2021, 08, 30),
      end: DateTime(2021, 10, 10),
    );
    final result = Calendar.getDaysRange(day);
    expect(
      [
        result.start.toString().substring(0, 10),
        result.end.toString().substring(0, 10),
      ],
      [
        range.start.toString().substring(0, 10),
        range.end.toString().substring(0, 10),
      ],
    );
  });
}
