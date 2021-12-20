import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/workout_model.dart';

class WorkoutService {
  final firestore = FirebaseFirestore.instance;

  // Future<WorkoutModel> getWorkoutModel(String uid) async {
  Future<WorkoutModel?> getWorkoutModel(String uid, String workout) async {
    // print('service workout : $workout');
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
          // .doc()
          .get();
      for (var doc in snapshot.docs) {
        // workouts.add(doc.data());
        String title = doc.get('title');
        // print(workout);
        // print(doc.get('title'));
        if (title == workout) {
          workoutModel = WorkoutModel.fromDocument(doc);
        }
        return workoutModel;
      }
      // print(workouts);
    } catch (e) {
      throw Exception('getWorkoutModel: $e');
    }
  }
}
