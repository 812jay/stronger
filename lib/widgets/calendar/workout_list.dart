import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_card.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleProvider>(
      builder: (context, sp, _) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final setsData = sp.dayWorkoutSets[index][0];
              return CommonCard(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //TODO: 0번째 index가 아닌 체크된 항목중 가장높은 VOL이나 MAX따라 세트의 데이터가 나와야 한다.
                      //체크된 세트 없을 시 isChecked, weight, reps, time, 총합등은 0
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                sp.dayWorkouts[index].title,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                sp.dayWorkouts[index].category,
                                style: const TextStyle(
                                  color: ColorsStronger.grey,
                                ),
                              ),
                            ],
                          ),
                          setsData['isChecked']
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: ColorsStronger.lightGreen,
                                )
                              : const Icon(Icons.check_circle_outline),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              '${setsData['weight']}kg x ${setsData['reps']}회'),
                          Text('총합 ${setsData['weight'] * setsData['reps']}kg'),
                        ],
                      ),
                    ],
                  ),
                ),
                height: 80,
              );
            },
            childCount: sp.dayWorkouts.length,
          ),
        );
      },
    );
  }
}
