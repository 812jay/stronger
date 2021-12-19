import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ScheduleModel extends Equatable {
  final Timestamp scheduleDate;
  final String description;
  final List<String> workouts;
  final List<String> imageRecords;

  const ScheduleModel({
    required this.scheduleDate,
    required this.description,
    required this.workouts,
    required this.imageRecords,
  });

  ScheduleModel copyWith({
    Timestamp? scheduleDate,
    String? description,
    List<String>? workouts,
    List<String>? imageRecords,
  }) {
    return ScheduleModel(
      scheduleDate: scheduleDate ?? this.scheduleDate,
      description: description ?? this.description,
      workouts: workouts ?? this.workouts,
      imageRecords: imageRecords ?? this.imageRecords,
    );
  }

  factory ScheduleModel.fromDocument(DocumentSnapshot snapshot) {
    // print('snapshot: ${snapshot}');
    final data = snapshot.data() as Map<String, dynamic>;
    // print('data: $data');
    return ScheduleModel(
      scheduleDate: data['scheduleDate'],
      description: data['description'],
      workouts: List.castFrom<dynamic, String>(data['workouts']),
      imageRecords: List.castFrom<dynamic, String>(data['imageRecords']),
    );
  }

  factory ScheduleModel.empty() {
    return ScheduleModel(
      scheduleDate: Timestamp.now(),
      description: '',
      workouts: const [],
      imageRecords: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleDate': scheduleDate,
      'description': description,
      'workouts': workouts,
      'imageRecords': imageRecords,
    };
  }

  @override
  List<Object?> get props => [
        scheduleDate,
        description,
        workouts,
        imageRecords,
      ];
}
