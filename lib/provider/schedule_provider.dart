import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/schedule_model.dart';
import 'package:stronger/models/workout_model.dart';
import 'package:stronger/provider/easy_notifier.dart';
import 'package:stronger/service/schedule_service.dart';
import 'package:stronger/service/workout_service.dart';
import 'package:stronger/utils/calculator.dart';

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
  final workoutService = WorkoutService();
  final calculator = Calculator();

  ScheduleModel scheduleModel = ScheduleModel.empty();

  WorkoutViewTypes _selectedViewType = WorkoutViewTypes.vol;
  WorkoutViewTypes get selectedViewType => _selectedViewType;

  bool _viewTimer = false;
  bool get viewTimer => _viewTimer;

  List<WorkoutModel> dayWorkouts = [];
  List<Map<String, dynamic>> dayWorkoutRecords = [];
  List<List<Map<String, dynamic>>> dayWorkoutSets = [];

  //운동선택에서 선택한 운동
  List<String> _selectedworkouts = [];
  List<String> get selectedWorkouts => _selectedworkouts;

  void setViewTimer() {
    notify(() {
      _viewTimer = !viewTimer;
    });
  }

  //클릭한 날짜 schdule 정보 불러오기
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

  //불러온 schedule에서 workout 정보 가져오기
  void setDayWorkouts(List<WorkoutModel> workouts) {
    dayWorkouts.clear();
    notify(() {
      for (String workout in scheduleModel.workouts) {
        final data = workouts.firstWhere((element) => element.title == workout);
        dayWorkouts = [...dayWorkouts, data];
      }
    });
  }

  //불러온 schedule workout정보에서 workoutRecord가져오기
  void setDayWorkoutRecords(Timestamp selectedDay) {
    dayWorkoutRecords.clear();
    dayWorkoutSets.clear();
    notify(() {
      for (WorkoutModel dayWorkout in dayWorkouts) {
        final data = dayWorkout.workoutRecords.firstWhere((element) =>
            calculator.compareTimestampToDatetime(
                selectedDay, element['workoutDate']));
        dayWorkoutRecords = [...dayWorkoutRecords, data];
      }

      for (var workoutRecord in dayWorkoutRecords) {
        List<Map<String, dynamic>> workoutSets =
            List<Map<String, dynamic>>.from(workoutRecord['sets']);
        dayWorkoutSets = [...dayWorkoutSets, workoutSets];
      }
    });
  }

  void setWorkoutsSchedule(String uid, Timestamp scheduleDate) {
    workoutService.getWorkoutsSchedule(uid, scheduleDate);
  }

  //캘린더에서 스케줄 클릭시 vol, max별로 보여주는 방식
  void onSelectViewType(WorkoutViewTypes type) {
    notify(() {
      _selectedViewType = type;
    });
  }

  //운동선택에서 클릭했던 운동들 clear
  void clearSelectedworkoutsTitle() {
    notify(() {
      _selectedworkouts.clear();
    });
  }

  //운동선택에서 운동 클릭시 이벤트
  void setAddWorkouts(String workout) {
    notify(() {
      if (!_selectedworkouts.contains(workout)) {
        _selectedworkouts.add(workout);
      } else {
        _selectedworkouts.remove(workout);
      }
    });
  }

  void setAddScheduleWorkouts(String uid, Timestamp scheduleDate) {
    scheduleService.addScheduleWorkouts(
      uid,
      _selectedworkouts,
      scheduleDate,
    );
    workoutService.addWorkoutsSchedule(
      uid,
      _selectedworkouts,
      scheduleDate,
    );
  }

  void deleteScheduleWorkouts(
      String uid, Timestamp scheduleDate, String workout) {
    scheduleService.removeScheduleWorkout(uid, scheduleDate, workout);
    workoutService.removeWorkoutsSchedule(uid, scheduleDate, workout);
  }
}
