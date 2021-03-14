import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../Logger.dart';
import 'Class.dart';
import 'Schedule.dart';

class SchedulePool with ChangeNotifier{

  Map<String, Schedule> scheduleByName = {};
  Schedule _focusedSchedule;

  SchedulePool({Map<String, Schedule> scheduleByName1}) {
    if (scheduleByName1 != null) {
      scheduleByName = scheduleByName1;
      // if user has created schedules already, set focusedSchedule from one of them
      if (scheduleByName.keys.length != 0) {
        _focusedSchedule = scheduleByName[scheduleByName.keys.elementAt(0)];
      }
    } else {
      scheduleByName['schedule 1'] = new Schedule(name: 'schedule 1');
      _focusedSchedule = scheduleByName[scheduleByName.keys.elementAt(0)];
    }
  }

  Schedule get focusedSchedule => _focusedSchedule;

  Map<String, dynamic> toJson() {
    return {
      'scheduleByName': scheduleByName,
    };
  }

  set focusSchedule(Schedule schedule) {
    _focusedSchedule = schedule;
    notifyListeners();
  }

  factory SchedulePool.fromJson(Map<String, dynamic> json) {
    Logger.LogDetailed(
        'SchedulePool.dart', 'SchedulePool.fromJson', 'method called');

    json = json['scheduleByName'];

    Map<String, Schedule> scheduleByName = {};
    for (var key in json.keys) {
      if (json[key] == null) continue;
      Schedule schedule = Schedule.fromJson(json[key]);
      scheduleByName[key] = schedule;
    }

    return SchedulePool(
      scheduleByName1: scheduleByName,
    );
  }

  factory SchedulePool.fromDatabase(Map<dynamic, dynamic> data) {
    Logger.LogDetailed(
        'SchedulePool.dart', 'SchedulePool.fromDatabase', 'method called');

    Map<String, Schedule> scheduleByName = {};

    if (data == null) {
      scheduleByName = null;
    } else {
      Map<String, dynamic> jsonLike = Map<String, dynamic>.from(
          data['scheduleByName']);

      for (var key in jsonLike.keys) {
        if (jsonLike[key] == null) continue;
        Schedule schedule = Schedule.fromDatabase(
            jsonLike[jsonLike.keys.elementAt(0)]);
        scheduleByName[key] = schedule;
      }
    }

    return SchedulePool(
      scheduleByName1: scheduleByName,
    );
  }

  Map getScheduleDataMap() {
    Map<dynamic, dynamic> scheduleByName = {};
    for (var key in this.scheduleByName.keys) {
      scheduleByName[key] = this.scheduleByName[key].getDataMap();
    }

    return {
      'scheduleByName': scheduleByName,
    };
  }

  // provider methods
  /// SchedulePool doesn't allow to add new schedule that has same name
  /// as existing schedule.
  /// (This is because of duplication of Map key, and simply confusing for user)
  /// If new schedule name already exist, return false and don't make/add new
  /// schedule to the SchedulePool
  bool addSchedule(String name) {
    Logger.LogDetailed('SchedulePool.dart', 'addSchedule', 'method called');

    if (name == null || name.length == 0 || scheduleByName.containsKey(name)) {
      // new name already exist in schedulePool, so return false
      return false;
    }

    Schedule schedule = Schedule(name: name);
    scheduleByName[schedule.name] = schedule;

    // when user add schedule, we can expect that user is most likely want to
    // focus on the new schedule that is created. So change the _focusedSchedule
    _focusedSchedule = schedule;

    notifyListeners();
    return true;
  }

  /// SchedulePool doesn't allow to add new schedule that has same name
  /// as existing schedule.
  /// (This is because of duplication of Map key, and simply confusing for user)
  /// If new schedule name already exist, return false and don't make/add new
  /// schedule to the SchedulePool
  bool directlyAddSchedule(Schedule schedule) {
    String name = schedule.name;
    if (name == null || name.length == 0 || scheduleByName.containsKey(name)) {
      // new name already exist in schedulePool, so return false
      return false;
    }

    scheduleByName[name] = schedule;

    notifyListeners();
    return true;
  }

  bool removeTargetSchedule(String scheduleName) {
    Logger.LogDetailed(
        'SchedulePool.dart', 'removeTargetSchedule', 'method called');

    // Shouldn't go into this if clause
    if (!scheduleByName.containsKey(scheduleName)) {
      return false;
    }

    scheduleByName.remove(scheduleName);

    notifyListeners();
    return true;
  }

  void setSchedule (Map<String, Schedule> newSchedules) {
    scheduleByName = newSchedules;
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
    Logger.LogDetailed(
        'SchedulePool.dart', 'addClassToTargetSchedule', 'method called');
    scheduleByName[scheduleName].addClass(course);
    notifyListeners();
  }

  void removeClassFromTargetSchedule (String scheduleName, Class course) {
    Logger.LogDetailed(
        'SchedulePool.dart', 'removeClassFromTargetSchedule', 'method called');
    scheduleByName[scheduleName].removeClass(course);
    notifyListeners();
  }
}