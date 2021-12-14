import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:stronger/utils/define.dart';

const shadowColor = Color(0xFFD9D9D9);

class LibraryView extends StatelessWidget {
  static const routeName = 'library';
  const LibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final libraryProvider = context.read<LibraryProvider>();
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
              const SizedBox(height: 20),

              /// search bar
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: width * 0.9,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: const TextField(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 15, right: 15, top: 2),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: '운동 이름',
                      hintStyle: TextStyle(
                        color: ColorsStronger.lightGrey,
                      ),
                    ),
                  ),
                ),
              ),
              Consumer<LibraryProvider>(
                builder: (_, provider, __) {
                  final categories = provider.categories;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    height: 35,
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
                                  isSelected: provider
                                      .isSelectedCategory(categories[index]),
                                  onSelect: () => provider
                                      .onCategorySelect(categories[index]),
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
        margin: const EdgeInsets.only(right: 8),
        width: 80,
        height: 35,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: isSelected ? ColorsStronger.primaryBG : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: isSelected
              ? null
              : Border.all(
                  color: ColorsStronger.lightGrey,
                  width: 1,
                ),
        ),
      ),
    );
  }
}
