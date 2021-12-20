import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stronger/models/schedule_model.dart';

class ScheduleService {
  final firestore = FirebaseFirestore.instance;

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
        if (compareTimestampToDatetime(selectedDay, scheduleDate)) {
          scheduleModel = ScheduleModel.fromDocument(doc);
        }
      }

      return scheduleModel;
    } catch (e) {
      throw Exception('getscheduleModel: $e');
    }
  }

  bool compareTimestampToDatetime(Timestamp time1, Timestamp time2) {
    String formatTime1 = DateFormat('yyyy-MM-dd').format(time1.toDate());
    String formatTime2 = DateFormat('yyyy-MM-dd').format(time2.toDate());

    return formatTime1 == formatTime2;
  }
}
