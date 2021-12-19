import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/calender_provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_card.dart';
import 'package:stronger/widgets/common/common_small_button.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutsCalendar extends StatelessWidget {
  static const routeName = 'calendar';
  const WorkoutsCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? uid = AuthProvider().uid;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer2<CalendarProvider, ScheduleProvider>(
              builder: (_, cp, sp, __) {
                return TableCalendar(
                  locale: 'ko-KR',
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2060),
                  onDaySelected: (selectDay, focusDay) {
                    sp.getSchedules(uid!, Timestamp.fromDate(selectDay));
                    cp.onDaySelect(selectDay, focusDay);
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(cp.selectedDay, day);
                  },
                  focusedDay: cp.selectedDay,
                  calendarFormat: cp.format,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  daysOfWeekVisible: true,
                  onPageChanged: (focusedDay) {
                    cp.onPageChange(focusedDay);
                  },
                  onFormatChanged: (format) {
                    cp.onFormatChange(format);
                  },
                  calendarStyle: const CalendarStyle(
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                      color: ColorsStronger.primaryBG,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: ColorsStronger.primaryBG,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '2021.12.14',
                        style: TextStyle(fontSize: 18),
                      ),
                      CommonSmallButton(
                        onTap: () {},
                        buttonText: '편집하기',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<CalendarProvider>(
                    builder: (_, cp, __) {
                      WorkoutViewTypes viewType = cp.selectedViewType;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              cp.onSelectViewType(WorkoutViewTypes.vol);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                                vertical: 5.0,
                              ),
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                color: viewType == WorkoutViewTypes.vol
                                    ? ColorsStronger.primaryBG
                                    : ColorsStronger.lightGrey,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'VOL',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: viewType == WorkoutViewTypes.vol
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ), //vol
                          GestureDetector(
                            onTap: () {
                              cp.onSelectViewType(WorkoutViewTypes.max);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                                vertical: 5.0,
                              ),
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                color: viewType == WorkoutViewTypes.max
                                    ? ColorsStronger.primaryBG
                                    : ColorsStronger.lightGrey,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'MAX',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: viewType == WorkoutViewTypes.max
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Consumer2<ScheduleProvider, CalendarProvider>(
                    builder: (_, sp, cp, __) {
                      final scheduleModel = sp.scheduleModel;
                      return Container(
                        margin: const EdgeInsets.only(top: 15),
                        height: 200,
                        width: double.infinity,
                        child: CustomScrollView(
                          scrollDirection: Axis.vertical,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return CommonCard(
                                    // onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    scheduleModel
                                                        .workouts[index],
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text(
                                                    '하체',
                                                    style: TextStyle(
                                                      color:
                                                          ColorsStronger.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                  Icons.check_circle_outline),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: const [
                                              Text('50kg x 20회'),
                                              Text('총합 1000kg'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    height: 80,
                                  );
                                },
                                childCount: sp.scheduleModel.workouts.length,
                              ),
                            ),
                          ],
                        ),
                      );
                      // CommonCard(
                      //   // onTap: () {},
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Row(
                      //               children: const [
                      //                 Text(
                      //                   '스쿼트',
                      //                   style: TextStyle(fontSize: 18),
                      //                 ),
                      //                 SizedBox(
                      //                   width: 5,
                      //                 ),
                      //                 Text(
                      //                   '하체',
                      //                   style: TextStyle(
                      //                     color: ColorsStronger.grey,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const Icon(Icons.check_circle_outline),
                      //           ],
                      //         ),
                      //         const SizedBox(
                      //           height: 5,
                      //         ),
                      //         Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           crossAxisAlignment: CrossAxisAlignment.end,
                      //           children: const [
                      //             Text('50kg x 20회'),
                      //             Text('총합 1000kg'),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //   height: 80,
                      // );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
