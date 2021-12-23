import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stronger/models/workout_model.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/calender_provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_card.dart';
import 'package:stronger/widgets/common/common_small_button.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutsCalendar extends StatefulWidget {
  static const routeName = 'calendar';
  const WorkoutsCalendar({Key? key}) : super(key: key);

  @override
  State<WorkoutsCalendar> createState() => _WorkoutsCalendarState();
}

List<WorkoutModel> workoutsData = [];

class _WorkoutsCalendarState extends State<WorkoutsCalendar> {
  @override
  Widget build(BuildContext context) {
    final String? uid = AuthProvider().uid;

    final sp = context.watch<ScheduleProvider>();
    final lp = context.select((LibraryProvider value) => value);
    final cp = context.watch<CalendarProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              locale: 'ko-KR',
              firstDay: DateTime(2000),
              lastDay: DateTime(2060),
              onDaySelected: (selectDay, focusDay) {
                cp.onDaySelect(selectDay, focusDay);
                sp.getSchedules(uid!, Timestamp.fromDate(selectDay));

                // print('dayworkout : ${lp.dayWorkouts}');
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd').format(cp.selectedDay),
                        style: const TextStyle(fontSize: 18),
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
                  (Container(
                    margin: const EdgeInsets.only(top: 15),
                    height: 200,
                    width: double.infinity,
                    child: CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: [
                        FutureBuilder(
                          future: LibraryProvider()
                              .getWorkouts(uid!, sp.scheduleModel.workouts),
                          builder: (context, snapshot) {
                            List<WorkoutModel> workoutsData =
                                snapshot.data as List<WorkoutModel>;
                            print(workoutsData.length);
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return CommonCard(
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
                                                    sp.scheduleModel
                                                        .workouts[index],
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '${workoutsData[index].category}',
                                                    // '',
                                                    style: const TextStyle(
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
                                // childCount: 1,

                                // childCount: lp.dayWorkouts.length,
                                childCount: workoutsData.length,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ))
                  // : (Container())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
