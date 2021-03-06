import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wsu_course_helper/Model/AutoScheduler.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';

List<Class> getClassListFromTitle(String title, ClassList classList) {
  List<Class> res = [];
  bool found = false;
  for (Class course in classList.allClasses) {
    if (course.title == title) {
      found = true;
      res.add(course);
    } else if (found) {
      break;
    }
  }
  return res;
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // load sample data from local json file
  final String response =
      await rootBundle.loadString('assets/data/current-semester.json');
  Iterable l = await json.decode(response);
  List<Class> classes =
      List<Class>.from(l.map((model) => Class.fromJson(model)));
  ClassList classList = ClassList(classes: classes);

  // tests
  test('Testing function for tester', () {
    test_getClassLisrFromTitle(classList);
  });

  List<String> testSet1 = [
    'PRIN OF MICROECONOMICS',
    'GENERAL BIOLOGY II',
    'clazz',
    'INTRO COMPUTER PROGRAMMING',
  ];
  List<String> testSet2 = [
    'GLOBAL COMMUNICATION',
    'PRIN OF PUBLIC RELATIONS',
    'METHODS OF SCIENCE ED. PREK-6',
  ];
  List<String> testSet3 = [];
  test('Testing findAllClassesFromAbstract method in AutoScheduler.dart', () {
    test_findAllClassesFromAbstract(classList, testSet1);
    test_findAllClassesFromAbstract(classList, testSet2);
    test_findAllClassesFromAbstract(classList, testSet3);
  });
}

void test_getClassLisrFromTitle(classList) {
  expect(5, getClassListFromTitle('PRIN OF MICROECONOMICS', classList).length);
  expect(2, getClassListFromTitle('GENERAL BIOLOGY II', classList).length);
  expect(0, getClassListFromTitle('clazz', classList).length);
}

void test_findAllClassesFromAbstract(ClassList classList, List<String> titles) {
  // set up
  AutoScheduler autoScheduler = AutoScheduler(allClasses: classList.allClasses);
  List<List<Class>> expected = [];
  for (String title in titles) {
    expected.add(getClassListFromTitle(title, classList));
    autoScheduler.titleOfClassesConsideration.add(title);
  }

  autoScheduler.findAllClassesFromAbstract();

  expect(expected.length, autoScheduler.classesList.length);

  // compare
  for (int i = 0; i < autoScheduler.classesList.length; i++) {
    expect(expected[i].length, autoScheduler.classesList[i].length);
    for (int j = 0; j < autoScheduler.classesList[i].length; j++) {
      expect(expected[i][j], autoScheduler.classesList[i][j]);
    }
  }
}

void test_putCorrectLabClassesToClassesList() {}
