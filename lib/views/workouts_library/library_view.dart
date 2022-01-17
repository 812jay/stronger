import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/models/workout_model.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/calender_provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/views/workouts_library/workout_add_view.dart';
import 'package:stronger/widgets/common/common_button.dart';
import 'package:stronger/widgets/common/common_card.dart';
import 'package:stronger/widgets/common/workout_text.dart';

class LibraryView extends StatelessWidget {
  static const routeName = 'schedule/add/workouts';
  const LibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final lp = context.read<LibraryProvider>();
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),

              /// search bar
              //TODO: 운동이름 검색어 입력시 해당단어 포함되는 운동들 불러오도록 해야한다.
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: ColorsStronger.shadowColor,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: const TextField(
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 15.0, right: 15.0, top: 2.0),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: '운동 이름',
                      hintStyle: TextStyle(
                        color: ColorsStronger.grey,
                      ),
                    ),
                  ),
                ),
              ),

              /// categories
              Consumer3<UserProvider, LibraryProvider, AuthProvider>(
                builder: (_, up, lp, ap, __) {
                  final categories = up.userModel.categories;
                  return Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    height: 35.0,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Padding(
                                padding: index == 0
                                    ? EdgeInsets.only(left: width * 0.05)
                                    : EdgeInsets.zero,
                                child: _CategoryChip(
                                  text: categories[index],
                                  isSelected:
                                      lp.isSelectedCategory(categories[index]),
                                  onSelect: () =>
                                      lp.onCategorySelect(categories[index]),
                                ),
                              );
                            },
                            childCount: categories.length,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
                height: height * 0.6,
                width: width * 0.9,
                child: CustomScrollView(
                  slivers: [
                    Consumer3<AuthProvider, LibraryProvider, ScheduleProvider>(
                      builder: (_, ap, lp, sp, __) {
                        final bool isSelectedCategoriesEmpty =
                            lp.selectedCategories.isEmpty;
                        final List<WorkoutModel> workouts =
                            isSelectedCategoriesEmpty
                                ? lp.workoutModels
                                : lp.filteredWorkoutModels;

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  lp.setWorkoutInfo(
                                      ap.uid!, lp.workoutModels[index].title);

                                  Navigator.of(context, rootNavigator: true)
                                      .pushNamed('workout/info');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: CommonCard(
                                    cardColor: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        WorkoutText(
                                          textColor: Colors.black,
                                          workoutName: workouts[index].title,
                                          bodyPart: workouts[index].category,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: isSelectedCategoriesEmpty
                                ? lp.workoutModels.length
                                : lp.filteredWorkoutModels.length,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              CommonButton(
                onTap: () {
                  lp.clearAddWorkoutDatas();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return WorkoutAddView();
                      });
                },
                buttonText: '운동 추가',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.text,
    required this.isSelected,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  final String text;
  final bool isSelected;
  final void Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        width: 80.0,
        height: 35.0,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 14.0,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: isSelected ? ColorsStronger.primaryBG : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: isSelected
              ? null
              : Border.all(
                  color: ColorsStronger.grey.withOpacity(0.5),
                  width: 1.0,
                ),
        ),
      ),
    );
  }
}
