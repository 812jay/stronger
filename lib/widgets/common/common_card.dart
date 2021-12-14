import 'package:flutter/material.dart';
import 'package:stronger/utils/define.dart';

class CommonCard extends StatelessWidget {
  const CommonCard({
    required this.child,
    this.cardColor = Colors.white,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.9,
      height: 50,
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
