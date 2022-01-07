import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stronger/provider/easy_notifier.dart';

class CountUpProvider extends ChangeNotifier {
  late Timer _timer;
  int _hour = 0;
  int _minute = 0;
  int _seconds = 0;
  bool _startEnable = true;
  bool _stopEnable = false;
  bool _continueEnable = false;

  int get hour => _hour;
  int get minute => _minute;
  int get seconds => _seconds;
  bool get startEnable => _startEnable;
  bool get stopEnable => _stopEnable;
  bool get continueEnable => _continueEnable;

  void startTimer() {
    _startEnable = false;
    // _pauseEnable = true;
    _stopEnable = true;
    _continueEnable = false;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_seconds < 59) {
          _seconds++;
        } else if (_seconds == 59) {
          _seconds = 0;
          if (_minute == 59) {
            _hour++;
            _minute = 0;
          } else {
            _minute++;
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
      // _pauseEnable = false;
      _timer.cancel();
    }
    notifyListeners();
  }

  void stopTimer() {
    _hour = 0;
    _minute = 0;
    _seconds = 0;
    _startEnable = true;
    _continueEnable = false;
    // _pauseEnable = false;
    _stopEnable = false;
    _timer.cancel();
    notifyListeners();
  }

  // void continueTimer() {
  //   _startEnable = false;
  //   // _pauseEnable = true;
  //   _continueEnable = false;

  //   _timer = Timer.periodic(
  //     const Duration(seconds: 1),
  //     (timer) {
  //       if (_seconds < 59) {
  //         _seconds++;
  //       } else if (_seconds == 59) {
  //         _seconds = 0;
  //         if (_minute == 59) {
  //           _hour++;
  //           _minute = 0;
  //         } else {
  //           _minute++;
  //         }
  //       }
  //       notifyListeners();
  //     },
  //   );
  // }
}
