import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';

class ScheduleTimeLineBlock extends StatelessWidget {
  final List<Class> classes;
  final String dayOfWeek;

  ScheduleTimeLineBlock({@required this.classes, @required this.dayOfWeek});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '$dayOfWeek: ${classes.toString()}',
      ),
    );
  }
}
