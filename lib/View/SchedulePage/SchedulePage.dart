import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:wsu_course_helper/View/SchedulePage/ScheduleTimeLineBlock.dart';
import 'package:wsu_course_helper/constants.dart';

class SchedulePage extends StatefulWidget {
  final Schedule schedule;

  SchedulePage({@required this.schedule});

  @override
  _SchedulePageState createState() => _SchedulePageState(schedule: schedule);
}

class _SchedulePageState extends State<SchedulePage> {
  final Schedule schedule;
  int _selectedPage = 0;

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
              _buildScheduleTimeLine(),
              _buildClassesListView(),
            ],
          ),
        ),
      ),
    );
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

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
    });
  }

  Widget _buildTabButtons() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget _buildClassesListView() {
    return Container(
      color: Colors.cyan,
      height: 400,
    );
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
        margin: EdgeInsets.only(top: 20),
        child: Text(
          text ?? 'tab N',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: tabColor,
          ),
        ),
      ),
    );
  }
}
