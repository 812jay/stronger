import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
import 'package:stronger/utils/calculator.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_button.dart';
import 'package:stronger/widgets/schedule/count_down.dart';
import 'package:stronger/widgets/schedule/count_up.dart';

class ScheduleEditView extends StatelessWidget {
  static const routeName = 'schedule/edit';
  const ScheduleEditView({required this.selectedDay, Key? key})
      : super(key: key);
  final DateTime selectedDay;
  @override
  Widget build(BuildContext context) {
    final sp = Provider.of<ScheduleProvider>(context);
    final calculator = Calculator();
    double width = MediaQuery.of(context).size.width;

    List<String> getTodayWorkoutsDatas() {
      List<String> result = [];
      for (var todayWorkout in sp.todayWorkouts) {
        final bool compareDate = calculator.compareTimestampToDatetime(
            todayWorkout['scheduleDate'], Timestamp.fromDate(selectedDay));
        if (compareDate) {
          result = todayWorkout['workoutsTitle'];
        }
      }
      return result;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('yyyy-MM-dd').format(selectedDay),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                CountDown(),
                CountUp(),
              ],
            ),
            const Divider(thickness: 1),
            CommonButton(
              onTap: () {
                sp.clearSelectedworkoutsTitle();
                Navigator.of(context, rootNavigator: true)
                    .pushNamed('schedule/add/workouts');
              },
              buttonText: '운동 선택',
            ),
            const Divider(thickness: 1),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: width * 0.85,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        getTodayWorkoutsDatas()[index],
                                        style: const TextStyle(fontSize: 23),
                                      ),
                                      Text(
                                        sp.todayWorkoutsInfo.isNotEmpty
                                            ? sp.todayWorkoutsInfo[index]
                                                .category
                                            : '',
                                        style: const TextStyle(
                                            color: ColorsStronger.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      childCount: getTodayWorkoutsDatas().length,
                    ),
                  )
                ],
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: '오늘의 메모',
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
