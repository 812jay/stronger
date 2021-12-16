import 'package:flutter/material.dart';
import 'package:stronger/utils/define.dart';

class CommonCard extends StatelessWidget {
  const CommonCard({
    required this.child,
    this.cardColor = Colors.white,
    this.height = 50,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Color cardColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.9,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
      child: child,
    );
  }
}
