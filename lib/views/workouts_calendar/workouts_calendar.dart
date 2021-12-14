import 'package:flutter/material.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_button.dart';
import 'package:stronger/widgets/common/common_card.dart';
import 'package:stronger/widgets/common/common_small_button.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutsCalendar extends StatelessWidget {
  static const routeName = 'calendar';
  const WorkoutsCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    CalendarFormat format = CalendarFormat.month;
    DateTime selectedDay = DateTime.now();
    DateTime focusedDate = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime(1980),
              lastDay: DateTime(2060),
              focusedDay: selectedDay,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '2021.12.14',
                        style: TextStyle(fontSize: 18),
                      ),
                      // SizedBox(
                      //   height: 30,
                      //   child: ElevatedButton(
                      //     onPressed: () {},
                      //     style: ElevatedButton.styleFrom(
                      //       primary: ColorsStronger.primaryBG,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(20),
                      //       ),
                      //     ),
                      //     child: const Text('편집하기'),
                      //   ),
                      // ),//편집하기 버튼
                      CommonSmallButton(onTap: () {}, buttonText: '편집하기'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                              color: ColorsStronger.lightGrey,
                            ),
                            borderRadius: BorderRadius.circular(13.0)),
                        child: Text(
                          'VOL',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                              color: ColorsStronger.lightGrey,
                            ),
                            borderRadius: BorderRadius.circular(13.0)),
                        child: Text(
                          'MAX',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ), // Vol, Max
                  SizedBox(
                    height: 15,
                  ),
                  CommonCard(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '스쿼트',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '하체',
                                    style: TextStyle(
                                      color: ColorsStronger.lightGrey,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.check_circle_outline),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('50kg x 20회'), Text('총합 1000kg')],
                          ),
                        ],
                      ),
                    ),
                    height: 62,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
