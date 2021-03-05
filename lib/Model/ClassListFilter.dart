import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Logger.dart';
import 'package:wsu_course_helper/Model/Class.dart';

class ClassListFilter with ChangeNotifier {
  String filterCoreBy = "";
  String filterExtraBy = "";
  String filterSubjectBy = "";
  String filterTitleBy = "";

  List<Class> unfilteredClasses;
  List<Class> filteredClasses;

  void init(List<Class> classes) {
    // because it is init, unfilteredClasses == filteredClass, I mean it doesn't matter
    unfilteredClasses = classes;
    filteredClasses = classes;
    filterCoreBy = "";
    filterExtraBy = "";
  }

  void applyTitleFilter(String filterTitleBy) {
    filteredClasses = [];
    for (var course in unfilteredClasses) {
      if (course.title.toLowerCase().contains(filterTitleBy)) {
        filteredClasses.add(course);
      }
    }

    notifyListeners();
  }

  void applyFilter() {
    Set<Class> filteredSet = {};

    Logger.LogDetailed('ClassListFilter.dart', 'applyFilter', 'method called');

    // add all course to set
    for (Class course in unfilteredClasses) {
      filteredSet.add(course);
    }

    // then remove any course that doesn't meet the filter requirement
    // first filter by core
    _filterCore(filteredSet, {});
    // then filter by special category
    _filterExtra(filteredSet, {});
    // then filter by subject
    _filterSubject(filteredSet, {});
    // then filter by title
    _filterTitle(filteredSet, {});

    print('finish');

    filteredClasses = filteredSet.toList();
    notifyListeners();
  }

  void _copySetFromTo(Set filteredSet, Set copy) {
    for (Class course in filteredSet) {
      copy.add(course);
    }
  }

  void _filterCore(Set filteredSet, Set copy) {
    _copySetFromTo(filteredSet, copy);
    if (filterCoreBy != null && filterCoreBy.length != 0) {
      bool doubleDip = filterCoreBy == 'DoubleDipper';
      String coreFilter = filterCoreBy.split(' ')[0];
      for (Class course in copy) {
        if (doubleDip) {
          if (course.cores.length < 2) {
            filteredSet.remove(course);
          }
        } else if (!course.cores.contains(coreFilter)) {
          filteredSet.remove(course);
        }
      }
    }
  }

  void _filterExtra(Set filteredSet, Set copy) {
    _copySetFromTo(filteredSet, copy);
    if (filterExtraBy != null && filterExtraBy.length != 0) {
      bool labFilter = filterExtraBy == 'lab';
      bool onlineFilter = filterExtraBy == 'online';
      bool remsycFilter = filterExtraBy == 'remsyc';
      for (Class course in copy) {
        if (labFilter && !course.isLab) {
          filteredSet.remove(course);
        } else if (onlineFilter && course.room.toLowerCase() != 'online') {
          filteredSet.remove(course);
        } else if (remsycFilter && course.room.toLowerCase() != 'remsyc') {
          filteredSet.remove(course);
        }
      }
    }
  }

  void _filterSubject(Set filteredSet, Set copy) {
    _copySetFromTo(filteredSet, copy);
    if (filterSubjectBy != null && filterSubjectBy.length != 0) {
      for (Class course in copy) {
        if (course.subject != filterSubjectBy) {
          filteredSet.remove(course);
        }
      }
    }
  }

  void _filterTitle(Set filteredSet, Set copy) {
    _copySetFromTo(filteredSet, copy);
    if (filterTitleBy != null && filterTitleBy.length != 0) {
      for (Class course in copy) {
        if (!course.title.toLowerCase().contains(filterTitleBy)) {
          filteredSet.remove(course);
        }
      }
    }
  }

  List<String> getFilterComponents() {
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
    if (filterSubjectBy.length != 0) {
      res.add(filterSubjectBy);
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
    } else if (filterBy.toLowerCase() == 'subject') {
      filterSubjectBy = text;
    }
  }

  void removeFilter(String filterName) {
    if (filterCoreBy == filterName) {
      filterCoreBy = '';
    } else if (filterExtraBy == filterName) {
      filterExtraBy = '';
    } else if (filterSubjectBy == filterName) {
      filterSubjectBy = '';
    }

    applyFilter();
  }

  void resetFilter() {
    filterCoreBy = '';
    filterExtraBy = '';
    filterSubjectBy = '';
    notifyListeners();
  }

}