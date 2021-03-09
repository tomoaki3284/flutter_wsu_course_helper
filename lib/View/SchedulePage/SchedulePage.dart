import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/Mode.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';
import 'package:wsu_course_helper/View/ClassDetailPage/ClassDetailPage.dart';
import 'package:wsu_course_helper/View/SharedView/ClassListTile.dart';
import 'package:wsu_course_helper/View/SharedView/ScheduledClassesHeader.dart';
import 'package:wsu_course_helper/View/SharedView/WeeklyTimelineBlock.dart';
import 'package:wsu_course_helper/WidgetUtils.dart';
import 'package:wsu_course_helper/constants.dart';

class SchedulePage extends StatefulWidget {
  final Schedule schedule;
  final Mode mode;

  SchedulePage({@required this.schedule, @required this.mode});

  @override
  _SchedulePageState createState() =>
      _SchedulePageState(schedule: schedule, mode: mode);
}

class _SchedulePageState extends State<SchedulePage> {
  final Schedule schedule;
  final Mode mode;

  _SchedulePageState({@required this.schedule, @required this.mode});

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
    SchedulePool schedulePool =
        Provider.of<SchedulePool>(context, listen: false);

    Widget actionAdd = Container();
    if (mode == Mode.NOT_EDITABLE) {
      // it means this schedule is not created by user, so make it addable
      actionAdd = GestureDetector(
        onTap: () {
          bool valid = schedulePool.directlyAddSchedule(schedule);
          if (valid) {
            WidgetUtils.showToast('added to your schedules', 2, context);
          } else {
            WidgetUtils.showToast(
                'conflict: same schedule name exist', 2, context);
          }
        },
        child: Image.asset('assets/images/plus.png'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        actions: [
          actionAdd,
        ],
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
              if (mode == Mode.EDITABLE) {
                scheduleList.focusSchedule = schedule;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassDetailPage(
                      course: schedule.classes[index], mode: mode),
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
