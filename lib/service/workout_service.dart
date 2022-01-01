import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/workout_model.dart';

class WorkoutService {
  final firestore = FirebaseFirestore.instance;

  // Future<WorkoutModel> getWorkoutModel(String uid) async {
  Future<List<WorkoutModel>> getWorkouts(String uid) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .get();

      final List<WorkoutModel> workouts = snapshot.docs.map((doc) {
        return WorkoutModel.fromDocument(doc);
      }).toList();

      return workouts;
    } catch (e) {
      throw UnimplementedError('$e');
    }
  }

  Future<List<WorkoutModel>> getWorkoutsByCategories(
      String uid, List<String> categories) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('category', whereIn: categories)
          .get();

      final List<WorkoutModel> workoutsByCategories =
          snapshot.docs.map((doc) => WorkoutModel.fromDocument(doc)).toList();
      return workoutsByCategories;
    } catch (e) {
      throw Exception('getWorkoutsByCategories: $e');
    }
  }

  Future<WorkoutModel> getWorkoutInfo(String uid, String title) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('title', isEqualTo: title)
          .get();
      final WorkoutModel workoutInfo =
          WorkoutModel.fromDocument(snapshot.docs.single);
      return workoutInfo;
    } catch (e) {
      throw Exception('getWorkoutInfo : $e');
    }
  }

  Future<void> editWorkoutInfo(
    String uid,
    String prevTitle,
    String title,
    String category,
    List<String> tools,
    String description,
  ) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('title', isEqualTo: prevTitle)
          .get();

      final workoutId = snapshot.docs[0].id;

      firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .update(
        {
          'title': title,
          'category': category,
          'tools': tools,
          'description': description,
        },
      );
    } catch (e) {
      print('error : $e');
    }
  }

  Future<void> editWorkoutBookmark(
    String uid,
    String title,
    bool isBookmarked,
  ) async {
    try {
      if (isBookmarked) {
        isBookmarked = false;
      } else {
        isBookmarked = true;
      }
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('title', isEqualTo: title)
          .get();

      final workoutId = snapshot.docs[0].id;

      firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .update(
        {
          'isBookmarked': isBookmarked,
        },
      );
    } catch (e) {
      print('error : $e');
    }
  }
}
