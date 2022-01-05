import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        child: Column(children: [
          const Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CountDown(),
              CountUp(),
            ],
          ),
          const Divider(thickness: 1),
        ]),
        // child: Column(
        //   children: [
        //     const Divider(thickness: 1),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: const [
        //         CountDown(),
        //         CountUp(),
        //       ],
        //     ),
        //     const Divider(
        //       thickness: 1,
        //     ),
        //     CommonButton(onTap: () {}, buttonText: '운동추가'),
        //     Expanded(
        //       child: CustomScrollView(
        //         slivers: [
        //           SliverList(
        //             delegate: SliverChildBuilderDelegate(
        //               (context, index) {
        //                 return Center(child: Container(child: Text('1')));
        //               },
        //               childCount: 10,
        //             ),
        //           )
        //         ],
        //       ),
        //     )
        // CountDown(),
        // Divider(
        //   thickness: 1,
        // ),
        // CountUp(),
        // Divider(
        //   thickness: 1,
        // ),
        //     ],
        //   ),
      ),
    );
  }
}
