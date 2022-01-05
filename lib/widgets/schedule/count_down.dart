import 'package:flutter/material.dart';

class CountDown extends StatefulWidget {
  const CountDown({Key? key}) : super(key: key);

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
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
    // return Consumer<CountProvider>(
    //   builder: (_, cp, __) {
    //     return Column(
    //       children: [
    //         const Text('타이머'),
    //         Text(
    //           '${parsedTime(cp.hour)} : ${parsedTime(cp.minute)} : ${parsedTime(cp.seconds)}',
    //           style: const TextStyle(
    //             fontSize: 32,
    //           ),
    //         ),
    //         Row(
    //           children: [
    //             GestureDetector(
    //               onTap: cp.startEnable ? cp.startTimer : cp.pauseTimer,
    //               child: Container(
    //                 padding: const EdgeInsets.all(10),
    //                 decoration: BoxDecoration(
    //                   color: Colors.black,
    //                   borderRadius: BorderRadius.circular(25),
    //                 ),
    //                 child: cp.startEnable
    //                     ? const Icon(
    //                         Icons.play_arrow,
    //                         size: 32,
    //                         color: Colors.white,
    //                       )
    //                     : const Icon(
    //                         Icons.pause,
    //                         size: 32,
    //                         color: Colors.white,
    //                       ),
    //               ),
    //             ),
    //             const SizedBox(width: 20),
    //             GestureDetector(
    //               onTap: cp.stopEnable ? cp.stopTimer : null,
    //               child: Container(
    //                   padding: const EdgeInsets.all(10),
    //                   decoration: BoxDecoration(
    //                     color:
    //                         cp.stopEnable ? Colors.black : ColorsStronger.grey,
    //                     borderRadius: BorderRadius.circular(25),
    //                   ),
    //                   child: const Icon(
    //                     Icons.stop,
    //                     size: 32,
    //                     color: Colors.white,
    //                   )),
    //             )
    //           ],
    //         )
    //       ],
    //     );
    //   },
    // );

    return Column(
      children: [
        const Text('타이머'),
        const Text(
          '00:00:00',
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.stop,
                size: 32,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
