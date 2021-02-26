import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/Model/ClassListFilter.dart';
import 'package:wsu_course_helper/constants.dart';

import 'FilterDialog.dart';

class ClassListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScrollable(context),
    );
  }

  Widget _buildScrollable(BuildContext context) {
    ClassListFilter classListFilter = Provider.of<ClassListFilter>(context);

    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) {
          return <Widget>[
            _buildTopSliverAppBar(),
            _buildBottomSliverAppBar(classListFilter, context),
            _buildChipBar(classListFilter),
          ];
        },
        body: ListView.builder(
          itemCount: classListFilter.filteredClasses.length,
          itemBuilder: (context, index) =>
              _buildClassListTile(classListFilter.filteredClasses[index]),
        ),
      ),
    );
  }

  SliverAppBar _buildTopSliverAppBar() {
    return SliverAppBar(
      floating: false,
      pinned: false,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: Text(
        'Courses',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }

  SliverAppBar _buildBottomSliverAppBar(ClassListFilter classListFilter, BuildContext context) {
    var size = MediaQuery.of(context).size;
    var searchBarWidth = size.width * 0.80;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      title: SizedBox(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildSearchBar(classListFilter, searchBarWidth),
            GestureDetector(
              onTap: () {
                // todo: open filter
                _showDialog(context);
              },
              child: Image.asset('assets/images/filter.png'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => FilterDialog());
  }

  Widget _buildSearchBar(ClassListFilter classListFilter, var searchBarWidth) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(1.1, 1.1),
              blurRadius: 5.0,
          ),
        ],
      ),
      child: SizedBox(
        width: searchBarWidth,
        child: CupertinoTextField(
          onSubmitted: (String val) {
            classListFilter.applyTitleFilter(val);
            print("$val : filter with this");
          },
          keyboardType: TextInputType.text,
          placeholder: 'Search',
          placeholderStyle: TextStyle(
            color: Color(0xffC4C6CC),
            fontSize: 14.0,
            fontFamily: 'Brutal',
          ),
          prefix: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 5.0),
            child: Icon(
              Icons.search,
              size: 18,
              color: Colors.black,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildChipBar(ClassListFilter classListFilter) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: _buildFilterChips(classListFilter),
    );
  }

  Widget _buildFilterChips(ClassListFilter classListFilter) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List<Widget>.generate(
            classListFilter.getFilterComponents().length, (index) {
          return Chip(
            label: Text(classListFilter.getFilterComponents()[index]),
            onDeleted: () {
              classListFilter
                  .removeFilter(classListFilter.getFilterComponents()[index]);
            },
          );
        }),
      ),
    );
  }

  Widget _buildClassListTile(Class course) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
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
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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

  //todo
  Widget _buildSliverAppBarContent() {
    return Placeholder();
  }
}
