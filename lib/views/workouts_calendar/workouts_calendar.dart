import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutsCalendar extends StatelessWidget {
  const WorkoutsCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    CalendarFormat format = CalendarFormat.month;
    DateTime selectedDay = DateTime.now();
    DateTime focusedDate = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(1980),
              lastDay: DateTime(2060),
              focusedDay: selectedDay,
            ),
          ],
        ),
      ),
    );
  }
}
