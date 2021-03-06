import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/views/setting/category_edit_view.dart';
import 'package:stronger/views/setting/tool_edit_view.dart';
import 'package:stronger/widgets/common/common_card.dart';
import 'package:stronger/widgets/common/common_small_button.dart';
import 'package:stronger/widgets/settings/edit_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SettingView extends StatelessWidget {
  static const routeName = 'setting';
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (_, up, __) {
            final userModel = up.userModel;
            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                width: 70.0,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  // color: ColorsStronger.lightGrey,
                                  image: const DecorationImage(
                                      image:
                                          AssetImage('assets/auth/pony.jpeg'),
                                      fit: BoxFit.cover),
                                  border: Border.all(width: 1.0),
                                  borderRadius: BorderRadius.circular(60.0),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        userModel.name,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const Icon(Icons.edit_sharp)
                                    ],
                                  ),
                                  Text(
                                    userModel.emailAddress,
                                    style: const TextStyle(
                                      color: ColorsStronger.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          CommonSmallButton(
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                              },
                              buttonText: '????????????'),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: height * 0.05, bottom: height * 0.02),
                        child: const Text(
                          '??????',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      EditButton(
                        label: '?????? ??????',
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(ToolEditView.routeName);
                        },
                      ),
                      const SizedBox(height: 10),
                      EditButton(
                        label: '???????????? ??????',
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(CategoryEditView.routeName);
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: height * 0.05, bottom: height * 0.02),
                        child: const Text(
                          '?????? ??????',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      CommonCard(
                        // onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('????????? ????????????'),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   width: double.infinity,
                      //   height: 180,
                      //   margin: EdgeInsets.symmetric(vertical: height * 0.03),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(width: 1),
                      //   ),
                      //   child: const Center(
                      //     child: Text('?????????'),
                      //   ),
                      // ),
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
                      Container(
                        padding: EdgeInsets.only(bottom: height * 0.02),
                        child: const Text(
                          '?????? ????????? ??????',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('????????? ????????? 10%'),
                              Text('??????????????? 8%'),
                              Text('????????? 5%'),
                            ],
                          ),
                          Container(
                            width: 150,
                            height: 130,
                            // margin:
                            //     EdgeInsets.symmetric(vertical: height * 0.03),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.transparent,
                              ),
                            ),
                            child: SfCircularChart(
                              series: <CircularSeries>[
                                RadialBarSeries<CirclularChartData, String>(
                                  dataSource: [
                                    CirclularChartData('????????? ?????????', 10),
                                    CirclularChartData('???????????????', 8),
                                    CirclularChartData('????????? ?????????', 5),
                                  ],
                                  maximumValue: 100,
                                  xValueMapper:
                                      (CirclularChartData data, index) =>
                                          data.workout,
                                  yValueMapper:
                                      (CirclularChartData data, index) =>
                                          data.frequency,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      // body: Center(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.of(context, rootNavigator: true)
      //               .pushNamed(ToolEditView.routeName);
      //         },
      //         child: const Text(
      //           'tool setting',
      //           style: TextStyle(
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.of(context, rootNavigator: true)
      //               .pushNamed(CategoryEditView.routeName);
      //         },
      //         child: const Text(
      //           'category setting',
      //           style: TextStyle(
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () {
      //           FirebaseAuth.instance.signOut();
      //         },
      //         child: const Text(
      //           'logouTTT',
      //           style: TextStyle(
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
