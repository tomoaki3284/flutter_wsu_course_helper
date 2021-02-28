import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';
import 'package:wsu_course_helper/WidgetUtils.dart';
import 'package:wsu_course_helper/constants.dart';

class ClassDetailPage extends StatelessWidget {
  final Class course;

  ClassDetailPage({@required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Detail'),
      ),
      backgroundColor: kBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // - 0.5 at the end for padding vertical on the parent. if not, 1 pixel overflow
    var classBlockHeight = size.height * 0.95;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildClassDetailBlock(context, classBlockHeight),
        _buildScheduleDropdownBlock(context),
      ],
    );
  }

  Widget _buildClassDetailBlock(BuildContext context, double height) {
    var classTileBlockHeight = 140.0;
    var fullHeight = height - classTileBlockHeight;

    var classTimeBlockHeight = fullHeight * 0.20;
    var classDescriptionBlockHeight = fullHeight * 0.35;
    var buttonsHeight = fullHeight * 0.15;

    return Container(
      height: fullHeight,
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildClassTileBlock(classTileBlockHeight),
          _buildClassTimeBlock(classTimeBlockHeight),
          _buildDescriptionBlock(classDescriptionBlockHeight),
          _buttonsBlock(context, buttonsHeight),
        ],
      ),
    );
  }

  Widget _buildClassTileBlock(double height) {
    return Container(
      height: height,
      padding: EdgeInsets.only(top: 15, bottom: 5, left: 15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Container(
                  child: Image.asset(kImageBySubject[course.subject]),
                ),
              ),
              Flexible(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      course.title,
                      style: TextStyle(
                        color: Color(0xFF7779A4),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildClassDetails(),
        ],
      ),
    );
  }

  Widget _buildClassDetails() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Row(
            // CRN, room, credit
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildClassDetailsTile(course.courseCRN, 'assets/images/crn.png'),
              _buildClassDetailsTile(course.room, 'assets/images/room.png'),
              _buildClassDetailsTile(
                  course.credit.toString(), 'assets/images/timer.png'),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            // professor, cores
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildClassDetailsTile(course.faculty, 'assets/images/user.png'),
              _buildClassDetailsTile(
                  course.getCoresString(), 'assets/images/c.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClassDetailsTile(String content, String imagePath) {
    return Flexible(
      // flex: content.length <= 3 ? 1 : 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Image.asset(
              imagePath,
              width: 14,
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(right: 5),
              child: Text(
                content,
                style: TextStyle(
                  color: Color(0xFF7779A4),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildClassTimeBlock(double height) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 30, top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Image.asset('assets/images/schedule.png'),
          ),
          Container(
            height: height,
            width: 250,
            child: ListView.builder(
              itemCount: course.getClassTimeOfEachDay().length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Text(
                    course.getClassTimeOfEachDay()[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kBlueTextColor,
                    ),
                  ),
                );
              },
              scrollDirection: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionBlock(double height) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 30, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Image.asset('assets/images/note.png'),
          ),
          Container(
            height: height - 10,
            width: 250,
            decoration: BoxDecoration(
              border: Border.all(color: kBlueTextColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(15, 5, 10, 10),
              scrollDirection: Axis.vertical,
              child: Text(
                course.classDescription,
                style: TextStyle(
                  height: 1.7,
                  fontSize: 15,
                  letterSpacing: 0.25,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonsBlock(BuildContext context, double height) {
    SchedulePool scheduleList =
        Provider.of<SchedulePool>(context, listen: false);
    bool haveClass = scheduleList.focusedSchedule.haveClass(course);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // remove button shouldn't be a option if schedule don't have the class
          if (haveClass)
            GestureDetector(
              onTap: () {
                scheduleList.removeClassFromTargetSchedule(
                    scheduleList.focusedSchedule.name, course);
              },
              child: WidgetUtils.buildGeneralButtonWidget('remove', Colors.red),
            ),
          GestureDetector(
            onTap: () {
              scheduleList.addClassToTargetSchedule(
                  scheduleList.focusedSchedule.name, course);
            },
            child: WidgetUtils.buildGeneralButtonWidget('add', kPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleDropdownBlock(BuildContext context) {
    SchedulePool scheduleList = Provider.of<SchedulePool>(context);

    return Flexible(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'In ${scheduleList.focusedSchedule.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kBlueTextColor,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'total credit: ${scheduleList.focusedSchedule.totalCredit}',
                    style: TextStyle(
                      color: kBlueTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  // todo: open bottom sheet to select focus schedule
                  _showBottomSheet(context);
                },
                child: Image.asset('assets/images/up_arrow.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- bottom sheet related --------------------

  void _showBottomSheet(BuildContext context) {
    SchedulePool schedulePool =
        Provider.of<SchedulePool>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext c) {
        return Container(
          height: 300,
          child: Column(
            // header, horizontal schedule ListView, add schedule button
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  'Set your working schedule',
                  style: TextStyle(
                    color: kBlueTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: schedulePool.scheduleByName.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (con, index) {
                    return _buildScheduleCell(index, schedulePool);
                  },
                ),
              ),
              _buildButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleCell(int index, SchedulePool scheduleList) {
    String key = scheduleList.scheduleByName.keys.elementAt(index);

    return GestureDetector(
      onTap: () {
        scheduleList.focusSchedule = scheduleList.scheduleByName[key];
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: 200,
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          scheduleList.scheduleByName[key].name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () {
        // todo: navigate to create new schedule dialog
      },
      child: Container(
        height: 40,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 5),
              ),
            ]),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'add new schedule',
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ),
    );
  }
}
