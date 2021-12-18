import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/schedule_model.dart';
import 'package:stronger/provider/easy_notifier.dart';
import 'package:stronger/service/schedule_service.dart';

class ScheduleProvider extends EasyNotifier {
  final scheduleService = ScheduleService();

  ScheduleModel scheduleModel = ScheduleModel.empty();

  final Map<String, dynamic> _scheduleData = {};
  Map<String, dynamic> get scheduleData => _scheduleData;

  Future<void> getSchedules(DateTime selectDay) async {
    try {
      // final getScheduleData =
      //     await scheduleService.getScheduleModel(selectedDay);
      // print(getScheduleData);
      print('selecDay: $selectDay');
      notify(() {
        _scheduleData.addAll({
          'scheduleDate': DateTime(2021, 12, 15),
          'description': '오늘 강도 빡셌다',
          'workout_records': [
            {
              'title': '스쿼트',
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
          'image_records': [],
        });
        // scheduleData.addEntries(newEntries)
        // this.scheduleModel = this.scheduleModel.copyWith(
        //       scheduleDate: scheduleModel.scheduleDate,
        //       description: scheduleModel.description,
        //       workoutRecords: scheduleModel.workoutRecords,
        //       imageRecords: scheduleModel.imageRecords,
        //     );
      });
    } catch (e) {
      throw Exception('getSchedule: $e');
    }
  }

  int calculateTotalWeight(int weight, int reps) {
    return weight * reps;
  }
}
