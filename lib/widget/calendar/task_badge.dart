import 'package:flutter/material.dart';

class TaskBandge extends StatelessWidget {
  final int taskAmount;
  const TaskBandge({Key? key, required this.taskAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (taskAmount > 0) {
      return Align(
        alignment: Alignment.bottomRight,
        child: Container(
          height: 16,
          width: 20,
          color: Colors.lightBlue,
          child: Center(
            child: Text(
              '$taskAmount',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
