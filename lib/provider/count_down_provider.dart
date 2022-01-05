import 'dart:async';

import 'package:flutter/material.dart';

class CountDownProvider extends ChangeNotifier {
  late Timer _timer;
  int _minute = 0;
  int _seconds = 0;
  int _selectedMinute = 0;
  int _selectedSeconds = 0;
  bool _endTime = true;
  bool _startEnable = true;
  bool _stopEnable = false;
  bool _continueEnable = false;

  int get minute => _minute;
  int get seconds => _seconds;
  int get selectedMinute => _selectedMinute;
  int get selectedSeconds => _selectedSeconds;

  bool get endTime => _endTime;
  bool get startEnable => _startEnable;
  bool get stopEnable => _stopEnable;
  bool get continueEnable => _continueEnable;

  void setMinute(int value) {
    _selectedMinute = value;
    notifyListeners();
  }

  void setSeconds(int value) {
    _selectedSeconds = value;
    notifyListeners();
  }

  void setTime() {
    if (_selectedMinute == 0 && _selectedSeconds == 0) {
      _endTime = true;
    } else {
      _endTime = false;
    }
    _stopEnable = false;
    _minute = _selectedMinute;
    _seconds = _selectedSeconds;
    notifyListeners();
  }

  void startTimer() {
    _startEnable = false;
    _stopEnable = true;
    _continueEnable = false;
    _endTime = false;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_seconds > 0) {
          _seconds--;
        } else if (_seconds == 0) {
          if (_minute > 0) {
            _seconds = _seconds + 59;
            _minute = _minute - 1;
          } else {
            print('끄읏');
            _endTime = true;
            _stopEnable = false;
            timer.cancel();
          }
        }

        notifyListeners();
      },
    );
  }

  void pauseTimer() {
    if (_startEnable == false) {
      _startEnable = true;
      _continueEnable = true;
      _timer.cancel();
    }
    notifyListeners();
  }

  void stopTimer() {
    _minute = 0;
    _seconds = 0;
    _startEnable = true;
    _continueEnable = false;
    _stopEnable = false;
    _timer.cancel();
    notifyListeners();
  }
}
