import 'package:flutter/cupertino.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';


class User with ChangeNotifier {

  static final String defaultUsername = "anonymous_student";

  String _username;
  SchedulePool _schedulePool = SchedulePool();

  User ({String username, SchedulePool schedulePool}) {
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