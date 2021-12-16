import 'package:flutter/material.dart';
import 'package:stronger/utils/define.dart';

class CommonSmallButton extends StatelessWidget {
  const CommonSmallButton({
    required this.onTap,
    required this.buttonText,
    this.buttonColor = ColorsStronger.primaryBG,
    this.widthRatio = 0.22,
    this.height = 30,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final String buttonText;
  final Color buttonColor;
  final double widthRatio;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * widthRatio,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
