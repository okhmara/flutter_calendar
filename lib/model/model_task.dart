import 'package:flutter_calendar/utils/format_functions.dart';

class TaskFields {
  static final List<String> values = [
    /// Add all fields
    id, description, time, duration
  ];

  static final String id = '_id';
  static final String description = 'description';
  static final String time = 'time';
  static final String duration = 'duration';
}

class Task {
  final int? id;
  final String description;
  final DateTime date;
  final Duration duration;

  const Task(
      {this.id,
      required this.description,
      required this.date,
      required this.duration});

  Task copy({
    int? id,
    String? description,
    DateTime? createdTime,
    Duration? duration,
  }) =>
      Task(
        id: id ?? this.id,
        description: description ?? this.description,
        date: createdTime ?? this.date,
        duration: duration ?? this.duration,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TaskFields.id] as int?,
        description: json[TaskFields.description] as String,
        date: DateTime.parse(json[TaskFields.time] as String),
        duration: parseDuration(json[TaskFields.duration] as String),
      );

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.description: description,
        TaskFields.time: date.toIso8601String(),
        TaskFields.duration: durationToString(duration),
      };
}
