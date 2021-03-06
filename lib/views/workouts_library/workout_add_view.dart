import 'package:flutter/material.dart';
import 'package:stronger/provider/library_provider.dart';
import 'package:provider/provider.dart';
import 'package:stronger/provider/user_provider.dart';
import 'package:stronger/widgets/common/common_button.dart';
import 'package:stronger/widgets/common/common_chip.dart';

class WorkoutAddView extends StatefulWidget {
  const WorkoutAddView({Key? key}) : super(key: key);

  @override
  State<WorkoutAddView> createState() => _WorkoutAddViewState();
}

class _WorkoutAddViewState extends State<WorkoutAddView> {
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _titleController = TextEditingController(text: widget.title);
    // _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      content:
          Consumer2<LibraryProvider, UserProvider>(builder: (_, lp, up, __) {
        final categories = up.userModel.categories;
        final tools = up.userModel.tools;
        return Container(
          width: width * 0.9,
          height: height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                  const Text('운동편집'),
                  const Icon(
                    Icons.close,
                    color: Colors.transparent,
                  ),
                ],
              ), // appbar
              const SizedBox(
                height: 30,
              ),
              const Text('운동이름'),
              TextField(
                controller: _titleController,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('카테고리'),
              Container(
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
                            child: CommonChip(
                                text: categories[index],
                                isSelected:
                                    lp.isSelectedAddCategory(categories[index]),
                                onSelect: () {
                                  lp.onAddCategorySelect(categories[index]);
                                }),
                          );
                        },
                        childCount: categories.length,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('도구'),
              Container(
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
                            child: CommonChip(
                                text: tools[index],
                                isSelected: lp.isSelectedAddTool(tools[index]),
                                onSelect: () {
                                  lp.onAddToolSelect(tools[index]);
                                }),
                          );
                        },
                        childCount: tools.length,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('운동설명'),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                maxLines: 6,
              ),
              const SizedBox(
                height: 30,
              ),
              CommonButton(
                onTap: () {
                  lp.setAddLibrary(
                    up.userModel.uid,
                    _titleController.text,
                    lp.selectedAddCategory,
                    lp.selectedAddTools,
                    _descriptionController.text,
                  );
                  Navigator.pop(context);
                },
                buttonText: '완료',
              )
            ],
          ),
        );
      }),
    );
  }
}
