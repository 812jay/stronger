import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
import 'package:stronger/widgets/common/common_button.dart';

class SetSetting extends StatelessWidget {
  const SetSetting({
    required this.scheduleDate,
    required this.workout,
    required this.setIndex,
    required this.weight,
    required this.reps,
    required this.time,
    Key? key,
  }) : super(key: key);
  final DateTime scheduleDate;
  final String workout;
  final int setIndex;
  final int weight;
  final int reps;
  final int time;

  @override
  Widget build(BuildContext context) {
    String? uid = context.read<AuthProvider>().uid;
    return Consumer<ScheduleProvider>(builder: (_, sp, __) {
      return Container(
        height: 250,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                // NumberPicker(
                //   itemWidth: 30,
                //   minValue: 0,
                //   maxValue: 500,
                //   value: sp.selectedIntWeight,
                //   onChanged: (value) {
                //     sp.setIntWeight(value);
                //   },
                //   step: 1,
                // ),
                // const Text('.'),
                // NumberPicker(
                //   itemWidth: 30,
                //   minValue: 0,
                //   maxValue: 9,
                //   value: sp.selectedDecimalWeight,
                //   onChanged: (value) {
                //     sp.setDecimalWeight(value);
                //   },
                //   step: 1,
                // ),
                NumberPicker(
                  itemWidth: 30,
                  minValue: 0,
                  maxValue: 1000,
                  value: sp.selectedWeight,
                  onChanged: (value) {
                    sp.setWeight(value);
                  },
                  step: 1,
                ),
                const SizedBox(width: 20),
                const Text('kg'),
                const SizedBox(width: 20),
                NumberPicker(
                  itemWidth: 30,
                  minValue: 0,
                  maxValue: 1000,
                  value: sp.selectedReps,
                  onChanged: (value) => sp.setReps(value),
                ),
                const Text('회'),
                const SizedBox(width: 20),
                NumberPicker(
                  itemWidth: 30,
                  minValue: 0,
                  maxValue: 1000,
                  value: sp.selectedMinutes,
                  onChanged: (value) => sp.setMinutes(value),
                ),
                const Text('분'),
                const SizedBox(width: 20),
                NumberPicker(
                  itemWidth: 30,
                  minValue: 0,
                  maxValue: 1000,
                  value: sp.selectedSeconds,
                  onChanged: (value) => sp.setSeconds(value),
                ),
                const Text('초'),
              ],
            ),
            CommonButton(
              onTap: () async {
                await sp.editDayWorkoutSet(
                  uid!,
                  Timestamp.fromDate(scheduleDate),
                  workout,
                  setIndex,
                );

                await sp.setWorkoutsSchedule(
                  uid,
                  Timestamp.fromDate(
                    scheduleDate,
                  ),
                );
                sp.setDayWorkoutRecords(
                  Timestamp.fromDate(
                    scheduleDate,
                  ),
                );
                Navigator.pop(context);
              },
              buttonText: '확인',
              buttonColor: Colors.black,
            )
          ],
        ),
      );
    });
  }
}
