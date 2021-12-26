import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stronger/models/workout_model.dart';
import 'package:stronger/provider/easy_notifier.dart';
import 'package:stronger/service/workout_service.dart';

class LibraryProvider extends EasyNotifier {
  final workoutService = WorkoutService();
  final firestore = FirebaseFirestore.instance;

  List<String> _selectedCategories = [];
  List<String> get selectedCategories => _selectedCategories;

  List<WorkoutModel> _workoutModels = [];
  List<WorkoutModel> get workoutModels => _workoutModels;

  List<WorkoutModel> _selectedWorkoutModels = [];
  List<WorkoutModel> get selectedWorkoutModels => _selectedWorkoutModels;

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

  // Future<void> getWorkouts(String uid, List<String> workouts) async {
  //   _workoutModels.clear();
  //   for (String workout in workouts) {
  //     final workoutData = await workoutService.getWorkoutModel(uid, workout);

  //     _workoutModels = [...workoutModels, workoutData];
  //   }
  //   // print(workoutModels);
  //   notify();
  //   // notify(() {
  //   //   this.workoutModel = this.workoutModel.copyWith(
  //   //       title: workoutModel?.title,
  //   //       description: workoutModel?.description,
  //   //       category: workoutModel?.category,
  //   //       tools: workoutModel?.tools,
  //   //       isBookmarked: workoutModel?.isBookmarked,
  //   //       workoutRecords: workoutModel?.workoutRecords);
  //   // });
  // }

  // Future<void> getWorkouts(String uid, String workout) async {
  //   print('object');
  //   try {
  //     final workoutModel = await workoutService.getWorkoutModel(uid, workout);

  //     return workoutModel;
  //     // notify(() {
  //     //   this.workoutModel = this.workoutModel.copyWith(
  //     //       title: workoutModel?.title,
  //     //       description: workoutModel?.description,
  //     //       category: workoutModel?.category,
  //     //       tools: workoutModel?.tools,
  //     //       isBookmarked: workoutModel?.isBookmarked,
  //     //       workoutRecords: workoutModel?.workoutRecords);
  //     // });
  //   } catch (e) {
  //     throw Exception('getWorkouts: $e');
  //   }
  // }

  Future<void> getCategories() async {}
}
