import 'package:flutter/cupertino.dart';

import 'Class.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ClassList with ChangeNotifier {

  List<Class> _allClasses;
  Map<String, List<Class>> _classesBySubject = Map<String, List<Class>>();
  Map<String, List<Class>> _classesByTitle = Map<String, List<Class>>();

  fetchClasses() async {
    final String url = "https://wsucoursehelper.s3.amazonaws.com/current-semester.json";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable l = json.decode(response.body);
      List<Class> classes = List<Class>.from(l.map((model) => Class.fromJson(model)));
      _allClasses = classes;
      setClassesBySubject();
      setClassesByTitle();
      notifyListeners();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load json file from $url');
    }
  }

  List<Class> get allClasses => _allClasses;

  Map<String, List<Class>> get classesBySubject => _classesBySubject;

  Map<String, List<Class>> get classByTitle => _classesByTitle;

  void setClassesBySubject () {
    for (var course in _allClasses) {
      if (_classesBySubject.containsKey(course.subject)) {
        _classesBySubject[course.subject].add(course);
      } else {
        _classesBySubject[course.subject] = [course];
      }
    }
  }

  void setClassesByTitle () {
    for (var course in _allClasses) {
      if (_classesByTitle.containsKey(course.title)) {
        _classesByTitle[course.title].add(course);
      } else {
        _classesByTitle[course.title] = [course];
      }
    }
  }
}