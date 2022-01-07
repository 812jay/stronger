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

  List<WorkoutModel> dayWorkouts = [];
  List<Map<String, dynamic>> dayWorkoutRecords = [];
  List<dynamic> dayWorkoutSets = [];

  //운동선택에서 선택한 운동
  List<String> _selectedworkoutsTitle = [];
  List<String> get selectedWorkouts => _selectedworkoutsTitle;

  //스케줄에 선택되어있는 운동
  List<Map<String, dynamic>> _todayWorkouts = [];
  List<Map<String, dynamic>> get todayWorkouts => _todayWorkouts;

  List<WorkoutModel> _todayWorkoutsInfo = [];
  List<WorkoutModel> get todayWorkoutsInfo => _todayWorkoutsInfo;

  //스케줄 운동의 세트
  List<Map<String, dynamic>> _todayWorkoutSets = [];
  List<Map<String, dynamic>> get todayWorkoutSets => _todayWorkoutSets;

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
        dayWorkoutSets = [...dayWorkoutSets, workoutRecord['sets']];
      }
    });
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
      _selectedworkoutsTitle.clear();
    });
  }

  //운동선택에서 운동 클릭시 이벤트
  void setAddWorkouts(String workout) {
    notify(() {
      if (!_selectedworkoutsTitle.contains(workout)) {
        _selectedworkoutsTitle.add(workout);
      } else {
        _selectedworkoutsTitle.remove(workout);
      }
    });
  }

  //운동선택에서 클릭한 운동을 운동추가했을때 해당 스케줄 일자에 담아줌
  void setTodayWorkouts(Timestamp selectedDay) {
    if (_todayWorkouts.isEmpty) {
      _todayWorkouts.add(
        {
          'scheduleDate': selectedDay,
          'titles': [..._selectedworkoutsTitle],
          // 'sets': [],
        },
      );
    } else {
      for (var todayWorkout in _todayWorkouts) {
        final bool compareDate = calculator.compareTimestampToDatetime(
            selectedDay, todayWorkout['scheduleDate']);
        if (compareDate) {
          todayWorkout.update(
              'titles', (value) => value = [...selectedWorkouts]);
          break;
        }
        if (todayWorkout == _todayWorkouts[_todayWorkouts.length - 1] &&
            !compareDate) {
          _todayWorkouts = [
            ..._todayWorkouts,
            {
              'scheduleDate': selectedDay,
              'titles': [..._selectedworkoutsTitle],
              // 'sets': [],
            },
          ];
        }
      }
    }
  }

  void setTodayWorkoutInfo(String uid, List<String> titles) async {
    _todayWorkoutsInfo.clear();
    List<WorkoutModel> workoutsInfo = [];
    for (String title in titles) {
      workoutsInfo.add(await workoutService.getWorkoutInfo(uid, title));
    }
    notify(() {
      _todayWorkoutsInfo = workoutsInfo;
    });
  }

  void setTodayWorkoutSets(
    Timestamp scheduleDate,
    String title,
  ) {
    // _todayWorkouts.where((element) => calculator.compareTimestampToDatetime(element['scheduleDate'], scheduleDate) );

    // for (var todayWorkout in _todayWorkouts) {
    //   final compareDate = calculator.compareTimestampToDatetime(
    //     todayWorkout['scheduleDate'],
    //     scheduleDate,
    //   );
    //   // if (compareDate && todayWorkout['title'] == title) {
    //   //   final Map<String, dynamic> prevSets = todayWorkout['sets'];
    //   //   todayWorkout['sets'] = [_todayWorkoutSets, prevSets];
    //   // } else {

    //   // }
    // }

    print('title: $title');
    notify(() {
      if (_todayWorkoutSets.isEmpty) {
        _todayWorkoutSets = [
          {
            'scheduleDate': scheduleDate,
            'title': title,
            // 'weight': 1,
            // 'reps': 1,
            // 'time': 1,
            'sets': [
              {
                'weight': 0,
                'reps': 0,
                'time': 0,
                'isChecked': false,
              }
            ],
          }
        ];
      } else {
        // final Map<String, dynamic> prevSets =
        //     _todayWorkoutSets[_todayWorkoutSets.length - 1];

        for (var todayWorkoutSet in _todayWorkoutSets) {
          final Map<String, dynamic> prevSets =
              todayWorkoutSet['sets'][todayWorkoutSet.length - 1];
          if (calculator.compareTimestampToDatetime(
                  todayWorkoutSet['scheduleDate'], scheduleDate) &&
              todayWorkoutSet['title'] == title) {
            todayWorkoutSet['sets'] = [...todayWorkoutSet['sets'], prevSets];
          } else {
            _todayWorkoutSets = [
              ..._todayWorkoutSets,
              {
                'scheduleDate': scheduleDate,
                'title': title,
                'sets': {'weight': 0, 'reps': 0, 'time': 0, 'isChecked': false},
                'isChecked': prevSets['isChecked']
              }
            ];
          }
        }

        // print(prevSets);
        // print(
        //   _todayWorkoutSets.where(
        //     (element) => calculator.compareTimestampToDatetime(
        //       element['scheduleDate'],
        //       scheduleDate,
        //     ),
        //   ),
        // );

        // element['scheduleDate'] == scheduleDate &&
        // element['title'] == title));
        // _todayWorkoutSets = [
        //   ..._todayWorkoutSets,
        //   {
        //     'scheduleDate': scheduleDate,
        //     'title': title,
        //     // 'weight': prevSets['weight'],
        //     // 'reps': prevSets['reps'],
        //     // 'time': prevSets['time'],
        //     'sets': prevSets['sets'],
        //     'isChecked': prevSets['isChecked']
        //   }
        // ];
      }
    });
    print(_todayWorkoutSets);
  }
}
