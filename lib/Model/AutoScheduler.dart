import 'package:wsu_course_helper/Logger.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:flutter/material.dart';

class AutoScheduler {
  final List<Class> allClasses;

  // list of class title that user want to auto-schedule it
  List<String> titleOfClassesConsideration = [];

  List<List<Class>> classesList = [];

  // {
  //    'GENERAL BIOLOGY II' :
  //             [
  //              {GENERAL BIOLOGY II - Lab (001)},
  //              {GENERAL BIOLOGY II - Lab (001)}
  //             ],
  //    'BIOLOGY I' :
  //             [...]
  // } something like this
  Map<String, List<Class>> labBindMap = {};

  List<Schedule> options = [];

  bool labRequire = false;
  int numOfLabClass = 0;

  AutoScheduler({@required this.allClasses}) {
    initLabBindMap();
  }

  void startAutoSchedule() {
    /**
     * Way to implement lab auto binding:
     * detect if considerations contains any class that requires lab.
     * if do, set bool labRequire = true, count number of classes that require
     * lab. Most likely 1, but who knows, some crazy ppl might take many classes
     * that requires lab.

        if labRequire, then open/add lab courses space to go into coursesList
        -> just add space at the tail of the classesList (*1)
        then while backtracking, if encounter class that requires lab,
        just set it into the lab space that have been added
     */

    Logger.LogDetailed(
        'AutoScheduler.dart', 'startAutoSchedule', 'method called');

    findAllClassesFromAbstract();

    // if more then one class require lab, then I need to somehow
    // keep track of which class lab goes into which index in classesList
    // so use Map 'labIdxByClassTitle' for this
    Map<String, int> labIdxByClassTitle = {};

    // detect if any class that user want to take require lab
    // and count how many class require lab. Most likely 1
    numOfLabClass = 0;
    for (String classTitle in titleOfClassesConsideration) {
      if (labBindMap.containsKey(classTitle)) {
        numOfLabClass++;
        // -> to add space at the tail of the classesList (*1)
        //    gotta assign proper tail value here, list length + numOfLabClass.
        //    -1 because 0-based index.
        labIdxByClassTitle[classTitle] = classesList.length - 1 + numOfLabClass;
        labRequire = true;
      }
    }

    // open/add space in classesList for labClasses to go in. (*1)
    while (numOfLabClass != 0) {
      classesList.add([]);
      numOfLabClass--;
    }

    // start processing
    backtrack(0, new Schedule(name: "name doesn't matter"), classesList.length,
        labIdxByClassTitle);
    Logger.LogDetailed(
        'AutoScheduler.dart', 'startAutoSchedule', 'finish computing!');
  }

  /// bind correct lab class and lecture class that requires the lab class
  /// based on class title map with list of lab class
  void initLabBindMap() {
    // todo: do lab binding
    /**
     * Pattern:
     * There are some rule on lecture class and corresponded lab class:
     *
     *    1. lecture and lab needs to have same section #
     *          e.g. GEN CHEMISTRY I (section-001) correspond lab is LAB (01%)
     *               GEN CHEMISTRY I (section-00N) correspond lab is LAB (0N%)
     *
     *    2. but there is a exception: some lecture can be bind with any labs.
     *       if it follows below pattern, then it falls down to this category.
     *          e.g. GENERAL BIOLOGY II (section-001), can bind with LAB (0L%)
     *               if LAB has section (0L%), it means LAB doesn't have specific
     *               section #, so it doesn't have constraints.
     *
     * For more details, visit WSU course web:
     *  - [https://www.westfield.ma.edu/offices/registrar/master-schedule]
     *
     *
     */
    assert(allClasses != null && allClasses.length != 0);
    assert(labBindMap != null);

    labBindMap = {};

    String prevTitle = allClasses[0].title;
    for (int i = 1; i < allClasses.length; i++) {
      Class course = allClasses[i];
      String currTitle = course.title;
      if (course.isLab) {
        // if curr course is lab, then prev subject classes require lab class
        if (labBindMap.containsKey(prevTitle)) {
          // so add the lab course in list
          labBindMap[prevTitle].add(course);
        } else {
          labBindMap[prevTitle] = [course];
        }
      } else {
        // if curr course is not lab, then do normal process
        prevTitle = currTitle;
      }
    }
  }

  /// Generate a list of classes from abstract consideration (list of class title),
  /// [[Eng,Eng,Eng],[Math,Math,Math,Math],[Env,Env]], something like this
  void findAllClassesFromAbstract() {
    assert(classesList != null);

    for (String chosenClassTitle in titleOfClassesConsideration) {
      List<Class> groupClass = [];
      for (Class course in allClasses) {
        if (course.title == chosenClassTitle) {
          if (!course.isCancelled) {
            groupClass.add(course);
          }
        }
      }
      classesList.add(groupClass);
    }
  }

  void putCorrectLabClassesToClassesList(
      Class course, Map<String, int> labIdxByClassTitle) {
    // if it is right lab course, then it should contains normal course name in prefix

    // iterate lab-bind-map
    // if anything in consideration match with lab title, then add lab class to classesList
    // but the section # need to match

    String classTitle = course.title;
    String classSectionNumber = course.getSectionNumber();
    List<Class> labClasses = labBindMap[classTitle];

    List<Class> correctLabClasses = [];
    for (Class labClass in labClasses) {
      String labSectionNumber = labClass.getSectionNumber();
      if (labSectionNumber == classSectionNumber || labSectionNumber == 'L') {
        // see if section number match, if so add this to correct lab classes
        correctLabClasses.add(labClass);
      }
    }

    assert(labIdxByClassTitle[classTitle] != null);
    classesList[labIdxByClassTitle[classTitle]] = correctLabClasses;
  }

  void backtrack(int idx, Schedule aSchedule, int desireScheduleSize,
      Map<String, int> labIdxByClassTitle) {
    if (aSchedule.classes.length == desireScheduleSize) {
      // if any class hours overlap, then don't put it into the option
      if (aSchedule.doesClassHoursOverlap()) {
        return;
      }
      options.add(new Schedule(
          classes: aSchedule.classes, name: "Option ${options.length + 1}"));
      return;
    }

    for (int i = 0; i < classesList[idx].length; i++) {
      Class course = classesList[idx][i];
      if (labBindMap.containsKey(course.title)) {
        // if lab class
        putCorrectLabClassesToClassesList(course, labIdxByClassTitle);
      }
      aSchedule.addClass(course);
      backtrack(idx + 1, aSchedule, desireScheduleSize, labIdxByClassTitle);
      aSchedule.removeClass(aSchedule.classes[aSchedule.classes.length - 1]);
    }
  }
}
