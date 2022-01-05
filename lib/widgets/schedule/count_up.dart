import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/count_up_provider.dart';
import 'package:stronger/utils/define.dart';

class CountUp extends StatefulWidget {
  const CountUp({Key? key}) : super(key: key);

  @override
  _CountUpState createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            const Text('스탑워치'),
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25),
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
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: cp.stopEnable ? cp.stopTimer : null,
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            cp.stopEnable ? Colors.black : ColorsStronger.grey,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.stop,
                        size: 32,
                        color: Colors.white,
                      )),
                )
                // (cp.startEnable)
                //     ? ElevatedButton(
                //         onPressed: cp.startTimer,
                //         child: Icon(Icons.play_arrow),
                //       )
                //     : ElevatedButton(
                //         onPressed: cp.pauseTimer,
                //         child: Icon(Icons.pause),
                //       ),
                // (cp.stopEnable)
                //     ? ElevatedButton(
                //         onPressed: cp.stopTimer,
                //         child: Icon(Icons.stop),
                //       )
                //     : const ElevatedButton(
                //         onPressed: null,
                //         child: Icon(Icons.stop),
                //       ),
              ],
            )
          ],
        );
      },
    );
  }
}
