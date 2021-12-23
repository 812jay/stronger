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
              return CommonCard(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          const Icon(Icons.check_circle_outline),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
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
            childCount: sp.dayWorkouts.length,
          ),
        );
      },
    );
  }
}
