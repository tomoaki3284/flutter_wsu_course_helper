import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';
import 'package:wsu_course_helper/View/ClassDetailPage/ClassDetailPage.dart';
import 'package:wsu_course_helper/View/SharedView/ScheduledClassesHeader.dart';
import 'package:wsu_course_helper/View/SharedView/WeeklyTimelineBlock.dart';
import 'package:wsu_course_helper/View/SharedView/ClassListTile.dart';
import 'package:wsu_course_helper/constants.dart';

class SchedulePage extends StatefulWidget {
  final Schedule schedule;

  SchedulePage({@required this.schedule});

  @override
  _SchedulePageState createState() => _SchedulePageState(schedule: schedule);
}

class _SchedulePageState extends State<SchedulePage> {
  final Schedule schedule;

  _SchedulePageState({@required this.schedule});

  @override
  void initState() {
    assert(schedule != null);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    SchedulePool scheduleList = Provider.of<SchedulePool>(context);

    return Container(
      height: 400,
      child: ListView.builder(
        itemCount: schedule.classes.length,
        itemBuilder: (c, index) {
          return GestureDetector(
            onTap: () {
              scheduleList.focusSchedule = schedule;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ClassDetailPage(course: schedule.classes[index]),
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
