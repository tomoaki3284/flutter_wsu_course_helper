import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';
import 'package:wsu_course_helper/View/SharedView/ClassListTile.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // - 0.5 at the end for padding on the parent. if not, 1 pixel overflow
    var classBlockHeight = size.height*0.85 - 0.5;
    var scheduleDropdownHeight = size.height*0.15 - 0.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildClassDetailBlock(classBlockHeight),
        _buildScheduleDropdownBlock(scheduleDropdownHeight),
      ],
    );
  }

  Widget _buildClassDetailBlock(double height) {
    var classTileBlockHeight = 85.0;
    var fullHeight = height - classTileBlockHeight;
    var classTimeBlockHeight = fullHeight*0.25;
    var classDescriptionBlockHeight = fullHeight*0.35;
    var buttonsHeight = fullHeight*0.20;

    return Container(
      height: fullHeight,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildClassTileBlock(classTileBlockHeight),
          _buildClassTimeBlock(classTimeBlockHeight),
          _buildDescriptionBlock(classDescriptionBlockHeight),
          _buttonsBlock(buttonsHeight),
        ],
      ),
    );
  }

  Widget _buildClassTileBlock(double height) {
    return Container(
      height: height,
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      course.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF7779A4),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _buildClassDetails(
                            'assets/images/user.png', course.faculty),
                        _buildClassDetails('assets/images/timer.png',
                            course.credit.toString()),
                        _buildClassDetails(
                            'assets/images/c.png', course.getCoresString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassDetails(String imagePath, String content) {
    return Flexible(
      flex: content.contains('0') ? 2 : 3,
      child: Row(
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
              margin: EdgeInsets.only(right: 3),
              child: Text(
                content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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

  Widget _buildScheduleDropdownBlock(double height) {
    return Container(
      height: height,
      color: Colors.red
    );
  }

  Widget _buildClassTimeBlock(double height) {
    return Container(
      height: height,
      color: Colors.cyan,
    );
  }

  Widget _buildDescriptionBlock(double height) {
    return Container(
      height: height,

      color: kPrimaryColor,
    );
  }

  Widget _buttonsBlock(double height) {
    return Container(
      height: height,
      color: Colors.purple,
    );
  }
}
