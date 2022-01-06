import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/schedule_model.dart';
import 'package:stronger/models/workout_model.dart';
import 'package:stronger/provider/easy_notifier.dart';
import 'package:stronger/service/schedule_service.dart';

extension WorkoutViewTypesX on WorkoutViewTypes {
  bool get isVol => this == WorkoutViewTypes.vol;
  bool get isMax => this == WorkoutViewTypes.max;
}

enum WorkoutViewTypes {
  vol,
  max,
}

class ScheduleProvider extends EasyNotifier {
  final scheduleService = ScheduleService();

  ScheduleModel scheduleModel = ScheduleModel.empty();

  WorkoutViewTypes _selectedViewType = WorkoutViewTypes.vol;
  WorkoutViewTypes get selectedViewType => _selectedViewType;

  List<WorkoutModel> dayWorkouts = [];
  List<Map<String, dynamic>> dayWorkoutRecords = [];
  List<dynamic> dayWorkoutSets = [];

  List<String> _selectedWorkouts = [];
  List<String> get selectedWorkouts => _selectedWorkouts;

  Future<void> setSchedule(String uid, Timestamp selectDay) async {
    try {
      final scheduleModel =
          await scheduleService.getScheduleModel(uid, selectDay);
      this.scheduleModel = this.scheduleModel.copyWith(
            scheduleDate: scheduleModel!.scheduleDate,
            description: scheduleModel.description,
            workouts: scheduleModel.workouts,
            imageRecords: scheduleModel.imageRecords,
          );
    } catch (e) {
      throw Exception('getSchedule: $e');
    }
  }

  void setDayWorkouts(List<WorkoutModel> workouts) {
    dayWorkouts.clear();
    notify(() {
      for (String workout in scheduleModel.workouts) {
        final data = workouts.firstWhere((element) => element.title == workout);
        dayWorkouts = [...dayWorkouts, data];
      }
    });
  }

  void setDayWorkoutRecords(Timestamp selectedDay) {
    dayWorkoutRecords.clear();
    dayWorkoutSets.clear();
    notify(() {
      for (WorkoutModel dayWorkout in dayWorkouts) {
        final data = dayWorkout.workoutRecords.firstWhere((element) =>
            scheduleService.compareTimestampToDatetime(
                selectedDay, element['workoutDate']));
        dayWorkoutRecords = [...dayWorkoutRecords, data];
      }

      for (var workoutRecord in dayWorkoutRecords) {
        dayWorkoutSets = [...dayWorkoutSets, workoutRecord['sets']];
      }
    });
  }

  // void setDayWorkoutSets(Timestamp selectedDay) {
  //   dayWorkoutSets.clear();
  //   notify(() {
  //     for (var workoutRecord in dayWorkoutRecords) {
  //       dayWorkoutSets = [...dayWorkoutSets, workoutRecord['sets']];
  //     }
  //   });
  // }

  void onSelectViewType(WorkoutViewTypes type) {
    notify(() {
      _selectedViewType = type;
    });
  }

  void setAddWorkouts(String workout) {
    notify(() {
      if (!_selectedWorkouts.contains(workout)) {
        _selectedWorkouts.add(workout);
      } else {
        _selectedWorkouts.remove(workout);
      }
    });
    print(_selectedWorkouts);
  }
}
