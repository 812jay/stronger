import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/views/setting/category_edit_view.dart';
import 'package:stronger/views/setting/tool_edit_view.dart';
import 'package:stronger/widgets/common/common_card.dart';
import 'package:stronger/widgets/common/common_small_button.dart';
import 'package:stronger/widgets/settings/edit_button.dart';

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
                              const CircleAvatar(
                                maxRadius: 30,
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
                                      color: ColorsStronger.lightGrey,
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
                              buttonText: '로그아웃'),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: height * 0.05, bottom: height * 0.02),
                        child: const Text(
                          '설정',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      EditButton(
                        label: '도구 설정',
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(ToolEditView.routeName);
                        },
                      ),
                      const SizedBox(height: 10),
                      EditButton(
                        label: '카테고리 설정',
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(CategoryEditView.routeName);
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: height * 0.05, bottom: height * 0.02),
                        child: const Text(
                          '운동 기록',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      CommonCard(
                        // onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('선택된 운동이름'),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 180,
                        margin: EdgeInsets.symmetric(vertical: height * 0.03),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                        ),
                        child: const Center(
                          child: Text('그래프'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: height * 0.02),
                        child: const Text(
                          '많이 수행한 운동',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('프론트 스쿼트 10%'),
                              Text('벤치프레스 8%'),
                              Text('푸시업 5%'),
                            ],
                          ),
                          Container(
                            width: 150,
                            height: 130,
                            margin:
                                EdgeInsets.symmetric(vertical: height * 0.03),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: const Center(
                              child: Text('그래프'),
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
