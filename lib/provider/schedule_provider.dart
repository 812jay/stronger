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

  // int _selectedIntWeight = 0;
  // int get selectedIntWeight => _selectedIntWeight;

  // int _selectedDecimalWeight = 0;
  // int get selectedDecimalWeight => _selectedDecimalWeight;

  int _selectedWeight = 0;
  int get selectedWeight => _selectedWeight;

  int _selectedReps = 0;
  int get selectedReps => _selectedReps;

  int _selectedMinutes = 0;
  int get selectedMinutes => _selectedMinutes;

  int _selectedSeconds = 0;
  int get selectedSeconds => _selectedSeconds;

  void setViewTimer() {
    notify(() {
      _viewTimer = !viewTimer;
    });
  }

  void setInitSetData(int weight, int reps, int time) {
    int minutes = 0;
    int seconds = 0;
    _selectedWeight = weight;
    _selectedReps = reps;
    _selectedMinutes = (time / 60).floor();
    _selectedSeconds = (time % 60);
  }

  // void setIntWeight(int value) {
  //   notify(() => _selectedIntWeight = value);
  // }

  // void setDecimalWeight(int value) {
  //   notify(() => _selectedDecimalWeight = value);
  // }

  void setWeight(int value) {
    notify(() => _selectedWeight = value);
  }

  void setReps(int value) => notify(() => _selectedReps = value);

  void setMinutes(int value) => notify(() => _selectedMinutes = value);

  void setSeconds(int value) => notify(() => _selectedSeconds = value);

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

  //스케줄 운동에서 세트추가 했을때 동작
  Future<void> addDayWorkoutSet(
      String uid, Timestamp scheduleDate, String workout) async {
    await workoutService.addDayWorkoutSet(uid, scheduleDate, workout);
  }

  //스케줄 운동에서 세트삭제 했을때 동작
  Future<void> deleteDayWorkoutSet(
      String uid, Timestamp scheduleDate, String workout) async {
    await workoutService.removeDayWorkoutSet(uid, scheduleDate, workout);
  }

  Future<void> changeIsChecked(
      String uid, Timestamp scheduleDate, String workout, int setIndex) async {
    await workoutService.changeIsChecked(uid, scheduleDate, workout, setIndex);
  }

  Future<void> addScheduleDescription(
    String uid,
    Timestamp scheduleDate,
    String description,
  ) async {
    await scheduleService.addScheduleDescription(
      uid,
      scheduleDate,
      description,
    );
  }

  Future<void> editDayWorkoutSet(
    String uid,
    Timestamp scheduleDate,
    String workout,
    int setIndex,
  ) async {
    int time = (_selectedMinutes * 60) + _selectedSeconds;
    await workoutService.editDayWorkoutSet(
      uid,
      scheduleDate,
      workout,
      setIndex,
      _selectedWeight,
      _selectedReps,
      time,
    );
  }
}
