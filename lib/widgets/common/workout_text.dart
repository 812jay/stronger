import 'package:flutter/material.dart';
import 'package:stronger/utils/define.dart';

class WorkoutText extends StatelessWidget {
  const WorkoutText({
    required this.workoutName,
    required this.bodyPart,
    this.textColor = Colors.black,
    Key? key,
  }) : super(key: key);

  final String workoutName;
  final String bodyPart;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          workoutName,
          style: TextStyle(
            fontSize: 17,
            color: textColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          bodyPart,
          style: const TextStyle(
            fontSize: 15,
            color: ColorsStronger.grey,
          ),
        ),
      ],
    );
  }
}
