import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/widget/task_page.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);
  final rowAmount = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar',
          style: TextStyle(fontSize: 24),
        ),
        // actions: [Icon(Icons.search), SizedBox(width: 12)],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Table(
              border: TableBorder.all(
                color: Colors.blue,
              ),
              children: [
                _buildDaysOfWeek(context),
                ..._buildCalendarDays(context),
              ],
            ),
            InkWell(
              // When the user taps the button, show a snackbar.
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Tap'),
                ));
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Flat Button'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TableRow> _buildCalendarDays(BuildContext context) {
    return List.generate(5, (index) => index)
        .map(
          (index) => TableRow(
            // decoration: BoxDecoration(color: Colors.yellow),
            children: _buildWeekDays(context, index * 7),
          ),
        )
        .toList();
  }

  List<Widget> _buildWeekDays(BuildContext context, int weekOffset) {
    final h = MediaQuery.of(context).size.height / 10;
    return List.generate(rowAmount, (index) => index + 1)
        .map(
          (index) => InkWell(
            onTap: () {
              print("Tapped a Container ${weekOffset + index}");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskPage(day: weekOffset + index)));
            },
            child: Container(
              height: h,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(1),
              child: Center(
                child: Text('${weekOffset + index}'),
              ),
            ),
          ),
        )
        .toList();
  }

  TableRow _buildDaysOfWeek(BuildContext context) {
    return TableRow(
      children: List.generate(rowAmount, (index) => index)
          .map(
            (index) => Center(
              heightFactor: 2,
              child: Text('Day $index'),
            ),
          )
          .toList(),
    );
  }
}
