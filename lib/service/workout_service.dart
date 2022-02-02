import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stronger/models/workout_model.dart';
import 'package:stronger/utils/calculator.dart';

class WorkoutService {
  final firestore = FirebaseFirestore.instance;
  final calculator = Calculator();

  // Future<WorkoutModel> getWorkoutModel(String uid) async {
  Future<List<WorkoutModel>> getWorkouts(String uid) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .get();

      final List<WorkoutModel> workouts = snapshot.docs.map((doc) {
        return WorkoutModel.fromDocument(doc);
      }).toList();
      return workouts;
    } catch (e) {
      throw UnimplementedError('$e');
    }
  }

  Future<List<WorkoutModel>> getWorkoutsByCategories(
      String uid, List<String> categories) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('category', whereIn: categories)
          .get();

      final List<WorkoutModel> workoutsByCategories =
          snapshot.docs.map((doc) => WorkoutModel.fromDocument(doc)).toList();
      return workoutsByCategories;
    } catch (e) {
      throw Exception('getWorkoutsByCategories: $e');
    }
  }

  // Future<List<WorkoutModel>> getScheduleWorkouts() async {
  Future<List<WorkoutModel>> getWorkoutsSchedule(
      String uid, Timestamp scheduleDate) async {
    try {
      List<WorkoutModel> dayWorkoutsDatas = [];
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .get();
      for (var doc in snapshot.docs) {
        for (var workoutRecord in doc['workoutRecords']) {
          if (calculator.compareTimestampToDatetime(
              workoutRecord['workoutDate'], scheduleDate)) {
            dayWorkoutsDatas = [
              ...dayWorkoutsDatas,
              WorkoutModel.fromDocument(doc)
            ];
          }
        }
      }
      return dayWorkoutsDatas;
    } catch (e) {
      throw Exception('getScheduleWorkouts: $e');
    }
  }

  Future<WorkoutModel> getWorkoutInfo(String uid, String title) async {
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('title', isEqualTo: title)
          .get();
      final WorkoutModel workoutInfo =
          WorkoutModel.fromDocument(snapshot.docs.single);
      return workoutInfo;
    } catch (e) {
      throw Exception('getWorkoutInfo : $e');
    }
  }

  Future<void> editWorkoutInfo(
    String uid,
    String prevTitle,
    String title,
    String category,
    List<String> tools,
    String description,
  ) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('title', isEqualTo: prevTitle)
          .get();

      final workoutId = snapshot.docs[0].id;

      firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .update(
        {
          'title': title,
          'category': category,
          'tools': tools,
          'description': description,
        },
      );
    } catch (e) {
      print('error : $e');
    }
  }

  Future<void> addWorkoutInfo(
    String uid,
    String title,
    String category,
    List<String> tools,
    String description,
  ) async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .add(
        {
          'title': title,
          'category': category,
          'isBookmarked': false,
          'tools': tools,
          'description': description,
          'workoutRecords': [],
        },
      );
      // final snapshot = await firestore
      //     .collection('users')
      //     .doc(uid)
      //     .collection('workouts')
      //     .where('title', isEqualTo: title)
      //     .get();

      // final workoutId = snapshot.docs[0].id;

      // firestore
      //     .collection('users')
      //     .doc(uid)
      //     .collection('workouts')
      //     .doc(workoutId)
      //     .update(
      //   {
      //     'title': title,
      //     'category': category,
      //     'tools': tools,
      //     'description': description,
      //   },
      // );
    } catch (e) {
      print('error : $e');
    }
  }

  Future<void> editWorkoutBookmark(
    String uid,
    String title,
    bool isBookmarked,
  ) async {
    try {
      if (isBookmarked) {
        isBookmarked = false;
      } else {
        isBookmarked = true;
      }
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('title', isEqualTo: title)
          .get();

      final workoutId = snapshot.docs[0].id;

      firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .update(
        {
          'isBookmarked': isBookmarked,
        },
      );
    } catch (e) {
      print('error : $e');
    }
  }

  Future<void> addWorkoutsSchedule(
      String uid, List<String> titles, Timestamp workoutDate) async {
    try {
      final workoutsCollection = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .get();

      List<Map<String, dynamic>> workoutRecords = [];
      List<WorkoutModel> workoutModels = [];
      String workoutId = '';
      for (var element in workoutsCollection.docs) {
        for (String title in titles) {
          if (element['title'] == title) {
            if (element.id.isNotEmpty) {
              workoutId = element.id;
              workoutRecords = [
                ...element['workoutRecords'],
                {
                  'description': '',
                  'imageRecords': [],
                  'sets': [],
                  'workoutDate': workoutDate,
                },
              ];
              firestore
                  .collection('users')
                  .doc(uid)
                  .collection('workouts')
                  .doc(element.id)
                  .update(
                {
                  'workoutRecords': workoutRecords,
                },
              );
            } else {
              firestore.collection('users').doc(uid).collection('workouts').add(
                {
                  'description': '',
                  'imageRecords': [],
                  'sets': [],
                  'workoutDate': workoutDate,
                },
              );
            }
          }
        }
      }
    } catch (e) {
      throw Exception('addWorkoutsSchedule: $e');
    }
  }

  Future<void> removeWorkoutsSchedule(
      String uid, Timestamp workoutDate, String title) async {
    try {
      final workoutsCollection = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .get();

      List<Map<String, dynamic>> workoutRecords = [];
      String workoutId = '';

      for (var workouts in workoutsCollection.docs) {
        if (workouts['title'] == title) {
          workoutId = workouts.id;
          for (var workoutRecord in workouts['workoutRecords']) {
            workoutRecords.add(workoutRecord);
            if (calculator.compareTimestampToDatetime(
                workoutRecord['workoutDate'], workoutDate)) {
              workoutRecords.remove(workoutRecord);
            }
          }
        }
      }
      firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .update(
        {
          'workoutRecords': workoutRecords,
        },
      );
    } catch (e) {
      throw Exception('removeWorkoutsSchedule: $e');
    }
  }

  Future<void> addDayWorkoutSet(
      String uid, Timestamp workoutDate, String title) async {
    try {
      final workoutsRef = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .get();

      Map<String, dynamic> workoutData = {};
      Map<String, dynamic> addSet = {};
      String workoutId = '';
      for (var workouts in workoutsRef.docs) {
        if (workouts['title'] == title) {
          workoutId = workouts.id;
          workoutData = workouts.data();
          int index = 0;
          for (var workoutRecord in workouts['workoutRecords']) {
            if (calculator.compareTimestampToDatetime(
                workoutRecord['workoutDate'], workoutDate)) {
              if (workoutRecord['sets'].isNotEmpty) {
                Map<String, dynamic> lastSet = workoutRecord['sets'].last;
                addSet = {
                  'reps': lastSet['reps'],
                  'isChecked': false,
                  'weight': lastSet['weight'],
                  'time': lastSet['time']
                };
                workoutData['workoutRecords'][index]['sets'] = [
                  ...workoutRecord['sets'],
                  addSet,
                ];
              } else {
                workoutData['workoutRecords'][index]['sets'] = [
                  {'reps': 0, 'isChecked': false, 'weight': 0, 'time': 0}
                ];
              }
            }
            index++;
          }
        }
      }

      firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .update({'workoutRecords': workoutData['workoutRecords']});
    } catch (e) {
      throw Exception('addDayWorkoutSet: $e');
    }
  }

  Future<void> removeDayWorkoutSet(
    String uid,
    Timestamp workoutDate,
    String title,
  ) async {
    try {
      final workoutsRef = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .get();

      Map<String, dynamic> workoutData = {};
      String workoutId = '';
      for (var workouts in workoutsRef.docs) {
        if (workouts['title'] == title) {
          workoutId = workouts.id;
          workoutData = workouts.data();
          int index = 0;
          for (var workoutRecord in workouts['workoutRecords']) {
            if (calculator.compareTimestampToDatetime(
                workoutRecord['workoutDate'], workoutDate)) {
              if (workoutRecord['sets'].isNotEmpty) {
                workoutData['workoutRecords'][index]['sets'].removeAt(
                    workoutData['workoutRecords'][index]['sets'].length - 1);
              }
            }
            index++;
          }
        }
      }
      firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .update({'workoutRecords': workoutData['workoutRecords']});
    } catch (e) {
      throw Exception('removeDayWorkoutSet: $e');
    }
  }

  Future<void> changeIsChecked(
      String uid, Timestamp workoutDate, String title, int setIndex) async {
    try {
      final workoutsRef = await firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .get();

      Map<String, dynamic> workoutData = {};
      String workoutId = '';
      for (var workouts in workoutsRef.docs) {
        if (workouts['title'] == title) {
          workoutId = workouts.id;
          workoutData = workouts.data();
          int index = 0;
          for (var workoutRecord in workouts['workoutRecords']) {
            if (calculator.compareTimestampToDatetime(
                workoutRecord['workoutDate'], workoutDate)) {
              workoutData['workoutRecords'][index]['sets'][setIndex]
                      ['isChecked'] =
                  !workoutData['workoutRecords'][index]['sets'][setIndex]
                      ['isChecked'];
            }
            index++;
          }
        }
      }
      firestore
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .update({'workoutRecords': workoutData['workoutRecords']});
    } catch (e) {
      throw Exception('changeIsChecked: $e');
    }
  }
}
