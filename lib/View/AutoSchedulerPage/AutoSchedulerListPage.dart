import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:wsu_course_helper/Logger.dart';
import 'package:wsu_course_helper/Model/AutoScheduler.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/Model/ClassListFilter.dart';
import 'package:wsu_course_helper/View/AutoSchedulerPage/ConsiderationBottomSheet.dart';
import 'package:wsu_course_helper/View/ClassListPage/FilterDialog.dart';
import 'package:wsu_course_helper/constants.dart';

// ignore: must_be_immutable
class AutoSchedulerListPage extends StatelessWidget {
  AutoScheduler autoScheduler;
  ClassList classList;
  ClassListFilter classListFilter;

  @override
  Widget build(BuildContext context) {
    Logger.LogDetailed(
        'AutoSchedulerListPage.dart', 'build', 'building entire widget');

    classList = Provider.of<ClassList>(context, listen: false);
    autoScheduler = new AutoScheduler(allClasses: classList.allClasses);

    // don't listen here
    classListFilter = Provider.of<ClassListFilter>(context, listen: false);
    classListFilter.init(classList.uniqueTitleClasses.toList());

    assert(classList != null);
    assert(autoScheduler != null);
    assert(classListFilter != null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Consideration'),
        actions: [
          IconButton(
            icon: Image.asset('assets/images/filter.png'),
            onPressed: () {
              classListFilter.resetFilter();
              _showDialog(context);
            },
          ),
        ],
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return Consumer<ClassListFilter>(
      builder: (context, classListFilter, _) => Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: classListFilter.filteredClasses.length,
                itemBuilder: (context, index) {
                  return _buildClassRow(
                      index, classListFilter.filteredClasses, context);
                },
              ),
            ),
            _buildComputeButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildComputeButton(BuildContext context) {
    return Container(
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              // todo: compute and navigate to options
            },
            icon: Image.asset('assets/images/puzzle.png'),
            label: Text('build schedule'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // todo: show list in bottom page
              _showBottomSheet(context);
            },
            icon: Image.asset('assets/images/list.png'),
            label: Text('your selection'),
          )
        ],
      ),
    );
  }

  Widget _buildClassRow(int index, List<Class> classes, BuildContext context) {
    Class course = classes[index];
    String imagePath =
        kImageBySubject[course.subject] ?? 'assets/images/BOOK.png';

    return GestureDetector(
      onTap: () {
        _showAddDialog(context, course.title);
      },
      child: Container(
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
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                child: Image.asset(imagePath),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // subject, title
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 2),
                      child: Text(
                        course.subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF7779A4),
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2, bottom: 5),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => FilterDialog());
  }

  void _showAddDialog(BuildContext context, String classTitle) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add'),
        content: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Do you want to add\n\n',
              ),
              TextSpan(
                text: '\"$classTitle\"',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: '\n\ninto selection?',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              bool success = autoScheduler.addToConsideration(classTitle);
              if (!success) {
                showToast('You already added this class', 2, context);
              }
              goBackScreen(context);
            },
            child: Text('Yes'),
          ),
          ElevatedButton(
            onPressed: () {
              goBackScreen(context);
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context) {
      return ConsiderationBottomSheet(autoScheduler: autoScheduler);
    });
  }

  void goBackScreen(BuildContext context) {
    return Navigator.of(context).pop(true);
  }

  void showToast(String msg, int duration, BuildContext context) {
    Toast.show(msg, context, duration: duration, gravity: Toast.BOTTOM);
  }
}
