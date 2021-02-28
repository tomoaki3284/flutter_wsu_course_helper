import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Model/Class.dart';
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
    var classBlockHeight = size.height * 0.88;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildClassDetailBlock(classBlockHeight),
        _buildScheduleDropdownBlock(),
      ],
    );
  }

  Widget _buildClassDetailBlock(double height) {
    var classTileBlockHeight = 110.0;
    var fullHeight = height - classTileBlockHeight;

    var classTimeBlockHeight = fullHeight * 0.20;
    var classDescriptionBlockHeight = fullHeight * 0.35;
    var buttonsHeight = fullHeight * 0.15;

    return Container(
      height: fullHeight,
      margin: EdgeInsets.only(bottom: 10),
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
    );
  }

  Widget _buildClassDetails(String imagePath, String content) {
    return Container();
  }

  Widget _buildScheduleDropdownBlock() {
    return Flexible(
      flex: 1,
      child: Container(
        color: Colors.red,
      ),
    );
  }

  Widget _buildClassTimeBlock(double height) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 30, top: 10),
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
                      fontSize: 16,
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
      padding: EdgeInsets.only(left: 30),
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

  Widget _buttonsBlock(double height) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // todo: remove from focus schedule
            },
            child: WidgetUtils.buildGeneralButtonWidget('remove', Colors.red),
          ),
          GestureDetector(
            onTap: () {
              // todo: add to focus schedule
            },
            child: WidgetUtils.buildGeneralButtonWidget('add', kPrimaryColor),
          ),
        ],
      ),
    );
  }
}
