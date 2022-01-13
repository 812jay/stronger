import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
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
    double height = MediaQuery.of(context).size.height;

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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return WorkoutCard(
                            selectedDay: selectedDay,
                            title: sp.dayWorkouts[index].title,
                            category: sp.dayWorkouts[index].category,
                            sets: sp.dayWorkoutSets[index],
                          );
                        },
                        childCount: sp.dayWorkouts.length,
                      ),
                    )
                  ],
                ),
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

class WorkoutCard extends StatelessWidget {
  const WorkoutCard(
      {required this.selectedDay,
      required this.title,
      required this.category,
      required this.sets,
      Key? key})
      : super(key: key);

  final DateTime selectedDay;
  final String title;
  final String category;
  final List<Map<String, dynamic>> sets;

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final sp = Provider.of<ScheduleProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int index = 0;
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: height * 0.01),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.01,
            ),
            width: width * 0.95,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontSize: 23),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          category,
                          style: const TextStyle(
                            color: ColorsStronger.grey,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        sp.deleteScheduleWorkouts(
                          ap.uid!,
                          Timestamp.fromDate(selectedDay),
                          title,
                        );
                      },
                      child: const Icon(
                        Icons.delete_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ...sets.map((set) {
                  index++;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$index'),
                          Text('${set['weight']}kg'),
                          Text('${set['reps']}회'),
                          Text('${set['time']}초'),
                          set['isChecked']
                              ? GestureDetector(
                                  onTap: () {
                                    print('change false');
                                  },
                                  child: const Icon(
                                    Icons.check_box,
                                    color: ColorsStronger.lightGreen,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    print('change true');
                                  },
                                  child: const Icon(
                                    Icons.check_box_outline_blank,
                                  ),
                                )
                        ],
                      )
                    ],
                  );
                }),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: width * 0.4,
                        height: 40,
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: const Center(
                          child: Text('세트 삭제'),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: width * 0.4,
                        height: 40,
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: const Center(child: Text('세트 추가')),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
