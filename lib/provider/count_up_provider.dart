import 'dart:async';
import 'package:stronger/provider/easy_notifier.dart';

class CountUpProvider extends EasyNotifier {
  late Timer timer;
  int hour = 0;
  int minute = 0;
  int seconds = 0;
  bool startEnable = true;
  bool stopEnable = false;
  bool continueEnable = false;

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
          if (seconds < 59) {
            seconds++;
          } else if (seconds == 59) {
            seconds = 0;
            if (minute == 59) {
              hour++;
              minute = 0;
            } else {
              minute++;
            }
          }
        });
      },
    );
  }

  void pauseTimer() {
    notify(() {
      if (startEnable == false) {
        startEnable = true;
        continueEnable = true;
        // pauseEnable = false;
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    notify(() {
      hour = 0;
      minute = 0;
      seconds = 0;
      startEnable = true;
      continueEnable = false;
      // pauseEnable = false;
      stopEnable = false;
      timer.cancel();
    });
  }

  void continueTimer() {
    startEnable = false;
    // pauseEnable = true;
    continueEnable = false;

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        notify(() {
          if (seconds < 59) {
            seconds++;
          } else if (seconds == 59) {
            seconds = 0;
            if (minute == 59) {
              hour++;
              minute = 0;
            } else {
              minute++;
            }
          }
        });
      },
    );
  }
}
