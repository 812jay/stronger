import 'package:stronger/provider/easy_notifier.dart';

class LibraryProvider extends EasyNotifier {
  LibraryProvider() {
    setCategories();
  }

  // 카테고리 목록은 어떤 기준으로, 어떻게 받아오는지?
  final List<String> testCategories = [
    '즐겨찾기',
    '부위 이름1',
    '부위 이름2',
    '부위 이름3',
    '부위 이름4',
    '부위 이름5'
  ];

  List<String> _categories = [];
  List<String> get categories => _categories;

  List<String> _selectedCategories = [];
  List<String> get selectedCategories => _selectedCategories;

  void setCategories() {
    notify(() {
      _categories = [...testCategories];
    });
  }

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
