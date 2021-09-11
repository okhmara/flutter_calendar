import 'package:flutter_calendar/controller/calendar_controller.dart';
import 'package:flutter_calendar/model/task_model.dart';
import 'package:flutter_calendar/utils/database_helper.dart';
import 'package:get/get.dart';

enum TaskControllerState { failure, loading, complete }

class TaskController extends GetxController {
  var state = TaskControllerState.loading.obs;
  var tasks = <Task>[].obs;
  // final DateTime date;

  final TasksDatabase db;

  TaskController(this.db);

  // @override
  // onInit() {
  //   print('TaskController init');
  //   super.onInit();
  // }

  loadTasks(DateTime day) async {
    print('loadtask');
    state.value = TaskControllerState.loading;
    try {
      final List<Task> list = await db.readAllTasks(day);
      if (list != []) {
        tasks.assignAll(list);
        tasks.refresh();
      }
    } finally {
      state.value = TaskControllerState.complete;
    }
  }

  addTask(Task task) async {
    task = await db.create(task);
    tasks.add(task);
    tasks.refresh();
    Get.find<CalendarController>().refresh();
  }

  deleteTask(Task task) async {
    await db.delete(task.id!);
    tasks.remove(task);
    tasks.refresh();
    Get.find<CalendarController>().refresh();
  }
}
