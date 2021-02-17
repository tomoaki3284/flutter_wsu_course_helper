import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:wsu_course_helper/Model/Class.dart';

class ClassListFilter with ChangeNotifier{

  String filterCoreBy = "";
  String filterExtraBy = "";
  List<Class> unfilteredClasses;
  List<Class> filteredClasses;

  void applyFilter () {
    filteredClasses = [];
    if (filterCoreBy.length != 0) {
      for (var course in unfilteredClasses) {
        if (course.cores != null && course.cores.contains(filterCoreBy)) {
          filteredClasses.add(course);
        }
      }
    }

    if (filterExtraBy.length != 0) {
      // if multiple filtering, we need to filter from filteredClasses instead of unfilteredClasses
      if (filteredClasses.length == 0) {
        for (var course in unfilteredClasses) {
          if (filterExtraBy == "lab" && course.isLab) {
            filteredClasses.add(course);
          } else if (filterExtraBy == "online" && course.room.toLowerCase() == "online") {
            filteredClasses.add(course);
          } else if (filterExtraBy == "remsyc" && course.room.toLowerCase() == "remsyc") {
            filteredClasses.add(course);
          }
        }
      } else {
        for (var course in filteredClasses) {
          if (filterExtraBy == "lab" && !course.isLab) {
            filteredClasses.remove(course);
          } else if (filterExtraBy == "online" && course.room.toLowerCase() != "online") {
            filteredClasses.remove(course);
          } else if (filterExtraBy == "remsyc" && course.room.toLowerCase() != "remsyc") {
            filteredClasses.remove(course);
          }
        }
      }
    }

    notifyListeners();
  }

  List<String> getFilterComponents () {
    if (filterCoreBy.length == 0 && filterExtraBy.length == 0) {
      return null;
    }

    List<String> res = [];
    if (filterCoreBy.length != 0) {
      res.add(filterCoreBy);
    }
    if (filterExtraBy.length != 0) {
      res.add(filterExtraBy);
    }

    return res;
  }

  void removeFilter (String filterName) {
    if (filterCoreBy == filterName) {
      filterCoreBy = "";
    } else if (filterExtraBy == filterName) {
      filterExtraBy = "";
    }

    applyFilter();
  }

}