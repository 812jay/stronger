import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stronger/models/user_model.dart';
import 'package:stronger/service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final authService = AuthService();
  final firebaseAuth = FirebaseAuth.instance;

  String? get uid => firebaseAuth.currentUser?.uid;

  Future<void> signIn(String email, String password) async {
    print('email: $email, password: $password');
    try {
      authService.signIn(email, password);
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
    try {
      UserCredential userCredential = await authService.signUp(email, password);

      if (userCredential.user != null) {
        final user = userCredential.user!;

        final String uid = user.uid;
        final String email = user.email!;

        final userModel = UserModel(
          emailAddress: email,
          name: name,
          uid: uid,
          profileImage: '',
          categories: const ['가슴', '코어', '등', '어깨', '팔', '하체'],
          tools: const ['바벨', '덤벨', '케틀벨', '맨몸', '기타'],
        );

        await authService.registerUser(userModel);
      }
      await FirebaseAuth.instance.signOut();
      log('success signup');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log('$e');
    }
  }
}
