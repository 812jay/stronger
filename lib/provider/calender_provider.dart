import 'package:stronger/provider/easy_notifier.dart';

class CalendarProvider extends EasyNotifier {
  //calendar
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;

  void onDaySelect(DateTime selectedDay) async {
    notify(() {
      _selectedDay = selectedDay;
    });
  }
}
