import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/schedule_model.dart';
import 'package:stronger/models/workout_model.dart';
import 'package:stronger/service/workout_service.dart';
import 'package:stronger/utils/calculator.dart';

class ScheduleService {
  final firestore = FirebaseFirestore.instance;
  final calculator = Calculator();
  final workoutService = WorkoutService();

  Future<ScheduleModel?> getScheduleModel(
      String uid, Timestamp selectedDay) async {
    try {
      Timestamp scheduleDate;
      ScheduleModel scheduleModel = ScheduleModel(
        scheduleDate: Timestamp.now(),
        description: '',
        workouts: const [],
        imageRecords: const [],
      );
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('schedules')
          .get();
      for (var doc in snapshot.docs) {
        scheduleDate = doc.get('scheduleDate');
        if (calculator.compareTimestampToDatetime(selectedDay, scheduleDate)) {
          scheduleModel = ScheduleModel.fromDocument(doc);
        }
      }

      return scheduleModel;
    } catch (e) {
      throw Exception('getscheduleModel: $e');
    }
  }

  Future<void> addScheduleWorkouts(
      String uid, List<String> workouts, Timestamp scheduleDate) async {
    try {
      // print(workouts);
      List<String> resultWorkouts = [];
      String scheduleId = '';
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('schedules')
          .where('scheduleDate')
          .get();
      for (var element in snapshot.docs) {
        if (calculator.compareTimestampToDatetime(
            element['scheduleDate'], scheduleDate)) {
          scheduleId = element.id;
          resultWorkouts = [...element['workouts'], ...workouts];
        }
      }
      if (scheduleId.isNotEmpty) {
        print('aa');
        firestore
            .collection('users')
            .doc(uid)
            .collection('schedules')
            .doc(scheduleId)
            .update(
          {
            'workouts': resultWorkouts,
          },
        );
      } else {
        print('bb');
        firestore.collection('users').doc(uid).collection('schedules').add(
          {
            'description': '',
            'imageRecords': [],
            'scheduleDate': scheduleDate,
            'workouts': workouts
          },
        );
      }
    } catch (e) {
      throw Exception('addScheduleWorkouts: $e');
    }
  }
}
