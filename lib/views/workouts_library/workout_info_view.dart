import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/views/workouts_library/workout_edit_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WorkoutInfoView extends StatelessWidget {
  static const routeName = 'workout/info';
  const WorkoutInfoView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, LibraryProvider>(builder: (_, up, lp, __) {
      final workoutInfo = lp.workoutInfo;
      final uid = up.userModel.uid;

      List<Widget> getRecordSetsDatas(String type) {
        List<Widget> result = [];
        if (type == 'set') {
          result.add(const Text('세트'));
          int index = 0;
          for (var set in lp.currentRecordSets) {
            index++;
            result.add(Text('$index'));
          }
        } else if (type == 'weight') {
          result.add(const Text('무게'));
          for (var set in lp.currentRecordSets) {
            result.add(Text('${set['weight']}kg'));
          }
        } else if (type == 'reps') {
          result.add(const Text('횟수'));
          for (var set in lp.currentRecordSets) {
            result.add(Text('${set['reps']}회'));
          }
        } else {
          result.add(const Text('시간'));
          for (var set in lp.currentRecordSets) {
            result.add(Text('${set['time']}초'));
          }
        }
        return result;
      }

      int getRecordsTotalVolume() {
        List<int> setVolume = [];
        for (var set in lp.currentRecordSets) {
          setVolume = [...setVolume, set['weight'] * set['reps']];
        }
        return setVolume.reduce((value, element) => value + element);
      }

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
                      ? GestureDetector(
                          onTap: () => lp.setIsBookmarked(
                            uid,
                            lp.workoutInfo.title,
                            lp.workoutInfo.isBookmarked,
                          ),
                          child: const Icon(
                            Icons.bookmark,
                            color: ColorsStronger.primaryBG,
                          ),
                        )
                      : GestureDetector(
                          onTap: () => lp.setIsBookmarked(
                            uid,
                            lp.workoutInfo.title,
                            lp.workoutInfo.isBookmarked,
                          ),
                          child: const Icon(
                            Icons.bookmark_border,
                            color: Colors.black,
                          ),
                        ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return WorkoutEditView(
                        title: lp.workoutInfo.title,
                        description: lp.workoutInfo.description,
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
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
              //TODO: 데이터 많을 시 대비하여 그래프 좌우 이동가능하도록 해야한다.
              //VOL/MAX 버튼,기능 추가해야 한다.
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <LineSeries<WorkoutsData, String>>[
                    LineSeries<WorkoutsData, String>(
                      // Bind data source
                      dataSource: <WorkoutsData>[
                        WorkoutsData('2021.10.20', 35),
                        WorkoutsData('2021.10.26', 28),
                        WorkoutsData('2021.11.10', 35),
                        // WorkoutsData('2021.11.20', 48),
                        // WorkoutsData('2021.11.25', 46),
                      ],
                      // dataSource: lp.getWorkoutsChartData(),
                      xValueMapper: (WorkoutsData workouts, _) =>
                          workouts.workoutDate,
                      yValueMapper: (WorkoutsData workouts, _) =>
                          workouts.volume,
                    )
                  ]),
              const Text(
                '이전기록',
                style: TextStyle(color: ColorsStronger.grey, fontSize: 18.0),
              ),
              const SizedBox(
                height: 10.0,
              ),
              //TODO: 날짜당 세트 전부 나오게해야함
              //왼쪽이나 오른쪽 화살표 누르면 이전이나 다음일자로 이동
              //(이전이나 다음 데이터 없으면 해당버튼 비활성화)
              lp.workoutInfoRecords.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      // height: 200,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.0, color: ColorsStronger.grey),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              lp.currentRecordIndex != 0
                                  ? GestureDetector(
                                      onTap: () {
                                        lp.setWorkoutRecord('prev');
                                      },
                                      child: const Icon(Icons.arrow_back_ios))
                                  : const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.transparent,
                                    ),
                              Text(
                                DateFormat('yyyy-MM-dd').format(lp
                                    .workoutInfoRecords[lp.currentRecordIndex]
                                        ['workoutDate']
                                    .toDate()),
                                style: const TextStyle(fontSize: 20.0),
                              ),
                              lp.currentRecordIndex <
                                      lp.workoutInfoRecords.length - 1
                                  ? GestureDetector(
                                      onTap: () {
                                        lp.setWorkoutRecord('next');
                                      },
                                      child:
                                          const Icon(Icons.arrow_forward_ios))
                                  : const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.transparent,
                                    ),
                            ],
                          ),
                          const Divider(
                            thickness: 1.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: getRecordSetsDatas('set'),
                              ),
                              Column(
                                children: getRecordSetsDatas('weight'),
                              ),
                              Column(
                                children: getRecordSetsDatas('reps'),
                              ),
                              Column(
                                children: getRecordSetsDatas('time'),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 1.0,
                          ),
                          Center(
                            child: Text(
                              '총 ${getRecordsTotalVolume()}kg',
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    });
  }
}
