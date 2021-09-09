import 'package:flutter_calendar/model/model_task.dart';

class DayWithTask {
  final DateTime day;
  final int numTasks;
  DayWithTask(this.day, this.numTasks);

  static fromMap(Map<String, Object?> c) {}
}
