import 'package:stronger/models/workout_model.dart';
import 'package:stronger/provider/easy_notifier.dart';
import 'package:stronger/service/workout_service.dart';

class LibraryProvider extends EasyNotifier {
  final workoutService = WorkoutService();

  WorkoutModel workoutModel = WorkoutModel.empty();

  List<String> _selectedCategories = [];
  List<String> get selectedCategories => _selectedCategories;

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

  Future<void> getWorkouts(String uid, String workout) async {
    try {
      final workoutModel = await workoutService.getWorkoutModel(uid, workout);
      notify(() {
        this.workoutModel = this.workoutModel.copyWith(
              title: workoutModel.title,
              description: workoutModel.description,
              tools: workoutModel.tools,
              isBookmarked: workoutModel.isBookmarked,
              workoutRecords: workoutModel.workoutRecords,
            );
      });
    } catch (e) {
      throw Exception('getWorkouts: $e');
    }
  }

  Future<void> getCategories() async {}
}
