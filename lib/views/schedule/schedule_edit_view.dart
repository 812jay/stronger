import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
import 'package:stronger/utils/calculator.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_button.dart';
import 'package:stronger/widgets/schedule/count_down.dart';
import 'package:stronger/widgets/schedule/count_up.dart';
import 'package:stronger/widgets/schedule/set_setting.dart';

class ScheduleEditView extends StatefulWidget {
  static const routeName = 'schedule/edit';
  const ScheduleEditView({required this.selectedDay, Key? key})
      : super(key: key);
  final DateTime selectedDay;

  @override
  State<ScheduleEditView> createState() => _ScheduleEditViewState();
}

class _ScheduleEditViewState extends State<ScheduleEditView> {
  var _descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _descriptionController = TextEditingController(text: widget.description);
    final String description =
        context.read<ScheduleProvider>().scheduleModel.description;
    _descriptionController = TextEditingController(text: description);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthProvider>().uid;

    final calculator = Calculator();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat('yyyy-MM-dd').format(widget.selectedDay),
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
        child: Consumer<ScheduleProvider>(builder: (_, sp, __) {
          return Column(
            children: [
              // const Divider(thickness: 1),
              GestureDetector(
                onTap: () {
                  sp.setViewTimer();
                },
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(vertical: height * 0.01),
                  margin: EdgeInsets.only(bottom: height * 0.02),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: ColorsStronger.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sp.viewTimer
                          ? const Text('????????? ??????')
                          : const Text('????????? ??????'),
                      sp.viewTimer
                          ? const Icon(Icons.arrow_drop_up)
                          : const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              sp.viewTimer
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        CountDown(),
                        CountUp(),
                      ],
                    )
                  : Container(),
              sp.viewTimer ? const Divider(thickness: 1) : Container(),
              // const SizedBox(
              //   height: 10,
              // ),
              CommonButton(
                onTap: () async {
                  sp.clearSelectedWorkoutsTitle();
                  final result =
                      await Navigator.of(context, rootNavigator: true)
                          .pushNamed('schedule/add/workouts');
                  print(result);
                  if (result == true) {
                    // sp.setWorkoutsSchedule(uid!, Timestamp.fromDate(selectedDay));
                  }
                },
                buttonText: '?????? ??????',
                buttonColor: Colors.black,
                textColor: Colors.white,
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
                            final dayWorkouts = sp.dayWorkouts[index];
                            final dayWorkoutSets = sp.dayWorkoutSets.isNotEmpty
                                ? sp.dayWorkoutSets[index]
                                : [];
                            return Card(
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: height * 0.01),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05,
                                      vertical: height * 0.01,
                                    ),
                                    width: width * 0.95,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  dayWorkouts.title,
                                                  style: const TextStyle(
                                                    fontSize: 23,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  dayWorkouts.category,
                                                  style: const TextStyle(
                                                    color: ColorsStronger.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await sp.deleteScheduleWorkouts(
                                                  uid!,
                                                  Timestamp.fromDate(
                                                    widget.selectedDay,
                                                  ),
                                                  dayWorkouts.title,
                                                );
                                                await sp.setWorkoutsSchedule(
                                                  uid,
                                                  Timestamp.fromDate(
                                                    widget.selectedDay,
                                                  ),
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
                                        if (dayWorkoutSets.isNotEmpty)
                                          ...dayWorkoutSets.map((set) {
                                            int setIndex = 0;
                                            setIndex =
                                                dayWorkoutSets.indexOf(set);
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    sp.setInitSetData(
                                                      set['weight'],
                                                      set['reps'],
                                                      set['time'],
                                                    );
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        sp.setInitSetData(
                                                          set['weight'],
                                                          set['reps'],
                                                          set['time'],
                                                        );
                                                        return SetSetting(
                                                            setIndex: setIndex,
                                                            scheduleDate: widget
                                                                .selectedDay,
                                                            workout: dayWorkouts
                                                                .title,
                                                            weight:
                                                                set['weight'],
                                                            reps: set['reps'],
                                                            time: set['time']);
                                                      },
                                                    );
                                                  },
                                                  child: Row(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment
                                                    //         .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                              '${setIndex + 1}')),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                            '${set['weight']}kg'),
                                                      ),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                              '${set['reps']}???')),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              (set['time'] / 60)
                                                                          .floor() !=
                                                                      0
                                                                  ? Text(
                                                                      '${(set['time'] / 60).floor()}???${(set['time'] % 60) != 0 ? '${(set['time'] % 60)}???' : ''}')
                                                                  : Text(
                                                                      '${(set['time'] % 60)}???',
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: set['isChecked']
                                                            ? Align(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    await sp
                                                                        .changeIsChecked(
                                                                      uid!,
                                                                      Timestamp
                                                                          .fromDate(
                                                                        widget
                                                                            .selectedDay,
                                                                      ),
                                                                      dayWorkouts
                                                                          .title,
                                                                      setIndex,
                                                                    );
                                                                    await sp
                                                                        .setWorkoutsSchedule(
                                                                      uid,
                                                                      Timestamp
                                                                          .fromDate(
                                                                        widget
                                                                            .selectedDay,
                                                                      ),
                                                                    );

                                                                    sp.setDayWorkoutRecords(
                                                                      Timestamp
                                                                          .fromDate(
                                                                        widget
                                                                            .selectedDay,
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .check_box,
                                                                    color: ColorsStronger
                                                                        .lightGreen,
                                                                  ),
                                                                ),
                                                              )
                                                            : Align(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    await sp
                                                                        .changeIsChecked(
                                                                      uid!,
                                                                      Timestamp
                                                                          .fromDate(
                                                                        widget
                                                                            .selectedDay,
                                                                      ),
                                                                      dayWorkouts
                                                                          .title,
                                                                      setIndex,
                                                                    );
                                                                    await sp
                                                                        .setWorkoutsSchedule(
                                                                      uid,
                                                                      Timestamp
                                                                          .fromDate(
                                                                        widget
                                                                            .selectedDay,
                                                                      ),
                                                                    );

                                                                    sp.setDayWorkoutRecords(
                                                                      Timestamp
                                                                          .fromDate(
                                                                        widget
                                                                            .selectedDay,
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .check_box_outline_blank,
                                                                  ),
                                                                ),
                                                              ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          }),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await sp.deleteDayWorkoutSet(
                                                  uid!,
                                                  Timestamp.fromDate(
                                                      widget.selectedDay),
                                                  dayWorkouts.title,
                                                );
                                                await sp.setWorkoutsSchedule(
                                                  uid,
                                                  Timestamp.fromDate(
                                                    widget.selectedDay,
                                                  ),
                                                );
                                                sp.setDayWorkoutRecords(
                                                  Timestamp.fromDate(
                                                    widget.selectedDay,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: width * 0.4,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1),
                                                ),
                                                child: const Center(
                                                  child: Text('?????? ??????'),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await sp.addDayWorkoutSet(
                                                  uid!,
                                                  Timestamp.fromDate(
                                                    widget.selectedDay,
                                                  ),
                                                  dayWorkouts.title,
                                                );

                                                await sp.setWorkoutsSchedule(
                                                  uid,
                                                  Timestamp.fromDate(
                                                    widget.selectedDay,
                                                  ),
                                                );
                                                sp.setDayWorkoutRecords(
                                                  Timestamp.fromDate(
                                                    widget.selectedDay,
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: width * 0.4,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    border:
                                                        Border.all(width: 1)),
                                                child: const Center(
                                                  child: Text('?????? ??????'),
                                                ),
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
                          },
                          childCount: sp.dayWorkouts.length,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: '????????? ??????',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
              ),
              // Container(
              //   height: 50,
              //   child: Text(
              //     '??????',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(),
              //   ),
              // )
              SizedBox(
                width: width,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () async {
                    await sp.addScheduleDescription(
                      uid!,
                      Timestamp.fromDate(
                        widget.selectedDay,
                      ),
                      _descriptionController.text,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '??????',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
