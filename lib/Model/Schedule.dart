import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Logger.dart';
import 'Class.dart';
import 'Hours.dart';

class Schedule with ChangeNotifier {
  List<Class> _classes = new List<Class>();
  Map<String, List<Class>> classesByWeekDay = {};
  String _name = "";
  double _totalCredit = 0.0;
  bool timeOverlap = false;

  Schedule({List<Class> classes, @required String name}) {
    if (classes != null) {
      _classes = new List<Class>();
      for (Class course in classes) {
        _classes.add(course);
      }
    }
    _name = name;
    setTotalCredit();
    setClassesByWeekDay();
  }

  String get name => _name;

  double get totalCredit => _totalCredit;

  List<Class> get classes => _classes;

  void setClassesByWeekDay() {
    for (Class course in _classes) {
      Map<String, List<Hours>> weeklyHours = course.weeklyHours;
      for (String dayOfWeek in weeklyHours.keys) {
        if (classesByWeekDay[dayOfWeek] == null) {
          classesByWeekDay[dayOfWeek] = [course];
        } else {
          classesByWeekDay[dayOfWeek].add(course);
        }
      }
    }
  }

  void setTotalCredit() {
    _totalCredit = 0;

    if (_classes == null || _classes.length == 0) {
      return;
    }

    for (var course in _classes) {
      _totalCredit += course.credit;
    }
  }

  Map<String, dynamic> toJson() => {
        '_classes': _classes,
        '_name': _name,
        '_totalCredit': _totalCredit,
      };

  factory Schedule.fromJson(Map<String, dynamic> json) {
    Logger.LogDetailed('Schedule.dart', 'Schedule.fromJson', 'method called');

    var jsonBody = json[json['_classes']];

    List<Class> classes;
    if (jsonBody == null) {
      classes = [];
    } else {
      Iterable l = jsonDecode(jsonBody);
      classes = List<Class>.from(l.map((model) => Class.fromJson(model)));
    }

    return Schedule(
      classes: classes,
      name: json['_name'],
    );
  }

  /// How this function work?
  ///
  /// Objective:
  /// detect if class hours overlap with another class, check every day
  ///
  /// Implementation:
  /// 1. Separate classes by week, use map with key = weekOfDay val = List<Class>
  /// 2. Sort the List<Class> in each day of week, order of starting hours of a class
  /// -> This way, I can simply check two classes next to each other in the List<Class>
  /// to check if the class hours overlap. Do this operation in each week.
  /// e.g.
  ///   On Monday: List<Class> = [class1 start at 8 end at 9,
  ///                             class2 start at 10 end at 11,
  ///                             class3 start at 10:30 end at 11:30]
  ///                             // note, sorted on starting time
  ///              Iterate list
  ///               -> when comparing class2 start time and class3 end time
  ///                  it overlap, so return false
  /// 3. Do this iteration/operation for each weekOfDay
  ///
  ///
  /// TODO: Not cover the minor case, where some class have two classes on one day.
  /// In this case, this algorithms is not perfect. But it work most of the time...
  /// Good luck figuring this out future me, I'm bit tired right now. 2/19/2021
  bool doesClassHoursOverlap() {
    Logger.LogDetailed(
        'Schedule.dart', 'doesClassHoursOverlap', 'method called');

    if (_classes.length <= 1) {
      // if schedule only contains one class, then no overlap
      timeOverlap = false;
      return false;
    }

    // 1. separate classes by week
    Map<String, List<Class>> classesInWeeks = new Map<String, List<Class>>();
    for (var course in _classes) {
      // just store/register a class hours in classesInWeeks, for every dayOfWeek that class open
      for (var dayOfWeek in course.weeklyHours.keys) {
        if (classesInWeeks[dayOfWeek] == null) {
          // if there is no registration yet on the map[dayOfWeek], need to initiate the list and add class
          classesInWeeks[dayOfWeek] = [course];
        } else {
          // if map[dayOfWeek] already has a list of class, just add
          classesInWeeks[dayOfWeek].add(course);
        }
      }
    }

    // 2. sort each List<Class>, order of starting hours of the class
    // -> gotta do this on each day of week, so need to iterate
    for (var dayOfWeek in classesInWeeks.keys) {
      classesInWeeks[dayOfWeek].sort((a, b) {
        // some class has two classes on one day, so in this case, just get first hours
        // that's why [0] at the tail
        Hours class1Hours = a.weeklyHours[dayOfWeek][0];
        Hours class2Hours = b.weeklyHours[dayOfWeek][0];
        // get the starting hours of each class. Refer getIntervalForm in Hours.dart for details
        int class1StartTime = class1Hours.getInIntervalForm()[0];
        int class2StartTime = class2Hours.getInIntervalForm()[0];
        // simply return the result, the smaller start time = earlier start time
        return class1StartTime - class2StartTime;
      });
    }

    // 3. check adjacent classes for overlap detection (look e.g. if you don't understand)
    // note: at this point, the List<Class> is sorted in (step 2) in each day of week
    for (var dayOfWeek in classesInWeeks.keys) {
      List<Class> classes = classesInWeeks[dayOfWeek];
      // b/c below loop would start from i=1, classes[0] is the previous class
      List<int> previousClassHours =
          classes[0].weeklyHours[dayOfWeek][0].getInIntervalForm();
      for (int i = 1; i < classes.length; i++) {
        List<int> currentClassHours =
            classes[i].weeklyHours[dayOfWeek][0].getInIntervalForm();
        if (previousClassHours[1] > currentClassHours[0]) {
          // if previous class ending time > current class starting time, there is a overlap
          // so immediately return true, to tell this is not a valid/good schedule
          timeOverlap = true;
          return true;
        }
        // yo, don't forget, current class in this iteration, will be prev class on next iteration
        previousClassHours = currentClassHours;
      }
    }

    // well, great, no overlap detected
    timeOverlap = false;
    return false;
  }

  bool haveClass(Class course) {
    return _classes.contains(course);
  }

  // ChangeNotifier methods
  void setSchedule(List<Class> classes, String name) {
    _classes = classes;
    _name = name;
    setTotalCredit();

    notifyListeners();
  }

  void addClass(Class course) {
    if (_classes.contains(course)) {
      // TODO: Log it
      Logger.LogDetailed(
          'Schedule.dart', 'addClass', 'course is already in the schedule');
      return;
    }

    // when add class, need to add to classesByWeek as well
    for (String dayOfWeek in course.weeklyHours.keys) {
      if (classesByWeekDay[dayOfWeek] == null) {
        classesByWeekDay[dayOfWeek] = [course];
      } else {
        classesByWeekDay[dayOfWeek].add(course);
      }
    }

    _classes.add(course);
    _totalCredit += course.credit;

    notifyListeners();
  }

  void removeClass(Class course) {
    if (!_classes.contains(course)) {
      Logger.LogDetailed(
          'Schedule.dart', 'removeClass', 'course not found in the schedule');
      return;
    }

    // when remove class, need to remove from classesByWeek as well
    for (String dayOfWeek in course.weeklyHours.keys) {
      classesByWeekDay[dayOfWeek].remove(course);
    }

    _classes.remove(course);
    _totalCredit -= course.credit;

    notifyListeners();
  }
}
