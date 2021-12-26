import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/auth_provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/library/workout_card.dart';

class LibraryView extends StatelessWidget {
  static const routeName = 'library';
  const LibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
              Consumer<LibraryProvider>(builder: (_, lp, __) {
                return Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  height: height * 0.7,
                  width: width * 0.9,
                  child: CustomScrollView(
                    slivers: [
                      Consumer<LibraryProvider>(
                        builder: (_, lp, __) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return lp.selectedCategories.isNotEmpty
                                    ? (WorkoutCard(
                                        workoutName: lp
                                            .selectedWorkoutModels[index].title,
                                        bodyPart: lp
                                            .selectedWorkoutModels[index]
                                            .category,
                                        isBookmarked: lp
                                            .selectedWorkoutModels[index]
                                            .isBookmarked,
                                        onTap: () {
                                          print('1');
                                        },
                                      ))
                                    : (WorkoutCard(
                                        workoutName:
                                            lp.workoutModels[index].title,
                                        bodyPart:
                                            lp.workoutModels[index].category,
                                        isBookmarked: lp
                                            .workoutModels[index].isBookmarked,
                                        onTap: () {
                                          print('1');
                                        },
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
                );
              }),

              // WorkoutCard(
              //   workoutName: '벤치프레스',
              //   bodyPart: '가슴',
              //   isBookmarked: false,
              //   onTap: () {
              //     print('1');
              //   },
              // ),
              // WorkoutCard(
              //   workoutName: '프랭크',
              //   bodyPart: '전신',
              //   isBookmarked: true,
              //   onTap: () => print('2'),
              // ),
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
