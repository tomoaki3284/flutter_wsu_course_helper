import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Model/Mode.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:wsu_course_helper/View/ClassDetailPage/ClassDetailPage.dart';
import 'package:wsu_course_helper/View/SharedView/ClassListTile.dart';
import 'package:wsu_course_helper/View/SharedView/ScheduledClassesHeader.dart';
import 'package:wsu_course_helper/View/SharedView/WeeklyTimelineBlock.dart';
import 'package:wsu_course_helper/constants.dart';

class OptionSchedulePage extends StatelessWidget {
  Schedule schedule;

  OptionSchedulePage({@required this.schedule});

  @override
  Widget build(BuildContext context) {
    assert(schedule != null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // tab button, week timeline, classes list
            children: <Widget>[
              WeeklyTimelineBlock(schedule: schedule),
              ScheduledClassesHeader(),
              _buildClassesListView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassesListView(BuildContext context) {
    return Container(
      height: 400,
      child: ListView.builder(
        itemCount: schedule.classes.length,
        itemBuilder: (c, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassDetailPage(
                    course: schedule.classes[index],
                    mode: Mode.NOT_EDITABLE,
                  ),
                ),
              );
            },
            child: ClassListTile(course: schedule.classes[index]),
          );
        },
      ),
    );
  }
}
