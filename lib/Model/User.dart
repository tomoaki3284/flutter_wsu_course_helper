import 'package:flutter/cupertino.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';

import '../Logger.dart';


class User with ChangeNotifier {

  static final String defaultUsername = "student";

  String _username;
  SchedulePool _schedulePool = SchedulePool();

  User ({String username, SchedulePool schedulePool}) {
    Logger.LogDetailed('User', 'constructor', 'method called');
    _username = username;
    if (schedulePool != null) {
      _schedulePool = schedulePool;
    }
  }

  String get username => _username;

  SchedulePool get schedulePool => _schedulePool;

  Map<String, dynamic> toJson() => {
    '_username': username,
    '_schedulePool': _schedulePool,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    Logger.LogDetailed('User.dart', 'User.fromJson', 'method called');

    return User(
      username: json['_username'],
      schedulePool: SchedulePool.fromJson(json['_schedulePool']),
    );
  }

  // provider methods
  void setName (String username) {
    _username = username;
    notifyListeners();
  }

  void setSchedulePool (SchedulePool schedulePool) {
    _schedulePool = schedulePool;
    notifyListeners();
  }

}