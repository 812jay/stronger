import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/calender_provider.dart';
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
              locale: 'ko-KR',
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
                      CommonSmallButton(onTap: () {}, buttonText: '편집하기'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<CalendarProvider>(
                    builder: (_, cp, __) {
                      final types = cp.allTypes;
                      final selectedType = cp.selectedType;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: types
                            .map(
                              (type) => GestureDetector(
                                onTap: () {
                                  cp.onTypeSelect(type);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                    vertical: 5.0,
                                  ),
                                  width: 70,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: type == selectedType
                                        ? ColorsStronger.primaryBG
                                        : ColorsStronger.lightGrey,
                                    borderRadius: type == 0
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          )
                                        : const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                  ),
                                  child: Center(
                                    child: type == 0
                                        ? Text(
                                            'VOL',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: type == selectedType
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          )
                                        : Text(
                                            'MAX',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: type == selectedType
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                    child: Container(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CommonCard(
                    // onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
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
