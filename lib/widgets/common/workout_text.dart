import 'package:flutter/material.dart';
import 'package:stronger/utils/define.dart';

class WorkoutText extends StatelessWidget {
  const WorkoutText({
    required this.workoutName,
    required this.bodyPart,
    Key? key,
  }) : super(key: key);

  final String workoutName;
  final String bodyPart;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          workoutName,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          bodyPart,
          style: const TextStyle(
            fontSize: 15,
            color: ColorsStronger.lightGrey,
          ),
        ),
      ],
    );
  }
}
