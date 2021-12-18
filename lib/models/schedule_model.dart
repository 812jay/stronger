import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ScheduleModel extends Equatable {
  final Timestamp scheduleDate;
  final String description;
  final List<String> imageRecords;

  const ScheduleModel({
    required this.scheduleDate,
    required this.description,
    required this.imageRecords,
  });

  ScheduleModel copyWith({
    Timestamp? scheduleDate,
    String? description,
    List<Map<String, dynamic>>? workoutRecords,
    List<String>? imageRecords,
  }) {
    return ScheduleModel(
      scheduleDate: scheduleDate ?? this.scheduleDate,
      description: description ?? this.description,
      imageRecords: imageRecords ?? this.imageRecords,
    );
  }

  factory ScheduleModel.fromDocument(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ScheduleModel(
      scheduleDate: data['scheduleDate'],
      description: data['description'],
      imageRecords: List.castFrom<dynamic, String>(data['imageRecords']),
    );
  }

  factory ScheduleModel.empty() {
    return ScheduleModel(
      scheduleDate: Timestamp.now(),
      description: '',
      imageRecords: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleDate': scheduleDate,
      'description': description,
      'imageRecords': imageRecords,
    };
  }

  @override
  List<Object?> get props => [
        scheduleDate,
        description,
        imageRecords,
      ];
}
