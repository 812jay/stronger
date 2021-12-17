import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_app_bar.dart';
import 'package:stronger/widgets/common/common_button.dart';

class ToolEditView extends StatelessWidget {
  static const routeName = 'tool/edit';
  const ToolEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: '도구 설정',
        rootNavigator: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '등록된 도구',
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorsStronger.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<UserProvider>(
                builder: (_, up, __) {
                  final List<String> tools = up.userModel.tools;
                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final String tool = tools[index];
                            return Slidable(
                              key: ValueKey(tool),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.35,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      print('edit');
                                    },
                                    // TODO: change color
                                    backgroundColor: ColorsStronger.primaryBG,
                                    // TODO: change icon
                                    icon: Icons.edit,
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      print('remove');
                                    },
                                    // TODO: changed color
                                    backgroundColor: Colors.red,
                                    // TODO: change icon
                                    icon: Icons.delete_forever,
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: index == 0
                                        ? BorderSide(
                                            width: 1,
                                            color: ColorsStronger.grey
                                                .withOpacity(0.5),
                                          )
                                        : BorderSide.none,
                                    bottom: BorderSide(
                                      width: 1,
                                      color:
                                          ColorsStronger.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        tool,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: tools.length,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CommonButton(
                  onTap: () {},
                  buttonText: '도구 추가하기',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
