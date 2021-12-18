import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:stronger/models/workout_model.dart';

class WorkoutService {
  final firestore = FirebaseFirestore.instance;

  // Future<WorkoutModel> getWorkoutModel(String uid) async {
  Future<WorkoutModel> getWorkoutModel(String uid, String workout) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workout)
          .get();
      final workoutsData = WorkoutModel.fromDocument(snapshot);
      return workoutsData;
    } catch (e) {
      throw Exception('getWorkoutModel: $e');
    }
  }
}
