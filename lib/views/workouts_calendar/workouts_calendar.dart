import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/calender_provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/views/schedule/schedule_edit_view.dart';
import 'package:stronger/widgets/calendar/workout_list.dart';
import 'package:stronger/widgets/common/common_small_button.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutsCalendar extends StatefulWidget {
  static const routeName = 'calendar';
  const WorkoutsCalendar({Key? key}) : super(key: key);

  @override
  State<WorkoutsCalendar> createState() => _WorkoutsCalendarState();
}

class _WorkoutsCalendarState extends State<WorkoutsCalendar> {
  @override
  void initState() {
    Future.microtask(() {
      onDaySelect(context, DateTime.now());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? uid = context.read<AuthProvider>().uid;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer2<CalendarProvider, ScheduleProvider>(
              builder: (context, cp, sp, _) {
                return TableCalendar(
                  locale: 'ko-KR',
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2060),
                  onDaySelected: (selectedDay, _) =>
                      onDaySelect(context, selectedDay),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  selectedDayPredicate: (selectedDay) {
                    return isSameDay(cp.selectedDay, selectedDay);
                  },
                  focusedDay: cp.selectedDay,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  daysOfWeekVisible: true,
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
                  Consumer2<ScheduleProvider, CalendarProvider>(
                      builder: (_, sp, cp, __) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(cp.selectedDay),
                          style: const TextStyle(fontSize: 18),
                        ),
                        CommonSmallButton(
                          onTap: () {
                            // sp.setWorkoutsSchedule(
                            //   uid!,
                            //   Timestamp.fromDate(cp.selectedDay),
                            // );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ScheduleEditView(
                                    selectedDay: cp.selectedDay,
                                  );
                                },
                              ),
                            );
                          },
                          buttonText: '편집하기',
                        ),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  //TODO: VOL/MAX 기능 추가해야 한다.
                  Consumer<ScheduleProvider>(
                    builder: (_, sp, __) {
                      WorkoutViewTypes viewType = sp.selectedViewType;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              sp.onSelectViewType(WorkoutViewTypes.vol);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                                vertical: 5.0,
                              ),
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                color: viewType.isVol
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
                                    color: viewType.isVol
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ), //vol
                          GestureDetector(
                            onTap: () {
                              sp.onSelectViewType(WorkoutViewTypes.max);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                                vertical: 5.0,
                              ),
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                color: viewType.isMax
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
                                    color: viewType.isMax
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
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    height: 200,
                    width: double.infinity,
                    child: const CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: [WorkoutList()],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onDaySelect(BuildContext context, DateTime selectedDay) async {
    final cp = context.read<CalendarProvider>();
    final sp = context.read<ScheduleProvider>();
    final lp = context.read<LibraryProvider>();
    final String uid = context.read<AuthProvider>().uid!;

    cp.onDaySelect(selectedDay);
    await sp.setSchedule(uid, Timestamp.fromDate(selectedDay));
    sp.setDayWorkouts(lp.workoutModels);
    sp.setDayWorkoutRecords(Timestamp.fromDate(selectedDay));
    // sp.setDayWorkoutSets(Timestamp.fromDate(selectedDay));
  }
}
