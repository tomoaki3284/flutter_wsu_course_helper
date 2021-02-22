import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../Logger.dart';
import 'Class.dart';
import 'Schedule.dart';

class SchedulePool with ChangeNotifier{

  Map<String, Schedule> _scheduleByName = {};

  SchedulePool ({Map<String, Schedule> scheduleByName}) {
    if (scheduleByName != null) {
      _scheduleByName = scheduleByName;
    }
  }

  Map<String, Schedule> get scheduleByName => _scheduleByName;

  Map<String, dynamic> toJson() => {
    '_scheduleByName': _scheduleByName,
  };

  factory SchedulePool.fromJson(Map<String, dynamic> json) {
    Logger.LogDetailed('SchedulePool.dart', 'SchedulePool.fromJson', 'method called');

    Map<String, Schedule> scheduleByName = {};
    for (var key in json.keys) {
      if (json[key] == null) continue;
      Schedule schedule = Schedule.fromJson(json[key]);
      scheduleByName[key] = schedule;
    }

    return SchedulePool(
      scheduleByName: scheduleByName,
    );
  }

  // provider methods
  bool addSchedule (Schedule schedule) {
    Logger.LogDetailed('SchedulePool.dart', 'addSchedule', 'method called');

    if (_scheduleByName.containsKey(schedule.name)) {
      return false;
    }

    _scheduleByName[schedule.name] = schedule;

    notifyListeners();
    return true;
  }

  bool removeTargetSchedule (String scheduleName) {
    Logger.LogDetailed('SchedulePool.dart', 'removeTargetSchedule', 'method called');

    if (!_scheduleByName.containsKey(scheduleByName)) {
      return false;
    }
    _scheduleByName.remove(scheduleName);

    notifyListeners();
    return true;
  }

  void setSchedule (Map<String, Schedule> newSchedules) {
    _scheduleByName = newSchedules;
    notifyListeners();
  }

  void addClassToNewSchedule (Class course, String scheduleName) {
    Logger.LogDetailed('SchedulePool.dart', 'addClassToNewSchedule', 'method called');
    Schedule newSchedule = new Schedule(name: scheduleName);
    _scheduleByName[newSchedule.name] = newSchedule;
    addClassToTargetSchedule(newSchedule.name, course);
    notifyListeners();
  }

  void addClassToTargetSchedule (String scheduleName, Class course) {
    Logger.LogDetailed('SchedulePool.dart', 'addClassToTargetSchedule', 'method called');
    _scheduleByName[scheduleName].addClass(course);
  }

  void removeClassFromTargetSchedule (String scheduleName, Class course) {
    Logger.LogDetailed('SchedulePool.dart', 'removeClassFromTargetSchedule', 'method called');
    _scheduleByName[scheduleName].removeClass(course);
  }
}