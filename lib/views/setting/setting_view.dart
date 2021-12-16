import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stronger/models/user_model.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/views/setting/category_edit_view.dart';
import 'package:stronger/views/setting/tool_edit_view.dart';
import 'package:stronger/widgets/common/common_card.dart';
import 'package:stronger/widgets/common/common_small_button.dart';

class SettingView extends StatelessWidget {
  static const routeName = 'setting';
  SettingView({Key? key}) : super(key: key);
  late AuthProvider _authProvider;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    print('getuser : ${_authProvider.getUser()}');
    _authProvider.getUser();
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (_, ap, __) {
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
                              CircleAvatar(
                                maxRadius: 30,
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '이름',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Icon(Icons.edit_sharp)
                                    ],
                                  ),
                                  Text(
                                    'my@mail.com',
                                    style: TextStyle(
                                        color: ColorsStronger.lightGrey),
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
                      // Row(
                      //   children: [
                      //     CommonSmallButton(
                      //       onTap: () {
                      //         Navigator.of(context, rootNavigator: true)
                      //             .pushNamed(ToolEditView.routeName);
                      //       },
                      //       buttonColor: ColorsStronger.lightGrey,
                      //       buttonText: '도구편집',
                      //     ),
                      //   ],
                      // ),
                      Container(
                        padding: EdgeInsets.only(
                            top: height * 0.05, bottom: height * 0.02),
                        child: Text(
                          '설정',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      CommonCard(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(ToolEditView.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '도구 설정',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ), // 도구 설정
                      SizedBox(height: 10),
                      CommonCard(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(CategoryEditView.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '카테고리 설정',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ), // 카테고리 설정
                      Container(
                        padding: EdgeInsets.only(
                            top: height * 0.05, bottom: height * 0.02),
                        child: Text(
                          '운동 기록',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      CommonCard(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                        child: Center(
                          child: Text('그래프'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: height * 0.02),
                        child: Text(
                          '많이 수행한 운동',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                            child: Center(
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
