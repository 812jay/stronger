import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:stronger/models/workout_records_model.dart';

class WorkoutModel extends Equatable {
  final String title;
  final String description;
  final String category;
  final List<String> tools;
  final bool isBookmarked;
  final List<WorkoutRecordsModel> workoutRecords;

  const WorkoutModel({
    required this.title,
    required this.description,
    required this.category,
    required this.tools,
    required this.isBookmarked,
    required this.workoutRecords,
  });

  WorkoutModel copyWith({
    String? title,
    String? description,
    String? category,
    List<String>? tools,
    bool? isBookmarked,
    List<WorkoutRecordsModel>? workoutRecords,
  }) {
    return WorkoutModel(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      tools: tools ?? this.tools,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      workoutRecords: workoutRecords ?? this.workoutRecords,
    );
  }

  factory WorkoutModel.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return WorkoutModel(
      title: data['title'],
      description: data['description'],
      category: data['category'],
      tools: List.castFrom<dynamic, String>(data['types']),
      isBookmarked: data['isBookmarked'],
      workoutRecords: data['workoutRecords'],
    );
  }

  factory WorkoutModel.empty() {
    return const WorkoutModel(
      title: '',
      description: '',
      category: '',
      tools: [],
      isBookmarked: false,
      workoutRecords: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'tools': tools,
      'isBookmarked': isBookmarked,
      'workoutRecords': workoutRecords,
    };
  }

  @override
  List<Object?> get props => [
        title,
        description,
        category,
        tools,
        isBookmarked,
        workoutRecords,
      ];
}
