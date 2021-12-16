import 'package:flutter/material.dart';
import 'package:stronger/utils/define.dart';
import 'package:stronger/widgets/common/common_card.dart';
import 'package:stronger/widgets/common/workout_text.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    required this.workoutName,
    required this.bodyPart,
    required this.isBookmarked,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String workoutName;
  final String bodyPart;
  final bool isBookmarked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: CommonCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WorkoutText(workoutName: workoutName, bodyPart: bodyPart),
              Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                size: 20,
                color: isBookmarked ? ColorsStronger.primaryBG : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
