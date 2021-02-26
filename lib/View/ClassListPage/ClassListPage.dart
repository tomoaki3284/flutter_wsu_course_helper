import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/ClassListFilter.dart';
import 'package:wsu_course_helper/View/ClassDetailPage/ClassDetailPage.dart';
import 'package:wsu_course_helper/View/SharedView/ClassListTile.dart';

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
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              // todo : navigate to class detail page
              Class course = classListFilter.filteredClasses[index];
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClassDetailPage(course: course)),
              );
            },
            child: ClassListTile(course: classListFilter.filteredClasses[index]),
          ),
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

  SliverAppBar _buildBottomSliverAppBar(
      ClassListFilter classListFilter, BuildContext context) {
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
                classListFilter.resetFilter();
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
}
