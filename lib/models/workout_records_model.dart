import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WorkoutRecordsModel extends Equatable {
  final String description;
  final Timestamp workoutTime;
  final List<Map<String, dynamic>> sets;

  const WorkoutRecordsModel({
    required this.description,
    required this.workoutTime,
    required this.sets,
  });

  WorkoutRecordsModel copyWith({
    String? description,
    Timestamp? workoutTime,
    List<Map<String, dynamic>>? sets,
  }) {
    return WorkoutRecordsModel(
      description: description ?? this.description,
      workoutTime: workoutTime ?? this.workoutTime,
      sets: sets ?? this.sets,
    );
  }

  factory WorkoutRecordsModel.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return WorkoutRecordsModel(
      description: data['description'],
      workoutTime: data['workoutTime'],
      // sets: List.castFrom<dynamic, String>(data['tools']),
      sets: data['sets'],
    );
  }

  factory WorkoutRecordsModel.empty() {
    return WorkoutRecordsModel(
      description: '',
      workoutTime: Timestamp.now(),
      sets: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'workoutTime': workoutTime,
      'sets': sets,
    };
  }

  @override
  List<Object?> get props => [
        description,
        workoutTime,
        sets,
      ];
}
