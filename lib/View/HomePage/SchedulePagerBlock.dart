import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/Mode.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';
import 'package:wsu_course_helper/Model/AppUser.dart';
import 'package:wsu_course_helper/View/SchedulePage/SchedulePage.dart';
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
      margin: EdgeInsets.only(top: 140, bottom: 35),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                _buildPageView(scheduleList),
                _buildDotIndicator(scheduleList),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(SchedulePool scheduleList) {
    return Container(
      height: 130,
      child: PageView.builder(
        itemCount:
            scheduleList == null ? 0 : scheduleList.scheduleByName.length,
        controller: _controller,
        itemBuilder: (context, index) {
          // if there is no schedule created by user, put some place holder
          if (scheduleList == null) {
            return _buildScheduleCell(null);
          } else {
            String key = scheduleList.scheduleByName.keys.elementAt(index);
            return _buildScheduleCell(scheduleList.scheduleByName[key]);
          }
        },
        onPageChanged: (index) {
          _currentPageNotifier.value = index;
        },
      ),
    );
  }

  /// parameter schedule is nullable
  Widget _buildScheduleCell(Schedule schedule) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SchedulePage(
                    schedule: schedule,
                    mode: Mode.EDITABLE,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.white,
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
  Widget _buildScheduleCellContent(Schedule schedule) {
    AppUser user = Provider.of<AppUser>(context);

    String scheduleName = "";
    String totalCredit = "";
    if (schedule == null) {
      scheduleName = 'No Schedule';
      totalCredit = 'None';
    } else {
      assert(schedule.name != null);
      assert(schedule.totalCredit != null);
      scheduleName = schedule.name;
      totalCredit = schedule.totalCredit.toString();
    }

    // maybe too expensive operation, this cell will build every time it slide
    bool scheduleOverlap = schedule.doesClassHoursOverlap();

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
                  child: Text(
                    scheduleName,
                    style: TextStyle(color: kPrimaryColor, fontSize: 18),
                  ),
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
                      Text(
                        'total credit: $totalCredit',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      Text(
                        'created by: ${user.username}',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 5,
          child: Container(
            alignment: Alignment.center,
            child: Image.asset(scheduleOverlap
                ? 'assets/images/schedule_no.png'
                : 'assets/images/schedule_yes.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildDotIndicator(SchedulePool scheduleList) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CirclePageIndicator(
          selectedDotColor: Colors.black,
          dotColor: Colors.grey,
          itemCount: scheduleList.scheduleByName.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }
}
