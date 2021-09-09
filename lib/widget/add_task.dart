import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

final kDropdownMenuStyle = TextStyle(color: Colors.blueAccent);
final kUnderLineStyle = Container(
  height: 2,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('duration'),
              _selectHours(),
              const Text('hour'),
              _selectMinutes(),
              const Text('min'),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            controller: _description,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              icon: Icon(Icons.save_alt),
              label: Text('Add task'),
              onPressed: () {
                print(
                    'new task: $hoursValue:$minutesValue ${_description.text}');
              },
            ),
          ),
        ],
      ),
    );
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
          child: Text('$value'),
        );
      }).toList(),
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
          child: Text('$value'),
        );
      }).toList(),
    );
  }
}

Future<void> addTask(BuildContext context, DateTime day) async {
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
