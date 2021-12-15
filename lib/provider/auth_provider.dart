import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stronger/models/user_model.dart';
import 'package:stronger/service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final authService = AuthService();
  Future<void> signIn(String email, String password) async {
    print('email: $email, password: $password');
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('success');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      print(e.code);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    print('signup email: $email, password: $password');
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // if (userCredential.user != null) {
      //   final user = userCredential.user!;

      //   final String uid = user.uid;
      //   final String email = user.email!;

      //   final userModel = UserModel(
      //     emailAddress: email,
      //     name: name,
      //     uid: uid,
      //     profileImage: '',
      //     categories: const ['가슴', '코어', '등', '어깨', '팔', '하체'],
      //     tools: const ['바벨', '덤벨', '케틀벨', '맨몸', '기타'],
      //   );

      //   await authService.registerUser(userModel);
      // }

      print('success signup');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
