import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Calculator {
  //타임스탬프 두 날짜가 일치하는지 비교
  bool compareTimestampToDatetime(Timestamp time1, Timestamp time2) {
    String formatTime1 = DateFormat('yyyy-MM-dd').format(time1.toDate());
    String formatTime2 = DateFormat('yyyy-MM-dd').format(time2.toDate());
    return formatTime1 == formatTime2;
  }
}
