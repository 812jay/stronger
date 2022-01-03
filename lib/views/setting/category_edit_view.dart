import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_app_bar.dart';
import 'package:stronger/widgets/common/common_button.dart';

class CategoryEditView extends StatelessWidget {
  static const routeName = 'category/edit';
  const CategoryEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: '카테고리 설정',
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
                  '등록된 카테고리',
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
                  final List<String> categories = up.userModel.categories;
                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final String category = categories[index];
                            return Slidable(
                              key: ValueKey(category),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.14,
                                children: [
                                  // SlidableAction(
                                  //   onPressed: (context) {
                                  //     print('edit');
                                  //   },
                                  //   // TODO: change color
                                  //   backgroundColor: ColorsStronger.primaryBG,
                                  //   // TODO: change icon
                                  //   icon: Icons.edit,
                                  // ),
                                  SlidableAction(
                                    onPressed: (context) {
                                      up.removeCategoryData(
                                          up.userModel.uid, category);
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
                                        category,
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
                          childCount: categories.length,
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
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const CategoryAddView();
                      },
                    );
                  },
                  buttonText: '카테고리 추가하기',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryAddView extends StatelessWidget {
  const CategoryAddView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _categoryController = TextEditingController();
    double height = MediaQuery.of(context).size.height;

    return Consumer<UserProvider>(builder: (_, up, __) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close),
            ),
            const Text('카테고리 추가'),
            const Icon(
              Icons.close,
              color: Colors.transparent,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _categoryController,
            ),
            SizedBox(
              height: height * 0.05,
            ),
            CommonButton(
              onTap: () {
                up.addCategoryData(up.userModel.uid, _categoryController.text);
                Navigator.pop(context);
              },
              buttonText: '추가하기',
            )
          ],
        ),
      );
    });
  }
}
