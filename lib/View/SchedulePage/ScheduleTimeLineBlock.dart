import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/Hours.dart';
import 'package:wsu_course_helper/constants.dart';

class ScheduleTimeLineBlock extends StatelessWidget {
  final List<Class> classes;
  final String dayOfWeek;

  // height of an hour in timeline graph
  final double cellHeightPerHour = 80;

  // the timeline time begins at '7:00' so 7 here
  final double beginningTimeInTimeLine = 7;

  ScheduleTimeLineBlock({@required this.classes, @required this.dayOfWeek});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 20, right: 5, left: 5),
      child: SingleChildScrollView(
        child: Row(
          // timeline indicator, time cells container
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildTimeLineIndicator(),
            _buildTimeCellsContainer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeLineIndicator() {
    return Container(
        width: 40,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            _buildTime('7:00'),
            _buildTime('8:00'),
            _buildTime('9:00'),
            _buildTime('10:00'),
            _buildTime('11:00'),
            _buildTime('12:00'),
            _buildTime('13:00'),
            _buildTime('14:00'),
            _buildTime('15:00'),
            _buildTime('16:00'),
            _buildTime('17:00'),
            _buildTime('18:00'),
          ],
        ));
  }

  Widget _buildTime(String time) {
    return Container(
      alignment: Alignment.topLeft,
      height: cellHeightPerHour,
      child: Text(
        time,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildTimeCellsContainer(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.80;
    // time line is span of 7:00 to 19:00 (12 hrs diff)
    // container height should be the span diff * cell height per hour
    double height = 12.0 * cellHeightPerHour;

    return Container(
      alignment: Alignment.topLeft,
      width: width,
      // height =
      height: height,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: List<Widget>.generate(classes.length, (index) {
          return _buildTimeCell(index, width);
        }),
      ),
    );
  }

  // todo: if the class have more than two session a week, only display first one
  // so fix this to make it appear two of them.
  Widget _buildTimeCell(int index, double parentWidth) {
    Class course = classes[index];

    Color cellColor = kColorBySubject[course.subject] == null
        ? kPrimaryColor
        : Color(kColorBySubject[course.subject]);

    Hours hours = course.weeklyHours[dayOfWeek][0];
    int classStartHour = hours == null ? 0 : hours.startHour;
    int classStartMinute = hours == null ? 0 : hours.startMinute;

    // posY for placing time cell in correct position, posY = gap height from top
    // + 14.0 is for offset with timeline text. timeline text is not perfectly aligned
    // to the top left. It has offset of textHeight
    double posY = hours == null
        ? 0
        : (classStartHour - beginningTimeInTimeLine) * cellHeightPerHour +
        classStartMinute +
        14.0;

    // class cell height is (block height per hour * class time in hour)
    double cellHeight =
    hours == null ? 0 : hours.getInHourFloatFormat() * cellHeightPerHour;

    String cellName = course.title;
    String classTime = course.weeklyHours[dayOfWeek][0].getMilitaryTime();

    return Positioned(
      top: posY,
      left: 0,
      height: cellHeight,
      width: parentWidth - 20,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: cellColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                cellName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                classTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
