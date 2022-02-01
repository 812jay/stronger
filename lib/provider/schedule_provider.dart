import 'dart:developer';

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

  List<WorkoutModel> _dayWorkouts = [];
  List<WorkoutModel> get dayWorkouts => _dayWorkouts;

  List<Map<String, dynamic>> _dayWorkoutRecords = [];
  List<Map<String, dynamic>> get dayWorkoutRecords => _dayWorkoutRecords;

  List<List<Map<String, dynamic>>> _dayWorkoutSets = [];
  List<List<Map<String, dynamic>>> get dayWorkoutSets => _dayWorkoutSets;

  //운동선택에서 선택한 운동
  List<String> _selectedWorkoutsTitle = [];
  List<String> get selectedWorkoutsTitle => _selectedWorkoutsTitle;

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
    _dayWorkouts.clear();
    notify(() {
      for (String workout in scheduleModel.workouts) {
        final data = workouts.firstWhere((element) => element.title == workout);
        _dayWorkouts = [..._dayWorkouts, data];
      }
    });
  }

  //불러온 schedule workout정보에서 workoutRecord가져오기
  void setDayWorkoutRecords(Timestamp selectedDay) {
    _dayWorkoutRecords.clear();
    _dayWorkoutSets.clear();
    notify(() {
      for (WorkoutModel dayWorkout in _dayWorkouts) {
        final data = dayWorkout.workoutRecords.firstWhere((element) =>
            calculator.compareTimestampToDatetime(
                selectedDay, element['workoutDate']));
        _dayWorkoutRecords = [..._dayWorkoutRecords, data];
      }

      for (var workoutRecord in _dayWorkoutRecords) {
        List<Map<String, dynamic>> workoutSets =
            List<Map<String, dynamic>>.from(workoutRecord['sets']);
        _dayWorkoutSets = [..._dayWorkoutSets, workoutSets];
      }
    });
  }

  Future<void> setWorkoutsSchedule(String uid, Timestamp scheduleDate) async {
    final result = await workoutService.getWorkoutsSchedule(uid, scheduleDate);
    notify(() {
      _dayWorkouts = [...result];
    });
  }

  //캘린더에서 스케줄 클릭시 vol, max별로 보여주는 방식
  void onSelectViewType(WorkoutViewTypes type) {
    notify(() {
      _selectedViewType = type;
    });
  }

  //운동선택에서 클릭했던 운동들 clear
  void clearSelectedWorkoutsTitle() {
    notify(() {
      _selectedWorkoutsTitle.clear();
    });
  }

  //운동선택에서 운동 클릭시 이벤트
  void setAddWorkouts(String workout) {
    notify(() {
      if (!_selectedWorkoutsTitle.contains(workout)) {
        _selectedWorkoutsTitle.add(workout);
      } else {
        _selectedWorkoutsTitle.remove(workout);
      }
    });
  }

  Future<void> setAddScheduleWorkouts(
      String uid, Timestamp scheduleDate) async {
    scheduleService.addScheduleWorkouts(
      uid,
      _selectedWorkoutsTitle,
      scheduleDate,
    );
    await workoutService.addWorkoutsSchedule(
      uid,
      _selectedWorkoutsTitle,
      scheduleDate,
    );
    // setWorkoutsSchedule(uid, scheduleDate);
  }

  Future<void> deleteScheduleWorkouts(
      String uid, Timestamp scheduleDate, String workout) async {
    await scheduleService.removeScheduleWorkout(uid, scheduleDate, workout);
    await workoutService.removeWorkoutsSchedule(uid, scheduleDate, workout);
  }

  //스케줄 운동에서 세트추가했을때 동작
  Future<void> addDayWorkoutSet(
      String uid, Timestamp scheduleDate, String workout) async {
    await workoutService.addDayWorkoutSet(uid, scheduleDate, workout);
  }
}
