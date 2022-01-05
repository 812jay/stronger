import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/count_up_provider.dart';
import 'package:stronger/utils/define.dart';

class CountUp extends StatelessWidget {
  const CountUp({Key? key}) : super(key: key);

  String parsedTime(int number) {
    String result = '';
    if (number < 10) {
      result = '0$number';
    } else {
      result = '$number';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CountUpProvider>(
      builder: (_, cp, __) {
        return Column(
          children: [
            const Text('운동시간'),
            Text(
              '${parsedTime(cp.hour)}:${parsedTime(cp.minute)}:${parsedTime(cp.seconds)}',
              style: const TextStyle(
                fontSize: 32,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: cp.startEnable ? cp.startTimer : cp.pauseTimer,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: cp.startEnable
                        ? const Icon(
                            Icons.play_arrow,
                            size: 32,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.pause,
                            size: 32,
                            color: Colors.white,
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: cp.stopEnable ? cp.stopTimer : null,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: cp.stopEnable ? Colors.red : ColorsStronger.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.stop,
                        size: 32,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
