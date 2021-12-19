import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/schedule_model.dart';
import 'package:stronger/provider/easy_notifier.dart';
import 'package:stronger/service/schedule_service.dart';

class ScheduleProvider extends EasyNotifier {
  final scheduleService = ScheduleService();

  ScheduleModel scheduleModel = ScheduleModel.empty();

  Future<void> getSchedules(Timestamp selectDay) async {
    try {
      final scheduleModel = await scheduleService.getScheduleModel(selectDay);
      notify(() {
        this.scheduleModel = this.scheduleModel.copyWith(
              scheduleDate: scheduleModel!.scheduleDate,
              description: scheduleModel.description,
              workouts: scheduleModel.workouts,
              imageRecords: scheduleModel.imageRecords,
            );
      });
    } catch (e) {
      throw Exception('getSchedule: $e');
    }
  }
}
