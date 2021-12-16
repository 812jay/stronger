import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stronger/models/user_model.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<void> registerUser(UserModel userModel) async {
    final String uid = userModel.uid;
    print('register started');
    try {
      await firestore.collection('users').doc(uid).set(userModel.toJson());
      print('register complete');
    } catch (e) {
      print('$e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log('$e');
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}
