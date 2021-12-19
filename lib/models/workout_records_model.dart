import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WorkoutRecordsModel extends Equatable {
  final String description;
  final Timestamp workoutDate;
  final List<Map<String, dynamic>> sets;

  const WorkoutRecordsModel({
    required this.description,
    required this.workoutDate,
    required this.sets,
  });

  WorkoutRecordsModel copyWith({
    String? description,
    Timestamp? workoutDate,
    List<Map<String, dynamic>>? sets,
  }) {
    return WorkoutRecordsModel(
      description: description ?? this.description,
      workoutDate: workoutDate ?? this.workoutDate,
      sets: sets ?? this.sets,
    );
  }

  factory WorkoutRecordsModel.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return WorkoutRecordsModel(
      description: data['description'],
      workoutDate: data['workoutDate'],
      // sets: List.castFrom<dynamic, String>(data['tools']),
      sets: data['sets'],
    );
  }

  factory WorkoutRecordsModel.empty() {
    return WorkoutRecordsModel(
      description: '',
      workoutDate: Timestamp.now(),
      sets: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'workoutDate': workoutDate,
      'sets': sets,
    };
  }

  @override
  List<Object?> get props => [
        description,
        workoutDate,
        sets,
      ];
}
