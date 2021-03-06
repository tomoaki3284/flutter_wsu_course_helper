import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wsu_course_helper/Model/AutoScheduler.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';

import 'TestSets/AutoSchedulerTestSet.dart';

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

  test('Testing findAllClassesFromAbstract method in AutoScheduler.dart', () {
    test_findAllClassesFromAbstract(classList, tTestSet1_1);
    test_findAllClassesFromAbstract(classList, tTestSet1_2);
    test_findAllClassesFromAbstract(classList, tTestSet1_3);
  });

  test('Testing putCorrectLabClassesToClassesList in AutoScheduler.dart', () {
    test_putCorrectLabClassesToClassesList(classList, tTestSet2_2);
  });
}

void test_getClassLisrFromTitle(classList) {
  expect(5, getClassListFromTitle('PRIN OF MICROECONOMICS', classList).length);
  expect(2, getClassListFromTitle('GENERAL BIOLOGY II', classList).length);
  expect(0, getClassListFromTitle('clazz', classList).length);
}

AutoScheduler setup(classList, titles) {
  AutoScheduler autoScheduler = AutoScheduler(allClasses: classList.allClasses);
  for (String title in titles) {
    autoScheduler.titleOfClassesConsideration.add(title);
  }

  autoScheduler.findAllClassesFromAbstract();
  autoScheduler.initLabBindMap();
  return autoScheduler;
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

void test_putCorrectLabClassesToClassesList(classList, List<String> titles) {
  AutoScheduler autoScheduler = setup(classList, titles);
  for (int i = 0; i < titles.length; i++) {
    String title = titles[i];
    // gotta open up spaces for lab courses to go in
    autoScheduler.classesList.add([]);
    for (Class course in autoScheduler.classesList[i]) {
      // test set only contains lab classes, for now
      assert(autoScheduler.labBindMap.containsKey(title));
      List<String> expectLabClassCRNs =
          tExpectSetsBySectionNumber2_2[course.getSectionNumber()];
      autoScheduler.putCorrectLabClassesToClassesList(course, {title: 1});
      List<String> outputLabClassCRNs = [];
      for (Class labClass in autoScheduler.classesList[1]) {
        outputLabClassCRNs.add(labClass.courseCRN);
      }

      expect(outputLabClassCRNs, expectLabClassCRNs);
    }
  }
}
