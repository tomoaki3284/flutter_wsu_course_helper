import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../Logger.dart';
import 'Class.dart';

class ClassList with ChangeNotifier {
  List<Class> _allClasses;
  Map<String, List<Class>> _classesBySubject = Map<String, List<Class>>();
  Map<String, List<Class>> _classesByTitle = Map<String, List<Class>>();
  List<String> _subjects = [];

  Set<Class> uniqueTitleClasses = {};

  ClassList({classes}) {
    // for unit test
    if (classes != null) {
      _allClasses = classes;
      init();
    }
  }

  fetchClasses() async {
    Logger.LogDetailed('ClassList.dart', 'fetchClasses', 'start fetching');

    final String url =
        "https://wsucoursehelper.s3.amazonaws.com/current-semester.json";
    final Response response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable l = json.decode(response.body);
      List<Class> classes =
      List<Class>.from(l.map((model) => Class.fromJson(model)));
      _allClasses = classes;
      init();
      notifyListeners();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load json file from $url');
    }
  }

  init() {
    assert(_allClasses != null);
    setClassesBySubject();
    setClassesByTitle();
    setSubjectsList();
    setUniqueTitleClasses();
  }

  List<Class> get allClasses => _allClasses;

  Map<String, List<Class>> get classesBySubject => _classesBySubject;

  Map<String, List<Class>> get classByTitle => _classesByTitle;

  List<String> get subjects => _subjects;

  void setSubjectsList() {
    for (String subject in _classesBySubject.keys) {
      if (subject == null || subject.length == 0 || subject == 'Lab') {
        continue;
      }
      _subjects.add(subject);
    }

    _subjects.sort((a, b) => a.compareTo(b));
    // for all classes list
    _subjects.remove('All');
    _subjects.insert(0, 'All');
  }

  void setClassesBySubject() {
    // for all classes list
    _classesBySubject['All'] = _allClasses;

    for (var course in _allClasses) {
      if (_classesBySubject.containsKey(course.subject)) {
        _classesBySubject[course.subject].add(course);
      } else {
        _classesBySubject[course.subject] = [course];
      }
    }
  }

  void setClassesByTitle() {
    for (var course in _allClasses) {
      if (_classesByTitle.containsKey(course.title)) {
        _classesByTitle[course.title].add(course);
      } else {
        _classesByTitle[course.title] = [course];
      }
    }
  }

  void setUniqueTitleClasses() {
    // exclude lab class from this, since auto lab-binding is on by default in auto-scheduler
    Set<String> titleSeen = Set<String>();
    for (Class course in allClasses) {
      if (titleSeen.contains(course.title) || course.isLab) {
        continue;
      } else {
        uniqueTitleClasses.add(course);
      }
      titleSeen.add(course.title);
    }
  }
}
