import 'package:stronger/provider/easy_notifier.dart';

class LibraryProvider extends EasyNotifier {
  List<String> _selectedCategories = [];
  List<String> get selectedCategories => _selectedCategories;

  bool isSelectedCategory(String categoryString) {
    return _selectedCategories.contains(categoryString);
  }

  void onCategorySelect(String categoryString) {
    final bool isSelected = isSelectedCategory(categoryString);
    notify(() {
      if (isSelected) {
        _selectedCategories.remove(categoryString);
      } else {
        _selectedCategories = [..._selectedCategories, categoryString];
      }
    });
  }

  Future<void> getCategories() async {}
}
