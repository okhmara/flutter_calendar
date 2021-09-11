import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar/controller/task_controller.dart';
import 'package:flutter_calendar/model/task_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final kDropdownMenuStyle = TextStyle(
  color: Colors.blueAccent,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

final kUnderLineStyle = Container(
  height: 0,
  color: Colors.blueAccent,
);

class TaskArea extends StatefulWidget {
  final DateTime day;

  TaskArea({Key? key, required this.day}) : super(key: key);

  @override
  _TaskAreaState createState() => _TaskAreaState();
}

class _TaskAreaState extends State<TaskArea> {
  final _description = TextEditingController(text: 'new task');

  final hours = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 24];

  final minutes = [0, 30];

  int hoursValue = 0;

  int minutesValue = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            '${DateFormat("EEE, d MMM ''yy").format(widget.day)}',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _description,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('duration'),
              const Icon(Icons.timer),
              Row(
                children: [
                  _selectHours(),
                  Text(':', style: kDropdownMenuStyle),
                  _selectMinutes(),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: Icon(Icons.save_alt),
              label: Text('Add task'),
              onPressed: () => _addTask(),
            ),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    print('new task: $hoursValue:$minutesValue ${_description.text}');
    if (hoursValue == 0 && minutesValue == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Duration must be set.')),
      );
      return;
    }
    Get.find<TaskController>().addTask(Task(
      description: _description.text,
      date: widget.day,
      duration: Duration(
        hours: hoursValue,
        minutes: minutesValue,
      ),
    ));
    Navigator.of(context).pop();
  }

  _selectHours() {
    return DropdownButton<int>(
      value: hoursValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: kDropdownMenuStyle,
      underline: kUnderLineStyle,
      onChanged: (int? newValue) {
        setState(() {
          hoursValue = newValue!;
        });
      },
      items: hours.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Center(child: Text('$value')),
        );
      }).toList(),
      selectedItemBuilder: (BuildContext context) {
        return hours.map<Widget>((int value) {
          return Container(
              alignment: Alignment.centerRight,
              width: 30,
              child: Text('$value', textAlign: TextAlign.end));
        }).toList();
      },
    );
  }

  _selectMinutes() {
    return DropdownButton<int>(
      value: minutesValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: kDropdownMenuStyle,
      underline: kUnderLineStyle,
      onChanged: (int? newValue) {
        setState(() {
          minutesValue = newValue!;
        });
      },
      items: minutes.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Center(child: Text('$value')),
        );
      }).toList(),
      selectedItemBuilder: (BuildContext context) {
        return minutes.map<Widget>((int value) {
          return Container(
              alignment: Alignment.centerRight,
              width: 30,
              child: Text(
                '$value',
                // textAlign: TextAlign.end,
              ));
        }).toList();
      },
    );
  }
}

Future<void> addTaskDialog(BuildContext context, DateTime day) async {
  return showDialog<void>(
    context: context,
    // barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add task'),
        content: TaskArea(day: day),
      );
    },
  );
}
