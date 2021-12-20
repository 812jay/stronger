import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/workout_model.dart';

class WorkoutService {
  final firestore = FirebaseFirestore.instance;

  // Future<WorkoutModel> getWorkoutModel(String uid) async {
  Future<WorkoutModel?> getWorkoutModel(String uid, String workout) async {
    try {
      WorkoutModel workoutModel = const WorkoutModel(
        title: '',
        description: '',
        category: '',
        tools: [],
        isBookmarked: false,
        workoutRecords: [],
      );

      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .get()
          .then((querySnapshot) {
        // querySnapshot.docs.forEach(
        //   (doc) {
        //     if (workout == doc.get('title')) {
        //       workoutModel = WorkoutModel.fromDocument(doc);
        //     }
        //   },
        // );
        for (var doc in querySnapshot.docs) {
          if (workout == doc.get('title')) {
            workoutModel = WorkoutModel.fromDocument(doc);
          }
        }
      });

      return workoutModel;
    } catch (e) {
      throw Exception('getWorkoutModel: $e');
    }
  }
}
