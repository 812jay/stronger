import 'package:stronger/provider/easy_notifier.dart';
import 'package:table_calendar/table_calendar.dart';

enum WorkoutViewTypes {
  vol,
  max,
}

class CalendarProvider extends EasyNotifier {
  //vol, max 타입
  WorkoutViewTypes _selectedViewType = WorkoutViewTypes.vol;
  WorkoutViewTypes get selectedViewType => _selectedViewType;

  //calendar
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;
  DateTime _focusedDay = DateTime.now();
  DateTime get focusedDay => _focusedDay;
  CalendarFormat _format = CalendarFormat.month;
  CalendarFormat get format => _format;

  void onSelectViewType(WorkoutViewTypes type) {
    notify(() {
      _selectedViewType = type;
    });
  }

  void onDaySelect(DateTime selectDay, DateTime focusDay) {
    notify(() {
      _selectedDay = selectDay;
      _focusedDay = focusDay;
    });
    // print('${selectedDay}, ${focusDay}');
  }

  void onPageChange(DateTime focusDay) {
    _focusedDay = focusDay;
  }

  void onFormatChange(CalendarFormat format) {
    _format = format;
  }

  // bool onSelectDayPredicate(DateTime day) {
  //   return isSameDay(_selectedDay, day);
  // }
}
