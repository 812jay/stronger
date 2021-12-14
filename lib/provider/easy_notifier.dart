import 'package:flutter/material.dart';

class EasyNotifier extends ChangeNotifier {
  void notify([VoidCallback? action]) {
    action?.call();
    notifyListeners();
  }
}
