import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stronger/views/auth/auth_view.dart';
import 'package:stronger/views/home.dart';

class Stronger extends StatelessWidget {
  static const routeName = 'stronger';
  const Stronger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Home();
        } else {
          return const AuthView();
        }
      },
    );
  }
}
