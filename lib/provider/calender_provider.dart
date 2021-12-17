import 'package:stronger/provider/easy_notifier.dart';

class CalendarProvider extends EasyNotifier {
  final List<int> _allTypes = [0, 1];
  List<int> get allTypes => _allTypes;
  int _selectedType = 0;
  int get selectedType => _selectedType;

  void onTypeSelect(int type) {
    print(type);
    notify(() {
      if (type == 0) {
        _selectedType = 0;
      } else {
        _selectedType = 1;
      }
    });
  }
}
