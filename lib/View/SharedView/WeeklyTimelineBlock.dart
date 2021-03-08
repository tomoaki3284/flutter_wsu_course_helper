import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:wsu_course_helper/View/SchedulePage/ScheduleTimeLineBlock.dart';
import 'package:wsu_course_helper/constants.dart';

class WeeklyTimelineBlock extends StatefulWidget {
  final Schedule schedule;

  WeeklyTimelineBlock({@required this.schedule});

  @override
  _WeeklyTimelineBlockState createState() =>
      _WeeklyTimelineBlockState(schedule: schedule);
}

class _WeeklyTimelineBlockState extends State<WeeklyTimelineBlock> {
  Schedule schedule;
  int _selectedPage = 0;
  PageController _pageController;

  _WeeklyTimelineBlockState({@required this.schedule});

  @override
  void initState() {
    assert(schedule != null);
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScheduleTimeLine();
  }

  Widget _buildScheduleTimeLine() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
      child: Column(
        children: [
          _buildTabButtons(),
          _buildTabPage(),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TabButton(
            text: 'Mon',
            selectedPage: _selectedPage,
            pageNumber: 0,
            onPressed: () {
              _changePage(0);
            },
          ),
          TabButton(
            text: 'Tue',
            selectedPage: _selectedPage,
            pageNumber: 1,
            onPressed: () {
              _changePage(1);
            },
          ),
          TabButton(
            text: 'Wed',
            selectedPage: _selectedPage,
            pageNumber: 2,
            onPressed: () {
              _changePage(2);
            },
          ),
          TabButton(
            text: 'Thu',
            selectedPage: _selectedPage,
            pageNumber: 3,
            onPressed: () {
              _changePage(3);
            },
          ),
          TabButton(
            text: 'Fri',
            selectedPage: _selectedPage,
            pageNumber: 4,
            onPressed: () {
              _changePage(4);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabPage() {
    return Container(
      height: 400,
      child: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _selectedPage = page;
          });
        },
        children: <Widget>[
          ScheduleTimeLineBlock(
            classes: schedule.classesByWeekDay['MONDAY'] ?? [],
            dayOfWeek: 'MONDAY',
          ),
          ScheduleTimeLineBlock(
            classes: schedule.classesByWeekDay['TUESDAY'] ?? [],
            dayOfWeek: 'TUESDAY',
          ),
          ScheduleTimeLineBlock(
            classes: schedule.classesByWeekDay['WEDNESDAY'] ?? [],
            dayOfWeek: 'WEDNESDAY',
          ),
          ScheduleTimeLineBlock(
            classes: schedule.classesByWeekDay['THURSDAY'] ?? [],
            dayOfWeek: 'THURSDAY',
          ),
          ScheduleTimeLineBlock(
            classes: schedule.classesByWeekDay['FRIDAY'] ?? [],
            dayOfWeek: 'FRIDAY',
          ),
        ],
      ),
    );
  }

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final int selectedPage;
  final int pageNumber;
  final Function onPressed;

  TabButton(
      {@required this.text,
      @required this.selectedPage,
      @required this.pageNumber,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // if tab is selected, then indicate color to primary color, if not grey
    Color tabColor = selectedPage == pageNumber ? kPrimaryColor : Colors.grey;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(top: 25),
        child: Text(
          text ?? 'tab N',
          style: TextStyle(
            shadows: [
              Shadow(
                color: tabColor,
                offset: Offset(0, -6),
              )
            ],
            fontSize: 16,
            color: Colors.transparent,
            decoration: TextDecoration.underline,
            decorationColor: tabColor,
            decorationThickness: 1,
          ),
        ),
      ),
    );
  }
}
