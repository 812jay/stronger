import 'package:flutter/material.dart';
import 'package:stronger/utils/define.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    required this.onTap,
    required this.buttonText,
    this.buttonColor = ColorsStronger.primaryBG,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;
  final String buttonText;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.9,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: ColorsStronger.primaryBG,
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
