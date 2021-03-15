import 'package:flutter/material.dart';
import 'package:wsu_course_helper/View/HomePage/CoursesGridView.dart';
import 'package:wsu_course_helper/View/HomePage/FeaturesGridView.dart';
import 'package:wsu_course_helper/View/HomePage/ScheduleListView.dart';

class HomeCategoryTabs extends StatefulWidget {
  @override
  _HomeCategoryTabsState createState() => _HomeCategoryTabsState();
}

class _HomeCategoryTabsState extends State<HomeCategoryTabs> {
  int _selectedPage = 0;
  PageController _pageController;

  @override
  void initState() {
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
    double topSpacing = 120;
    Size size = MediaQuery.of(context).size;
    double height = size.height - topSpacing - 30;

    return Container(
      height: height,
      margin: EdgeInsets.only(right: 10, left: 10, top: topSpacing, bottom: 10),
      child: Column(
        children: <Widget>[
          _buildTabButtons(),
          _buildTabPage(context),
        ],
      ),
    );
  }

  Widget _buildTabButtons() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TabButton(
            text: 'Course',
            selectedPage: _selectedPage,
            pageNumber: 0,
            onPressed: () {
              _changePage(0);
            },
          ),
          TabButton(
            text: 'Feature',
            selectedPage: _selectedPage,
            pageNumber: 1,
            onPressed: () {
              _changePage(1);
            },
          ),
          TabButton(
            text: 'Schedule',
            selectedPage: _selectedPage,
            pageNumber: 2,
            onPressed: () {
              _changePage(2);
            },
          ),
          TabButton(
            text: 'Major',
            selectedPage: _selectedPage,
            pageNumber: 3,
            onPressed: () {
              _changePage(3);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabPage(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _selectedPage = page;
          });
        },
        children: <Widget>[
          CoursesGridView(),
          FeaturesGridView(),
          ScheduleListView(),
          Placeholder(),
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
    Color tabColor = selectedPage == pageNumber ? Colors.white : Colors.grey;

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
            decorationThickness: 1.5,
          ),
        ),
      ),
    );
  }
}
