import 'package:stronger/provider/easy_notifier.dart';

enum WorkoutViewTypes {
  vol,
  max,
}

class CalendarProvider extends EasyNotifier {
  WorkoutViewTypes _selectedViewType = WorkoutViewTypes.vol;
  WorkoutViewTypes get selectedViewType => _selectedViewType;

  void onSelectViewType(WorkoutViewTypes type) {
    notify(() {
      _selectedViewType = type;
    });
  }
}
