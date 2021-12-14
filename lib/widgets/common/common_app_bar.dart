import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget with PreferredSizeWidget {
  const CommonAppBar({
    required this.title,
    this.rootNavigator = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final bool rootNavigator;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 21,
          color: Colors.black,
        ),
      ),
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: rootNavigator).pop();
        },
        child: const Padding(
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.chevron_left_sharp,
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
