import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Model/Class.dart';

class ClassListFilter with ChangeNotifier{

  
  String filterCoreBy = "";
  String filterExtraBy = "";
  List<Class> unfilteredClasses;
  List<Class> filteredClasses;

  void init(List<Class> classes) {
    // because it is init, unfilteredClasses == filteredClass, I mean it doesn't matter
    unfilteredClasses = classes;
    filteredClasses = classes;
    filterCoreBy = "";
    filterExtraBy = "";
  }

  void applyTitleFilter (String filterTitleBy) {
    filteredClasses = [];
    for (var course in unfilteredClasses) {
      if (course.title.toLowerCase().contains(filterTitleBy)) {
        filteredClasses.add(course);
      }
    }

    notifyListeners();
  }

  void applyFilter () {
    filteredClasses = [];
    if (filterCoreBy.length != 0) {
      if (filterCoreBy == 'DoubleDipper') {
        for (var course in unfilteredClasses) {
          if (course.cores != null && course.cores.length >= 2) {
            filteredClasses.add(course);
          }
        }
      } else {
        for (var course in unfilteredClasses) {
          if (course.cores != null && course.cores.contains(filterCoreBy)) {
            filteredClasses.add(course);
          }
        }
      }
    } else {
      // if filter isn't define filter should be same as unfiltered
      for (Class course in unfilteredClasses) {
        filteredClasses.add(course);
      }
    }

    // now filter out classes by different component from unfiltered one
    Set<Class> set = unfilteredClasses.toSet();
    if (filterExtraBy.length != 0) {
      for (var course in unfilteredClasses) {
        if (filterExtraBy == "lab" && !course.isLab) {
          set.remove(course);
        } else if (filterExtraBy == "online" && course.room.toLowerCase() != "online") {
          set.remove(course);
        } else if (filterExtraBy == "remsyc" && course.room.toLowerCase() != "remsyc") {
          set.remove(course);
        }
      }
    }

    // now I have filtered by core, and set of classes that is filtered by extra
    // now find union, result would be the list that filtered by two filter components
    List<Class> copyFiltered = [];
    for (Class course in filteredClasses) {
      copyFiltered.add(course);
    }
    for (Class course in filteredClasses) {
      if (!set.contains(course)) {
        copyFiltered.remove(course);
      }
    }

    filteredClasses = copyFiltered;

    notifyListeners();
  }

  List<String> getFilterComponents () {
    if (filterCoreBy.length == 0 && filterExtraBy.length == 0) {
      return [];
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

  void setFilter(String text, String filterBy) {
    assert(text != null);
    assert(filterBy != null);

    if (text == 'none') {
      return;
    }

    String prefixText = text.split(' ')[0];

    if (filterBy.toLowerCase() == 'core') {
      filterCoreBy = prefixText;
    } else if (filterBy.toLowerCase() == 'special') {
      filterExtraBy = prefixText;
    }
  }

  void removeFilter (String filterName) {
    if (filterCoreBy == filterName) {
      filterCoreBy = "";
    } else if (filterExtraBy == filterName) {
      filterExtraBy = "";
    }

    applyFilter();
  }

  void resetFilter() {
    filterCoreBy = '';
    filterExtraBy = '';
    notifyListeners();
  }

}