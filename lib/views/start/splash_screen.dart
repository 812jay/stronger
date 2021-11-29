import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stronger/views/workouts_calendar/workouts_calendar.dart';

typedef void PreprocessCompleter(bool needAuth);

class Processes {
  static bool _needAuth = false;
  static const int _jobCount = 2;
  static int _compeleteCount = 0;

  static void process(PreprocessCompleter completer) {
    _startTime(() {
      _compeleteCount++;
      if (_compeleteCount >= _jobCount) {
        completer(_needAuth);
        print("스타트타임");
      }
    });

    _checkAuth().then((value) {
      _needAuth = value;
      _compeleteCount++;
      if (_compeleteCount >= _jobCount) {
        completer(_needAuth);
      }
      print("체크어스");
    });
  }

  static Future<bool> _checkAuth() async {
    //TODO: Secure Storage 연동 로그인 정보 가져오기
    return false;
  }

  static _startTime(void completer()) async {
    var _duration = const Duration(milliseconds: 1500);
    return Timer(_duration, completer);
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Processes.process((needAuth) {
      if (needAuth == false) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WorkoutsCalendar(),
          ),
        );
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/splash/weightlifting.png',
                  color: Colors.white,
                ),
                const Text(
                  'Stronger',
                  style: TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
