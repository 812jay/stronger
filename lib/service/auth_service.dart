import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/user_model.dart';

class AuthService {
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

  Future<UserModel> getUserInformation(uid) async {
    // try {
    //   final snapshot = await firestore.collection('users').doc(uid).get();
    //   // print(snapshot);
    //   final userModel = UserModel.fromDocument(snapshot);
    //   print(userModel);
    // } catch (e) {
    //   UnimplementedError();
    // }
    final snapshot = await firestore.collection('users').doc(uid).get();
    // print(snapshot);
    final userModel = UserModel.fromDocument(snapshot);
    // print(userModel);
    return userModel;
  }
}
