import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../Logger.dart';
import 'Class.dart';
import 'Schedule.dart';

class SchedulePool with ChangeNotifier{

  Map<String, Schedule> _scheduleByName = {};
  Schedule _focusedSchedule;

  SchedulePool ({Map<String, Schedule> scheduleByName}) {
    if (scheduleByName != null) {
      _scheduleByName = scheduleByName;
      // if user has created schedules already, set focusedSchedule from one of them
      if (_scheduleByName.keys.length != 0) {
        _focusedSchedule = _scheduleByName[_scheduleByName.keys.elementAt(0)];
      }
    }
  }

  Map<String, Schedule> get scheduleByName => _scheduleByName;

  Schedule get focusedSchedule => _focusedSchedule;

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
  /// SchedulePool doesn't allow to add new schedule that has same name
  /// as existing schedule.
  /// (This is because of duplication of Map key, and simply confusing for user)
  /// If new schedule name already exist, return false and don't make/add new
  /// schedule to the SchedulePool
  bool addSchedule (String name) {
    Logger.LogDetailed('SchedulePool.dart', 'addSchedule', 'method called');


    if (_scheduleByName.containsKey(name)) {
      // new name already exist in schedulePool, so return false
      return false;
    }

    Schedule schedule = Schedule(name: name);
    _scheduleByName[schedule.name] = schedule;

    // when user add schedule, we can expect that user is most likely want to
    // focus on the new schedule that is created. So change the _focusedSchedule
    _focusedSchedule = schedule;

    notifyListeners();
    return true;
  }

  bool removeTargetSchedule (String scheduleName) {
    Logger.LogDetailed('SchedulePool.dart', 'removeTargetSchedule', 'method called');

    // Shouldn't go into this if clause
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

  // void addClassToNewSchedule (Class course, String scheduleName) {
  //   Logger.LogDetailed('SchedulePool.dart', 'addClassToNewSchedule', 'method called');
  //   Schedule newSchedule = new Schedule(name: scheduleName);
  //   _scheduleByName[newSchedule.name] = newSchedule;
  //   addClassToTargetSchedule(newSchedule.name, course);
  //   notifyListeners();
  // }

  void addClassToTargetSchedule (String scheduleName, Class course) {
    Logger.LogDetailed('SchedulePool.dart', 'addClassToTargetSchedule', 'method called');
    _scheduleByName[scheduleName].addClass(course);
  }

  void removeClassFromTargetSchedule (String scheduleName, Class course) {
    Logger.LogDetailed('SchedulePool.dart', 'removeClassFromTargetSchedule', 'method called');
    _scheduleByName[scheduleName].removeClass(course);
  }
}