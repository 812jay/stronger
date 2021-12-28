import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WorkoutInfoView extends StatelessWidget {
  static const routeName = 'workout/info';
  const WorkoutInfoView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(builder: (_, lp, __) {
      final workoutInfo = lp.workoutInfo;
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    workoutInfo.title,
                    style: const TextStyle(color: Colors.black),
                  ),
                  workoutInfo.isBookmarked
                      ? const Icon(
                          Icons.bookmark,
                          color: ColorsStronger.primaryBG,
                        )
                      : const Icon(
                          Icons.bookmark_border,
                          color: Colors.black,
                        ),
                ],
              ),
              const Icon(
                Icons.edit,
                color: Colors.black,
              )
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              const Divider(
                thickness: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '부위',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    workoutInfo.category,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ), //카테고리
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '도구',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Row(
                    children: [
                      ...workoutInfo.tools
                          .map((tool) => Text(
                                ' $tool',
                                style: const TextStyle(fontSize: 18.0),
                              ))
                          .toList(),
                    ],
                  ),
                ],
              ), //도구
              const Divider(
                thickness: 1.0,
              ),
              const Text(
                '운동설명',
                style: TextStyle(color: ColorsStronger.grey, fontSize: 18.0),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(workoutInfo.description),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                '운동이력',
                style: TextStyle(color: ColorsStronger.grey, fontSize: 18.0),
              ),
              const SizedBox(
                height: 10.0,
              ),
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <LineSeries<WorkoutsData, String>>[
                    LineSeries<WorkoutsData, String>(
                      // Bind data source
                      dataSource: <WorkoutsData>[
                        // WorkoutsData('2021.10.20', 35),
                        // WorkoutsData('2021.10.26', 28),
                        // WorkoutsData('2021.11.10', 35),
                        // WorkoutsData('2021.11.20', 48),
                        // WorkoutsData('2021.11.25', 46),
                      ],
                      xValueMapper: (WorkoutsData sales, _) =>
                          sales.workoutDate,
                      yValueMapper: (WorkoutsData sales, _) => sales.volume,
                    )
                  ]),
              const Text(
                '이전기록',
                style: TextStyle(color: ColorsStronger.grey, fontSize: 18.0),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                width: double.infinity,
                // height: 200,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: ColorsStronger.grey),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.arrow_back_ios),
                        Text(
                          // DateFormat('yyyy-MM-dd')
                          //     .format(lp.workoutInfoDates[0].toDate())
                          //     .toString(),
                          '2021-12-22',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    const Divider(
                      thickness: 1.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: const [
                            Text('세트'),
                            Text('1'),
                          ],
                        ),
                        Column(
                          children: const [
                            Text('무게'),
                            Text('100kg'),
                          ],
                        ),
                        Column(
                          children: const [
                            Text('횟수'),
                            Text('12회'),
                          ],
                        ),
                        Column(
                          children: const [
                            Text('시간'),
                            Text('60초'),
                          ],
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1.0,
                    ),
                    const Center(
                      child: Text('총 볼륨 1200kg'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class WorkoutsData {
  WorkoutsData(this.workoutDate, this.volume);
  final String workoutDate;
  final double volume;
}