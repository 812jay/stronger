import 'package:stronger/provider/easy_notifier.dart';

class UserProvider extends EasyNotifier {
  UserProvider() {
    initialize();
  }

  final List<String> testCategories = [
    '즐겨찾기',
    '부위 이름1',
    '부위 이름2',
    '부위 이름3',
    '부위 이름4',
    '부위 이름5'
  ];

  final List<String> testTools = [
    '망치',
    '톱',
    '야전삽',
    '밴드',
    '덤벨',
    '케틀벨',
  ];

  List<String> _categories = [];
  List<String> get categories => _categories;

  List<String> _tools = [];
  List<String> get tools => _tools;

  void initialize() {
    notify(() {
      setCategories();
      setTools();
    });
  }

  Future<void> setCategories() async {
    _categories = [...testCategories];
  }

  void setTools() {
    _tools = [...testTools];
  }
}
