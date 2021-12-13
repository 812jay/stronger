import 'package:flutter/material.dart';

class LibraryView extends StatelessWidget {
  static const routeName = 'library';
  const LibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('library'),
      ),
    );
  }
}
