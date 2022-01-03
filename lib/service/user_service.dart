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

  Future<void> removeTool(
      String uid, List<String> tools, String removeTool) async {
    try {
      final userDocs = firestore.collection('users').doc(uid);
      //user정보에 tool 삭제
      await userDocs.update({'tools': tools});

      //workouts에서 삭제한 tool 제거
      final workoutsContainedRomoveTools = await userDocs
          .collection('workouts')
          .where('tools', arrayContains: removeTool)
          .get();
      List<dynamic> workoutTools = [];
      for (var doc in workoutsContainedRomoveTools.docs) {
        workoutTools = doc['tools'];
        workoutTools.remove(removeTool);
        userDocs
            .collection('workouts')
            .doc(doc.id)
            .update({'tools': workoutTools});
      }
    } catch (e) {
      throw Exception('removeTool : $e');
    }
  }

  Future<void> addTool(String uid, List<String> tools) async {
    try {
      final userDocs = firestore.collection('users').doc(uid);
      userDocs.update({'tools': tools});
    } catch (e) {
      throw Exception('addTool : $e');
    }
  }
}
