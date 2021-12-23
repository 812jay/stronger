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

  Future<WorkoutModel> getWorkoutModel(String uid, String workout) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('title', isEqualTo: workout)
          .get();

      if (snapshot.docs.isEmpty) {
        throw UnimplementedError('getWorkoutModel');
      }

      final DocumentSnapshot workoutData = snapshot.docs[0];
      final workoutModel = WorkoutModel.fromDocument(workoutData);
      return workoutModel;
    } catch (e) {
      throw Exception('getWorkoutModel: $e');
    }
  }
}
