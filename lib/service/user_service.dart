import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/user_model.dart';

class UserService {
  final firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserModel(String uid) async {
    try {
      final snapshot = await firestore.collection('users').doc(uid).get();
      // print(snapshot);
      final userModel = UserModel.fromDocument(snapshot);
      // print(userModel);
      return userModel;
    } catch (e) {
      throw Exception('getUserModel: $e');
    }
  }
}
