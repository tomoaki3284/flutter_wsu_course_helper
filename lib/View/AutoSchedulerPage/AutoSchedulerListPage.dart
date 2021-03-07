import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/AutoScheduler.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/constants.dart';

// ignore: must_be_immutable
class AutoSchedulerListPage extends StatelessWidget {
  AutoScheduler autoScheduler;
  ClassList classList;

  @override
  Widget build(BuildContext context) {
    classList = Provider.of<ClassList>(context, listen: false);
    autoScheduler = new AutoScheduler(allClasses: classList.allClasses);

    assert(classList != null);
    assert(autoScheduler != null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Consideration'),
      ),
      body: SafeArea(
        child: body(context),
      ),
    );
  }

  Widget body(BuildContext context) {
    Set<Class> classSet = classList.uniqueTitleClasses;

    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: classSet.length,
              itemBuilder: (context, index) {
                return _buildClassRow(index, classSet);
              },
            ),
          ),
          _buildComputeButton(),
        ],
      ),
    );
  }

  Widget _buildComputeButton() {
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
            },
            icon: Image.asset('assets/images/list.png'),
            label: Text('your selection'),
          )
        ],
      ),
    );
  }

  Widget _buildClassRow(int index, Set<Class> classSet) {
    Class course = classSet.elementAt(index);
    String imagePath =
        kImageBySubject[course.subject] ?? 'assets/images/BOOK.png';

    return GestureDetector(
      onTap: () {
        autoScheduler.titleOfClassesConsideration.add(course.title);
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
}
