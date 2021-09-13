import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar/controller/calendar_controller.dart';
import 'package:flutter_calendar/controller/task_controller.dart';
import 'package:flutter_calendar/model/task_model.dart';
import 'package:flutter_calendar/utils/database_helper.dart';
import 'package:flutter_calendar/widget/task/add_task.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatelessWidget {
  final DateTime day;
  const TaskPage({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(TaskController(TasksDatabase.instance));
    _controller.loadTasks(day);
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              if (_controller.modified.isTrue) {
                Get.find<CalendarController>().refresh();
              }
              Navigator.pop(context);
            },
          ),
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: DateFormat("EEEE, d MMM ''yy").format(day).toString(),
                style: TextStyle(fontSize: 20),
                children: <TextSpan>[
                  TextSpan(
                    text: '\nnumber of tasks: ${_controller.tasks.length}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ]),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: _controller.tasks.length,
            itemBuilder: (BuildContext context, int index) {
              final task = _controller.tasks[index];
              return Dismissible(
                child: ListTile(
                  title: Text(task.description),
                  subtitle: Text(
                      'duration: ${task.duration.toString().substring(0, 4)}'),
                ),
                key: ObjectKey(task),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) =>
                    dismissTask(context, direction, task),
                confirmDismiss: (_) async =>
                    showConfirmDialog(context, task.description),
                background: buildSwipeActionLeft(),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => addTaskDialog(context, day),
          label: const Text('Add task'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.cyan,
        ),
      );
    });
  }

  Future<bool?> dismissTask(
    BuildContext context,
    DismissDirection direction,
    Task task,
  ) async {
    Get.find<TaskController>().deleteTask(task);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('task ${task.description} dismissed')));
  }

  Widget buildSwipeActionLeft() {
    return Container(
      color: Colors.redAccent,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.delete_forever,
            color: Colors.black,
            size: 32,
          ),
        ],
      ),
    );
  }

  Future<bool?> showConfirmDialog(
      BuildContext context, String description) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text(
              'Are you sure you wish to delete this task "${description.toUpperCase()}"?'),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Confirm")),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
