import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/count_down_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_button.dart';

class CountDown extends StatelessWidget {
  const CountDown({Key? key}) : super(key: key);

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
    return Consumer<CountDownProvider>(
      builder: (_, cp, __) {
        return Column(
          children: [
            const Text('휴식시간'),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return selectTime(context);
                  },
                );
              },
              child: Text(
                '${parsedTime(cp.minute)}:${parsedTime(cp.seconds)}',
                style: const TextStyle(
                  fontSize: 32,
                ),
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
                    child: Icon(
                      cp.startEnable ? Icons.play_arrow : Icons.pause,
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
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget selectTime(BuildContext context) {
    return Consumer<CountDownProvider>(builder: (_, cp, __) {
      return AlertDialog(
        actions: [
          CommonButton(
            onTap: () {
              cp.setTime();
              cp.pauseTimer();
              Navigator.pop(context);
            },
            buttonText: '확인',
          )
        ],
        content: Row(
          children: [
            NumberPicker(
              minValue: 0,
              maxValue: 20,
              value: cp.selectedMinute,
              onChanged: (value) => cp.setMinute(value),
              // step: 10,
            ),
            const Text('분'),
            NumberPicker(
              minValue: 0,
              maxValue: 50,
              value: cp.selectedSeconds,
              onChanged: (value) => cp.setSeconds(value),
              step: 10,
            ),
            const Text('초'),
          ],
        ),
      );
    });
  }
}
