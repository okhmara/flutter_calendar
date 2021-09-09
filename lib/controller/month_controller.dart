import 'package:flutter_calendar/model/model_day.dart';
import 'package:flutter_calendar/model/model_month.dart';
import 'package:get/get.dart';

enum MonthState { failure, loading, complete }

class MonthController extends GetxController {
  var state = MonthState.loading.obs;
  // var items = <HistoryItemsGroupped>[].obs;
  var selected = DateTime.now().obs;
  var days = [].obs;

  @override
  onInit() {
    loadMonthData(DateTime.now());
    super.onInit();
  }

  loadMonthData(DateTime day) async {
    state.value = MonthState.loading;
    final month = PageOfMonth(day);
    try {
      days.clear();
      final List<DateTime> list = month.getDaysInPage(day);
      days.assignAll(month.getDaysInPage(day));
      if (list != []) {
        days.assignAll(month.getDaysInPage(day));
      }
      days.refresh();
    } finally {
      state.value = MonthState.complete;
    }
  }

  refresh() async {
    await loadMonthData(selected.value);
  }
}
