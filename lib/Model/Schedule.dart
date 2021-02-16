import 'package:flutter/cupertino.dart';

import 'Class.dart';

class Schedule with ChangeNotifier {

  List<Class> classes;
  String name;
  double totalCredit;

  Schedule({this.classes, this.name});

  void setTotalCredit () {
    totalCredit = 0;
    for (var course in classes) {
      totalCredit += course.credit;
    }
  }


  // ChangeNotifier methods
  void setSchedule (List<Class> classes, String name) {
    this.classes = classes;
    this.name = name;
    setTotalCredit();

    notifyListeners();
  }

  void addClass (Class course) {
    if (classes.contains(course)) {
      // TODO: Log it
      return;
    }

    this.classes.add(course);
    this.totalCredit += course.credit;

    notifyListeners();
  }

  void removeClass (Class course) {
    if (!classes.contains(course)) {
      // TODO: Log it
      return;
    }

    this.classes.remove(course);
    this.totalCredit -= course.credit;

    notifyListeners();
  }
}