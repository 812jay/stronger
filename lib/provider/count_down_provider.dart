import 'dart:async';
import 'package:stronger/provider/count_up_provider.dart';

class CountDownProvider extends CountUpProvider {
  int _selectedMinute = 0;
  int _selectedSeconds = 0;
  int get selectedMinute => _selectedMinute;
  int get selectedSeconds => _selectedSeconds;

  void setMinute(int value) => notify(() => _selectedMinute = value);

  void setSeconds(int value) => notify(() => _selectedSeconds = value);

  void setTime() {
    notify(() {
      stopEnable = false;
      minute = _selectedMinute;
      seconds = _selectedSeconds;
    });
  }

  @override
  void startTimer() {
    notify(() {
      startEnable = false;
      stopEnable = true;
      continueEnable = false;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        notify(() {
          if (seconds > 0) {
            seconds--;
          } else if (seconds == 0) {
            if (minute > 0) {
              seconds = seconds + 59;
              minute = minute - 1;
            } else {
              print('끄읏');
              minute = _selectedMinute;
              seconds = _selectedSeconds;
              startEnable = true;
              stopEnable = false;
              timer.cancel();
            }
          }
        });
      },
    );
  }

  @override
  void stopTimer() {
    minute = _selectedMinute;
    seconds = _selectedSeconds;
    startEnable = true;
    continueEnable = false;
    stopEnable = false;
    timer.cancel();
    notifyListeners();
  }
}
