import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';
import 'package:wsu_course_helper/Model/User.dart';
import 'package:wsu_course_helper/View/GeneralHeader.dart';
import 'package:wsu_course_helper/constants.dart';

class SchedulePagerBlock extends StatefulWidget {
  @override
  _SchedulePagerBlockState createState() => _SchedulePagerBlockState();
}

class _SchedulePagerBlockState extends State<SchedulePagerBlock> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    SchedulePool scheduleList = Provider.of<SchedulePool>(context);

    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 35, bottom: 20),
        child: Column(
          children: <Widget>[
            GeneralHeader(title: 'Your Schedules'),
            Stack(
              children: <Widget>[
                _buildPageView(scheduleList),
                _buildDotIndicator(scheduleList),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView(SchedulePool scheduleList) {
    return Container(
      height: 200,
      child: PageView.builder(
        itemCount: scheduleList == null ? 0 : scheduleList.scheduleByName.length,
        controller: _controller,
        itemBuilder: (context, index){
          // if there is no schedule created by user, put some place holder
          if (scheduleList == null) {
            return _buildScheduleCell(null);
          } else {
            String key = scheduleList.scheduleByName.keys.elementAt(index);
            return _buildScheduleCell(scheduleList.scheduleByName[key]);
          }
        },
        onPageChanged: (index){
          _currentPageNotifier.value = index;
        },
      ),
    );
  }

  /// parameter schedule is nullable
  Widget _buildScheduleCell(Schedule schedule) {
    return Center(
      child: Container(
        height: 150,
        width: 325,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.deepPurple,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(3, 7),
            ),
          ],
        ),
        child: _buildScheduleCellContent(schedule),
      ),
    );
  }

  /// parameter schedule is nullable
  Widget _buildScheduleCellContent (Schedule schedule) {
    User user = Provider.of<User>(context);

    String scheduleName = "";
    String totalCredit = "";
    if (schedule == null) {
      scheduleName = 'No Schedule';
      totalCredit = 'None';
    } else {
      scheduleName = schedule.name;
      totalCredit = schedule.totalCredit.toString();
    }

    return Row(
      children: <Widget>[
        Flexible(
          flex: 5,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 6,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(scheduleName, style: TextStyle(color: Colors.white, fontSize: 18),),
                ),
              ),
              Flexible(
                flex: 4,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('total credit: $totalCredit', style: TextStyle(color: Colors.white),),
                      Text('created by: ${user.username}', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 5,
          // todo: change this to proper image
          child: Container(
            alignment: Alignment.center,
            child: Image.asset('assets/images/BOOK.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildDotIndicator(SchedulePool scheduleList) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          selectedDotColor: kPrimaryColor,
          dotColor: Colors.grey,
          itemCount: scheduleList.scheduleByName.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }
}

