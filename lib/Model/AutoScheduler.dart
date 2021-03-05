import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:flutter/material.dart';

class AutoScheduler {
  final List<Class> allClasses;

  // list of class title that user want to auto-schedule it
  List<String> titleOfClassesConsideration = [];

  List<List<Class>> classesList = [];
  Map<String, List<Class>> labBindMap = {};
  List<Schedule> options = [];

  AutoScheduler({@required this.allClasses}) {
    initLabBindMap();
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
  }

  /// Generate a list of classes from abstract consideration (list of class title),
  /// [[Eng,Eng,Eng],[Math,Math,Math,Math],[Env]], something like this
  void findAllClassesFromAbstract() {
    // todo: find all classes from consideration
  }

  void putCorrectLabClassesToConsideration(String classTitle) {
    // todo: put correct lab classes to consideration
    // if it is right lab course, then it should contains normal course name in prefix
  }

  void backtrack() {
    // todo: find combinations of options that doesn't make time overlap
  }
}
