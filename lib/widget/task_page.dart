import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar/widget/add_task.dart';

class TaskPage extends StatelessWidget {
  final day;
  const TaskPage({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$day")),
      body: Container(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print('add task');
          addTask(context, DateTime.now());
          // Add your onPressed code here!
          // MaterialPageRoute(builder: (context) => AddTask());
        },
        label: const Text('Add task'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
