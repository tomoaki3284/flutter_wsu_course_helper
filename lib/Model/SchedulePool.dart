import 'dart:collection';

import 'package:flutter/cupertino.dart';

import 'Class.dart';
import 'Schedule.dart';

class SchedulePool with ChangeNotifier{

  Map<String, Schedule> _scheduleByName = new HashMap<String, Schedule>();

  SchedulePool ({Map<String, Schedule> scheduleByName}) {
    _scheduleByName = scheduleByName;
  }

  Map<String, Schedule> get scheduleByName => _scheduleByName;

  // provider methods
  bool addSchedule (Schedule schedule) {
    if (_scheduleByName.containsKey(schedule.name)) {
      return false;
    }

    _scheduleByName[schedule.name] = schedule;

    notifyListeners();
    return true;
  }

  bool removeTargetSchedule (String scheduleName) {
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
    Schedule newSchedule = new Schedule(name: scheduleName);
    _scheduleByName[newSchedule.name] = newSchedule;
    addClassToTargetSchedule(newSchedule.name, course);
    notifyListeners();
  }

  void addClassToTargetSchedule (String scheduleName, Class course) {
    _scheduleByName[scheduleName].addClass(course);
  }

  void removeClassFromTargetSchedule (String scheduleName, Class course) {
    _scheduleByName[scheduleName].removeClass(course);
  }
}