import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/library_provider.dart';
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
    final lp = Provider.of<LibraryProvider>(context);

    final calculator = Calculator();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // List<String> getTodayWorkoutsDatas() {
    //   List<String> result = [];
    //   for (var todayWorkout in sp.todayWorkouts) {
    //     final bool compareDate = calculator.compareTimestampToDatetime(
    //         todayWorkout['scheduleDate'], Timestamp.fromDate(selectedDay));
    //     if (compareDate) {
    //       result = todayWorkout['titles'];
    //     }
    //   }
    //   return result;
    // }

    // List<Widget> getDayWorkoutsDatas(List<dynamic> dayWorkouts) {
    //   List<Widget> dayWorkoutsResult = [];
    //   print(dayWorkouts);
    //   return [Container()];
    // }

    List<Widget> getDayWorkoutSets(List<dynamic> workoutSets) {
      List<Widget> result = [];
      int index = 0;
      print(workoutSets);
      for (var set in workoutSets) {
        print(set['reps']);
        index++;
        result.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$index'),
              Text('${set['weight']}kg'),
              Text('${set['reps']}회'),
              Text('${set['time']}초'),
            ],
          ),
        );
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
                              margin:
                                  EdgeInsets.symmetric(vertical: height * 0.01),
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: height * 0.01,
                              ),
                              width: width * 0.95,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: ColorsStronger.grey,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            sp.dayWorkouts[index].title,
                                            style:
                                                const TextStyle(fontSize: 23),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            sp.dayWorkouts[index].category,
                                            style: const TextStyle(
                                              color: ColorsStronger.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: const Icon(
                                          Icons.delete_outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('세트'),
                                  //     Text('무게'),
                                  //     Text('횟수'),
                                  //     // Text('시간'),
                                  //     Text('')
                                  //     // Icon(Icons.check_box_outline_blank)
                                  //   ],
                                  // ),

                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Column(
                                  //       children: getDayWorkoutSets(sp.),
                                  //     ),
                                  //     Column(
                                  //       children: getRecordSetsDatas('weight'),
                                  //     ),
                                  //     Column(
                                  //       children: getRecordSetsDatas('reps'),
                                  //     ),
                                  //     Column(
                                  //       children: getRecordSetsDatas('time'),
                                  //     ),
                                  //   ],
                                  // ),

                                  Column(
                                    children: getDayWorkoutSets(
                                        sp.dayWorkoutSets[index]),
                                  ),
                                  // getDayWorkoutSets(sp.dayWorkoutSets[index]),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: width * 0.4,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1)),
                                          child: const Center(
                                              child: Text('세트 삭제')),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // sp.setTodayWorkoutSets(
                                          //   Timestamp.fromDate(selectedDay),
                                          //   getTodayWorkoutsDatas()[index],
                                          // );
                                          // print(sp.dayWorkoutSets[index]);
                                        },
                                        child: Container(
                                          width: width * 0.4,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1)),
                                          child: const Center(
                                              child: Text('세트 추가')),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      childCount: sp.dayWorkouts.length,
                    ),
                  )
                ],
              ),
            ),
            // Expanded(
            //   child: CustomScrollView(
            //     slivers: [
            //       SliverList(
            //         delegate: SliverChildBuilderDelegate(
            //           (context, index) {
            //             return Column(
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 Container(
            //                   margin:
            //                       EdgeInsets.symmetric(vertical: height * 0.01),
            //                   padding: EdgeInsets.symmetric(
            //                     horizontal: width * 0.05,
            //                     vertical: height * 0.01,
            //                   ),
            //                   width: width * 0.95,
            //                   decoration: BoxDecoration(
            //                     border: Border.all(
            //                       width: 1,
            //                       color: ColorsStronger.grey,
            //                     ),
            //                     borderRadius: BorderRadius.circular(5),
            //                   ),
            //                   child: Column(
            //                     children: [
            //                       Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Row(
            //                             // mainAxisAlignment:
            //                             //     MainAxisAlignment.spaceBetween,
            //                             children: [
            //                               Text(
            //                                 getTodayWorkoutsDatas()[index],
            //                                 style:
            //                                     const TextStyle(fontSize: 23),
            //                               ),
            //                               const SizedBox(width: 5),
            //                               Text(
            //                                 sp.todayWorkoutsInfo.isNotEmpty
            //                                     ? sp.todayWorkoutsInfo[index]
            //                                         .category
            //                                     : '',
            //                                 style: const TextStyle(
            //                                   color: ColorsStronger.grey,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           GestureDetector(
            //                             onTap: () {},
            //                             child: const Icon(
            //                               Icons.delete_outline,
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       const SizedBox(
            //                         height: 10,
            //                       ),
            //                       Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           Text('세트'),
            //                           Text('무게'),
            //                           Text('횟수'),
            //                           // Text('시간'),
            //                           Text('')
            //                           // Icon(Icons.check_box_outline_blank)
            //                         ],
            //                       ),
            //                       const SizedBox(
            //                         height: 30,
            //                       ),
            //                       Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceAround,
            //                         children: [
            //                           GestureDetector(
            //                             onTap: () {},
            //                             child: Container(
            //                               width: width * 0.4,
            //                               height: 40,
            //                               decoration: BoxDecoration(
            //                                   border: Border.all(width: 1)),
            //                               child: const Center(
            //                                   child: Text('세트 삭제')),
            //                             ),
            //                           ),
            //                           GestureDetector(
            //                             onTap: () {
            //                               sp.setTodayWorkoutSets(
            //                                 Timestamp.fromDate(selectedDay),
            //                                 getTodayWorkoutsDatas()[index],
            //                               );
            //                             },
            //                             child: Container(
            //                               width: width * 0.4,
            //                               height: 40,
            //                               decoration: BoxDecoration(
            //                                   border: Border.all(width: 1)),
            //                               child: const Center(
            //                                   child: Text('세트 추가')),
            //                             ),
            //                           ),
            //                         ],
            //                       )
            //                     ],
            //                   ),
            //                 )
            //               ],
            //             );
            //           },
            //           childCount: getTodayWorkoutsDatas().length,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
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
