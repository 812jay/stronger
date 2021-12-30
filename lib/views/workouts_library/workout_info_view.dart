import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_chip.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WorkoutInfoView extends StatelessWidget {
  static const routeName = 'workout/info';
  const WorkoutInfoView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<LibraryProvider>(builder: (_, lp, __) {
      final workoutInfo = lp.workoutInfo;

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
            result.add(Text(set['weight'].toString()));
          }
        } else if (type == 'reps') {
          result.add(const Text('횟수'));
          for (var set in lp.currentRecordSets) {
            result.add(Text(set['reps'].toString()));
          }
        } else {
          result.add(const Text('시간'));
          for (var set in lp.currentRecordSets) {
            result.add(Text(set['time'].toString()));
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
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          width: width * 0.9,
                          height: height * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Icon(Icons.close),
                                  ),
                                  const Text('운동편집'),
                                  const Icon(
                                    Icons.close,
                                    color: Colors.transparent,
                                  ),
                                ],
                              ), // appbar
                              TextFormField(),
                              const Text('카테고리'),
                              Consumer2<UserProvider, AuthProvider>(
                                builder: (_, up, ap, __) {
                                  final categories = up.userModel.categories;
                                  return Container(
                                    margin: const EdgeInsets.only(top: 15.0),
                                    height: 35.0,
                                    child: CustomScrollView(
                                      scrollDirection: Axis.horizontal,
                                      slivers: [
                                        SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                              return Padding(
                                                padding: index == 0
                                                    ? EdgeInsets.only(
                                                        left: width * 0.05)
                                                    : EdgeInsets.zero,
                                                child: CommonChip(
                                                    text: categories[index],
                                                    isSelected:
                                                        lp.isSelectedCategory(
                                                            categories[index]),
                                                    onSelect: () {
                                                      lp.onCategorySelect(
                                                          categories[index]);
                                                      lp.setWorkoutsByCategories(
                                                          ap.uid!);
                                                    }),
                                              );
                                            },
                                            childCount: categories.length,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
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
                              // getWorkoutDate(lp.workoutInfoDates),
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
                              '${getRecordsTotalVolume()}kg',
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
