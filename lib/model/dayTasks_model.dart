import 'task_model.dart';

class TaskAmountFields {
  static final List<String> values = [
    /// Add all fields
    date, amount
  ];

  static final String date = TaskFields.date;
  static final String amount = 'amount';
}

class DayTasks {
  final DateTime date;
  final int amountTasks;

  DayTasks({required this.date, required this.amountTasks});

  static DayTasks fromMap(Map<String, Object?> json) => DayTasks(
        date: DateTime.parse(json[TaskAmountFields.date] as String),
        amountTasks: json[TaskAmountFields.amount] as int,
      );

  static findByDate(list, DateTime date) {
    var findByDate = (DayTasks day) => day.date == date;
    var result = list.where(findByDate);
    return result.length > 0 ? result.first : null;
  }
}
