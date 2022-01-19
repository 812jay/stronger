import 'package:flutter/material.dart';
import 'package:stronger/utils/define.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    required this.onTap,
    required this.buttonText,
    this.buttonColor = ColorsStronger.primaryBG,
    this.textColor = Colors.white,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.9,
      height: 55,
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
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
