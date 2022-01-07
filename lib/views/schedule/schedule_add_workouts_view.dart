import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/calender_provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/provider/schedule_provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_button.dart';
import 'package:stronger/widgets/common/common_card.dart';
import 'package:stronger/widgets/common/workout_text.dart';

class ScheduleAddWorkoutsView extends StatelessWidget {
  static const routeName = 'schedule/add/workouts';
  const ScheduleAddWorkoutsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          '오늘의 운동',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
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
                                    isSelected: lp
                                        .isSelectedCategory(categories[index]),
                                    onSelect: () {
                                      lp.onCategorySelect(categories[index]);
                                      lp.setWorkoutsByCategories(ap.uid!);
                                    }),
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
                height: height * 0.55,
                width: width * 0.9,
                child: CustomScrollView(
                  slivers: [
                    Consumer3<AuthProvider, LibraryProvider, ScheduleProvider>(
                      builder: (_, ap, lp, sp, __) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return lp.selectedCategories.isNotEmpty
                                  ? (GestureDetector(
                                      onTap: () {
                                        sp.setAddWorkouts(
                                          lp.selectedWorkoutModels[index].title,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: CommonCard(
                                          cardColor: sp.selectedWorkouts
                                                  .contains(lp
                                                      .workoutModels[index]
                                                      .title)
                                              ? ColorsStronger.primaryBG
                                              : Colors.white,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              WorkoutText(
                                                textColor: sp.selectedWorkouts
                                                        .contains(lp
                                                            .workoutModels[
                                                                index]
                                                            .title)
                                                    ? Colors.white
                                                    : Colors.black,
                                                workoutName: lp
                                                    .selectedWorkoutModels[
                                                        index]
                                                    .title,
                                                bodyPart: lp
                                                    .selectedWorkoutModels[
                                                        index]
                                                    .category,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                                  : (GestureDetector(
                                      onTap: () {
                                        sp.setAddWorkouts(
                                          lp.workoutModels[index].title,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: CommonCard(
                                          cardColor: sp.selectedWorkouts
                                                  .contains(lp
                                                      .workoutModels[index]
                                                      .title)
                                              ? ColorsStronger.primaryBG
                                              : Colors.white,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              WorkoutText(
                                                textColor: sp.selectedWorkouts
                                                        .contains(lp
                                                            .workoutModels[
                                                                index]
                                                            .title)
                                                    ? Colors.white
                                                    : Colors.black,
                                                workoutName: lp
                                                    .workoutModels[index].title,
                                                bodyPart: lp
                                                    .workoutModels[index]
                                                    .category,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                            },
                            childCount: lp.selectedCategories.isNotEmpty
                                ? lp.selectedWorkoutModels.length
                                : lp.workoutModels.length,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Consumer<ScheduleProvider>(builder: (_, sp, __) {
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Row(
                                children: [
                                  Text(
                                    sp.selectedWorkouts[index],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      sp.setAddWorkouts(
                                        sp.selectedWorkouts[index],
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ],
                              );
                            },
                            childCount: sp.selectedWorkouts.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Consumer2<ScheduleProvider, CalendarProvider>(
                builder: (_, sp, cp, __) {
                  return CommonButton(
                    onTap: () {
                      sp.setTodayWorkouts(Timestamp.fromDate(cp.selectedDay));
                      Navigator.pop(context);
                    },
                    buttonText: '운동 추가하기',
                  );
                },
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
