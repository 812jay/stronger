import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stronger/models/workout_model.dart';
import 'package:stronger/provider/easy_notifier.dart';
import 'package:stronger/service/workout_service.dart';

class LibraryProvider extends EasyNotifier {
  final workoutService = WorkoutService();
  final firestore = FirebaseFirestore.instance;

  List<String> _selectedCategories = [];
  List<String> get selectedCategories => _selectedCategories;

  // String _

  List<WorkoutModel> _workoutModels = [];
  List<WorkoutModel> get workoutModels => _workoutModels;

  List<WorkoutModel> _selectedWorkoutModels = [];
  List<WorkoutModel> get selectedWorkoutModels => _selectedWorkoutModels;

  WorkoutModel _workoutModelInfo = const WorkoutModel(
    title: '',
    description: '',
    category: '',
    tools: [],
    isBookmarked: false,
    workoutRecords: [],
  );

  WorkoutModel get workoutInfo => _workoutModelInfo;

  List<Map<String, dynamic>> _workoutInfoRecords = [];
  List<Map<String, dynamic>> get workoutInfoRecords => _workoutInfoRecords;

  //이전기록 현재 페이지
  int _currentRecordIndex = 0;
  int get currentRecordIndex => _currentRecordIndex;

  //이전기록 데이터
  List _currentRecordSets = [];
  List get currentRecordSets => _currentRecordSets;

  bool isSelectedCategory(String categoryString) {
    return _selectedCategories.contains(categoryString);
  }

  void onCategorySelect(String categoryString) {
    final bool isSelected = isSelectedCategory(categoryString);
    notify(() {
      if (isSelected) {
        _selectedCategories.remove(categoryString);
      } else {
        _selectedCategories = [..._selectedCategories, categoryString];
      }
    });
  }

  void clearWorkouts() {
    notify(() => _workoutModels.clear());
  }

  Future<void> setWorkouts(String uid) async {
    final List<WorkoutModel> workouts = await workoutService.getWorkouts(uid);
    _workoutModels = [...workouts];
  }

  Future<void> setWorkoutsByCategories(String uid) async {
    if (_selectedCategories.isNotEmpty) {
      final List<WorkoutModel> selectedWorkouts = await workoutService
          .getWorkoutsByCategories(uid, _selectedCategories);
      notify(() {
        _selectedWorkoutModels = [...selectedWorkouts];
      });
    }
  }

  Future<void> setWorkoutInfo(String uid, String title) async {
    _workoutInfoRecords.clear();
    final WorkoutModel workoutInfo =
        await workoutService.getWorkoutInfo(uid, title);
    notify(() {
      _workoutModelInfo = workoutInfo;
      for (var workoutRecord in workoutInfo.workoutRecords) {
        _workoutInfoRecords = [..._workoutInfoRecords, workoutRecord];
      }
    });
    setWorkoutRecord();
  }

  // List<WorkoutsData> getWorkoutsChartData() {
  //   List<WorkoutsData> result = [];
  //   int index = 0;
  //   //TODO: 한 날짜에서 세트중 가장높은 weight나 가장높은 volume 계산해야 한다.
  //   for (var set in _workoutInfoSets) {
  //     int volume = set[0]['weight'] * set[0]['reps'];
  //     result.add(WorkoutsData(
  //         DateFormat('yy.MM.dd').format(_workoutInfoDates[index].toDate()),
  //         volume));
  //     index++;
  //   }
  //   return result;
  // }

  void setWorkoutRecord([String? changeRecord]) {
    if (changeRecord == null) {
      notify(() {
        _currentRecordIndex = _workoutInfoRecords.length - 1;
      });
    } else if (changeRecord == 'prev') {
      notify(() {
        _currentRecordIndex--;
      });
    } else if (changeRecord == 'next') {
      notify(() {
        _currentRecordIndex++;
      });
    }
    currentRecordSets.clear();
    for (var set in _workoutInfoRecords[_currentRecordIndex]['sets']) {
      notify(() {
        currentRecordSets.add(set);
      });
    }
  }
}

class WorkoutsData {
  WorkoutsData(this.workoutDate, this.volume);
  final String workoutDate;
  final int volume;
}
