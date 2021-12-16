import 'package:flutter/material.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_card.dart';
import 'package:stronger/widgets/common/workout_text.dart';

class WorkoutCardForAdd extends StatelessWidget {
  const WorkoutCardForAdd({
    required this.workoutName,
    required this.bodyPart,
    required this.isBookmarked,
    required this.onTap,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  final String workoutName;
  final String bodyPart;
  final bool isBookmarked;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: CommonCard(
          onTap: () {},
          cardColor: isSelected
              ? ColorsStronger.primaryBG.withAlpha(50)
              : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WorkoutText(workoutName: workoutName, bodyPart: bodyPart),
              Row(
                children: [
                  Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                    color:
                        isBookmarked ? ColorsStronger.primaryBG : Colors.black,
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.info_rounded,
                    size: 20,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
