import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleService {
  final firestore = FirebaseFirestore.instance;

  Map<String, dynamic> scheduleData = {};

  // Future<WorkoutModel> getWorkoutModel(String uid) async {
  Future<Map<String, dynamic>> getScheduleModel(Timestamp selectedDay) async {
    try {
      // final snapshot = await firestore.collection('users').doc(uid).get();
      // print(snapshot);
      // final workoutModel = WorkoutModel.fromDocument(snapshot);
      // print(userModel);

      // WorkoutModel workoutModel = const WorkoutModel(
      //   title: '',
      //   description: '',
      //   tools: [],
      //   types: [],
      //   isBookmarked: false,
      //   workoutRecords: [],
      // );

      // return workoutModel;
      scheduleData = {
        'scheduleDate': Timestamp.now(),
        'description': '오늘 강도 빡셌다',
        'workout_records': [
          {
            'title': '스쿼트',
            'workoutDate': Timestamp.now(),
            'sets': [
              {
                'weight': 100,
                'reps': 10,
                'time': const Duration(seconds: 240),
                'isChecked': true,
              },
              {
                'weight': 80,
                'reps': 20,
                'time': const Duration(seconds: 180),
                'isChecked': false,
              },
            ],
          },
          {
            'title': '벤치프레스',
            'workoutDate': Timestamp.now(),
            'sets': [
              {
                'weight': 70,
                'reps': 15,
                'time': const Duration(seconds: 60),
                'isChecked': true,
              },
              {
                'weight': 80,
                'reps': 10,
                'time': const Duration(seconds: 180),
                'isChecked': true,
              },
              {
                'weight': 80,
                'reps': 8,
                'time': const Duration(seconds: 190),
                'isChecked': false,
              },
            ],
          },
        ],
        'image_records': []
      };
      return scheduleData;
    } catch (e) {
      throw Exception('getscheduleModel: $e');
    }
  }
}
