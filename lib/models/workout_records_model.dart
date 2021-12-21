import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WorkoutRecordsModel extends Equatable {
  final String description;
  final Timestamp workoutDate;
  final List<Map<String, int>> sets;
  final List<String> imageRecords;

  const WorkoutRecordsModel({
    required this.description,
    required this.workoutDate,
    required this.sets,
    required this.imageRecords,
  });

  WorkoutRecordsModel copyWith({
    String? description,
    Timestamp? workoutDate,
    List<Map<String, int>>? sets,
    List<String>? imageRecords,
  }) {
    return WorkoutRecordsModel(
      description: description ?? this.description,
      workoutDate: workoutDate ?? this.workoutDate,
      sets: sets ?? this.sets,
      imageRecords: imageRecords ?? this.imageRecords,
    );
  }

  factory WorkoutRecordsModel.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return WorkoutRecordsModel(
      description: data['description'],
      workoutDate: data['workoutDate'],
      // sets: List.castFrom<dynamic, String>(data['tools']),
      sets: List.castFrom<dynamic, Map<String, int>>(data['sets']),
      imageRecords: List.castFrom<dynamic, String>(data['imageRecords']),
    );
  }

  factory WorkoutRecordsModel.empty() {
    return WorkoutRecordsModel(
      description: '',
      workoutDate: Timestamp.now(),
      sets: const [],
      imageRecords: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'workoutDate': workoutDate,
      'sets': sets,
      'imageRecords': imageRecords,
    };
  }

  @override
  List<Object?> get props => [
        description,
        workoutDate,
        sets,
        imageRecords,
      ];
}
