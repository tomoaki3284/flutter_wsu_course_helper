import 'package:flutter/cupertino.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';

class User with ChangeNotifier {

  String _username;
  SchedulePool _schedulePool;

  User ({String userName, SchedulePool schedulePool}) {
    _username = userName;
    _schedulePool = schedulePool;
  }

  // provider methods
  void setName (String username) {
    _username = username;
    notifyListeners();
  }
}