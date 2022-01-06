import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
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
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed('schedule/addworkouts');
                },
                buttonText: '운동 추가'),
            const Divider(thickness: 1),
            Expanded(
              child: Consumer<ScheduleProvider>(builder: (_, sp, __) {
                return CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Text(sp.selectedWorkouts[index]);
                        },
                        childCount: sp.selectedWorkouts.length,
                      ),
                    )
                  ],
                );
              }),
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
