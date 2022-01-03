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

      //workouts에서 tool 제거
      final workoutDocs = userDocs.collection('workouts');

      final filteredTools =
          await workoutDocs.where('tools', arrayContains: removeTool).get();
      List<dynamic> workoutTools = [];
      for (var doc in filteredTools.docs) {
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

  Future<void> removeCategory(
      String uid, List<String> categories, String removeCategory) async {
    try {
      final userDocs = firestore.collection('users').doc(uid);
      //user정보에 category 삭제
      await userDocs.update({'categories': categories});

      //workouts에서 category 제거
      final workoutsDocs = userDocs.collection('workouts');
      final filteredCategory =
          await workoutsDocs.where('category', isEqualTo: removeCategory).get();

      for (var doc in filteredCategory.docs) {
        userDocs.collection('workouts').doc(doc.id).update({
          'category': '',
        });
      }
    } catch (e) {
      throw Exception('removeCategory : $e');
    }
  }

  Future<void> addCategory(String uid, List<String> categories) async {
    try {
      final userDocs = firestore.collection('users').doc(uid);
      userDocs.update({'categories': categories});
    } catch (e) {
      throw Exception('addCategory : $e');
    }
  }
}
