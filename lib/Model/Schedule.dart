import 'package:flutter/cupertino.dart';

import 'Class.dart';

class Schedule with ChangeNotifier {

  List<Class> _classes = new List<Class>();
  String _name = "";
  double _totalCredit = 0.0;

  Schedule ({List<Class> classes, String name}) {
    _classes = classes;
    _name = name;
    setTotalCredit();
  }

  String get name => _name;

  void setTotalCredit () {
    _totalCredit = 0;
    for (var course in _classes) {
      _totalCredit += course.credit;
    }
  }

  // ChangeNotifier methods
  void setSchedule (List<Class> classes, String name) {
    _classes = classes;
    _name = name;
    setTotalCredit();

    notifyListeners();
  }

  void addClass (Class course) {
    if (_classes.contains(course)) {
      // TODO: Log it
      return;
    }

    _classes.add(course);
    _totalCredit += course.credit;

    notifyListeners();
  }

  void removeClass (Class course) {
    if (!_classes.contains(course)) {
      // TODO: Log it
      return;
    }

    _classes.remove(course);
    _totalCredit -= course.credit;

    notifyListeners();
  }
}