import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stronger/models/workout_model.dart';
import 'package:stronger/provider/easy_notifier.dart';
import 'package:stronger/service/workout_service.dart';

class LibraryProvider extends EasyNotifier {
  final workoutService = WorkoutService();
  final firestore = FirebaseFirestore.instance;

  //라이브러리 목록에서 선택한 카테고리들
  List<String> _selectedCategories = [];
  List<String> get selectedCategories => _selectedCategories;

  //운동편집에서 선택한 카테고리
  String _selectedEditCategory = '';
  String get selectedEditCategory => _selectedEditCategory;

  //운동편집에서 선택한 도구
  List<String> _selectedEditTools = [];
  List<String> get selectedEditTools => _selectedEditTools;

  //전체 운동
  List<WorkoutModel> _workoutModels = [];
  List<WorkoutModel> get workoutModels => _workoutModels;

  //카테고리에서 분류된 운동 목록
  List<WorkoutModel> _selectedWorkoutModels = [];
  List<WorkoutModel> get selectedWorkoutModels => _selectedWorkoutModels;

  //운동 상세정보에서 보이는 운동
  WorkoutModel _workoutInfo = const WorkoutModel(
    title: '',
    description: '',
    category: '',
    tools: [],
    isBookmarked: false,
    workoutRecords: [],
  );
  WorkoutModel get workoutInfo => _workoutInfo;

  //운동 상세정보의 운동기록
  List<Map<String, dynamic>> _workoutInfoRecords = [];
  List<Map<String, dynamic>> get workoutInfoRecords => _workoutInfoRecords;

  //이전기록 현재 페이지
  int _currentRecordIndex = 0;
  int get currentRecordIndex => _currentRecordIndex;

  //이전기록 데이터
  List _currentRecordSets = [];
  List get currentRecordSets => _currentRecordSets;

  //함수//

  //운동목록에서 선택한 카테고리 유저 데이터에 포함되었는지
  bool isSelectedCategory(String categoryString) {
    return _selectedCategories.contains(categoryString);
  }

  //운동목록에서 카테고리 클릭했을때 동작
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

  //운동편집에서 선택한 카테고리 유저 데이터와 같은지
  bool isSelectedEditCategory(String categoryString) {
    return _selectedEditCategory == categoryString;
  }

  //운동편집에서 선택한 카테고리 클릭했을때 동작
  void onEditCategorySelect(String categoryString) {
    notify(() {
      _selectedEditCategory = categoryString;
    });
  }

  //운동편집에서 선택한 도구 유저 데이터에 포함되었는지
  bool isSelectedEditTool(String toolString) {
    return _selectedEditTools.contains(toolString);
  }

  //운동편집에서 선택한 도구 클릭했을때 동작
  void onEditToolSelect(String toolString) {
    final bool isSelected = isSelectedEditTool(toolString);
    notify(() {
      if (isSelected) {
        _selectedEditTools.remove(toolString);
      } else {
        _selectedEditTools = [..._selectedEditTools, toolString];
      }
    });
  }

  //전체 운동목록 불러오기
  Future<void> setWorkouts(String uid) async {
    final List<WorkoutModel> workouts = await workoutService.getWorkouts(uid);
    _workoutModels = [...workouts];
  }

  //운동목록에서 카테고리별 운동 불러오기
  Future<void> setWorkoutsByCategories(String uid) async {
    if (_selectedCategories.isNotEmpty) {
      final List<WorkoutModel> selectedWorkouts = await workoutService
          .getWorkoutsByCategories(uid, _selectedCategories);
      notify(() {
        _selectedWorkoutModels = [...selectedWorkouts];
      });
    }
  }

  //운동 상세정보에서 운동정보 불러오기
  Future<void> setWorkoutInfo(String uid, String title) async {
    _workoutInfoRecords.clear();
    final WorkoutModel workoutInfo =
        await workoutService.getWorkoutInfo(uid, title);

    notify(() {
      _workoutInfo = workoutInfo;
      _selectedEditTools.clear();
      _selectedEditTools.addAll(workoutInfo.tools);
      _selectedEditCategory = workoutInfo.category;
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

  //운동 상세정보에서 이전기록 데이터 불러오기
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

  //운동편집에서 데이터 제출시 동작
  void setEditLibrary(
    String uid,
    String prevTitle,
    String title,
    String category,
    List<String> tools,
    String description,
  ) async {
    await workoutService.editWorkoutInfo(
      uid,
      prevTitle,
      title,
      category,
      tools,
      description,
    );
    setWorkoutInfo(uid, title);
  }

  void setIsBookmarked(String uid, String title, bool isBookmarked) async {
    await workoutService.editWorkoutBookmark(uid, title, isBookmarked);
    setWorkouts(uid);
    setWorkoutInfo(uid, title);
  }
}

//차트데이터에서 쓰임
class WorkoutsData {
  WorkoutsData(this.workoutDate, this.volume);
  final String workoutDate;
  final int volume;
}
