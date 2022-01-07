import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/schedule_model.dart';
import 'package:stronger/utils/calculator.dart';

class ScheduleService {
  final firestore = FirebaseFirestore.instance;
  final calculator = Calculator();

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
}
