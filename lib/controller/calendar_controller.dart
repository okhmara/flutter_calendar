import 'package:flutter_calendar/model/dayTasks_model.dart';
import 'package:flutter_calendar/model/calendar_model.dart';
import 'package:flutter_calendar/utils/database_helper.dart';
import 'package:flutter_calendar/utils/date_utils.dart';
import 'package:get/get.dart';

enum CalendarState { failure, loading, complete }

class CalendarController extends GetxController {
  var state = CalendarState.loading.obs;
  var selected = DateTime.now().obs;
  var days = <DayTasks>[].obs;
  var predDay = DateTime(0);

  final TasksDatabase db;

  CalendarController(this.db);

  @override
  onInit() {
    loadCalendarDays(DateTime.now());
    loadCalendarData(DateTime.now());
    super.onInit();
  }

  loadCalendarData(DateTime day) async {
    selected.value = day;
    if (selected.value == predDay) {
      return;
    }
    state.value = CalendarState.loading;
    final range = Calendar.getDaysRange(day);

    try {
      final List<DayTasks> list = await db.getTasksAmount(
        range.start,
        range.end,
      );
      if (list != []) {
        list.forEach((task) {
          int i =
              days.indexWhere((element) => element.date.isSameDate(task.date));
          if (i >= 0) {
            days[i] = task;
          }
        });
        days.refresh();
      }
    } finally {
      state.value = CalendarState.complete;
    }
  }

  loadCalendarDays(DateTime day) async {
    selected.value = day;
    if (selected.value == predDay) {
      return;
    }
    try {
      days.clear();
      final List<DayTasks> list = getDaysInPage(selected.value);
      if (list != []) {
        days.assignAll(list);
      }
      days.refresh();
    } finally {
      state.value = CalendarState.complete;
    }
  }

  refresh() async {
    await loadCalendarData(selected.value);
  }

  nextMonth() async {
    final month = DateTime(
        selected.value.year, selected.value.month + 1, selected.value.day);
    await loadCalendarDays(month);
    await loadCalendarData(month);
  }

  prevMonth() async {
    final month = DateTime(
        selected.value.year, selected.value.month - 1, selected.value.day);
    await loadCalendarDays(month);
    await loadCalendarData(month);
  }

  List<DayTasks> getDaysInPage(DateTime day) {
    final range = Calendar.getDaysRange(day);
    final dayCount = range.end.difference(range.start).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DayTasks(
        date: DateTime(
          range.start.year,
          range.start.month,
          range.start.day + index,
        ),
        amountTasks: 0,
      ),
    );
  }
}
