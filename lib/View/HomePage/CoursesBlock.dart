import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/Model/ClassListFilter.dart';
import 'package:wsu_course_helper/View/ClassListPage/ClassListPage.dart';
import 'package:wsu_course_helper/View/SharedView/GeneralHeader.dart';
import 'package:wsu_course_helper/constants.dart';

class CoursesBlock extends StatelessWidget {
  Widget progressbar = CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GeneralHeader(title: 'Courses'),
        _buildCoursesListView(context),
      ],
    );
  }

  Widget _buildCoursesListView(BuildContext context) {
    return Consumer<ClassList>(
      builder: (context, classes, _) => Container(
        height: 125,
        child: ListView.builder(
          itemCount: classes == null ? 0 : classes.subjects.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext ctxt, int index) {
            return _buildSubjectCell(ctxt, classes.subjects[index], classes);
          },
        ),
      ),
    );
  }

  Widget _buildSubjectCell(BuildContext context, String subjectAlias, ClassList classes) {
    var color = kColorBySubject[subjectAlias] == null
        ? 0xFF0F6AD7
        : kColorBySubject[subjectAlias];
    var image = kImageBySubject[subjectAlias] == null
        ? 'assets/images/BOOK.png'
        : kImageBySubject[subjectAlias];
    var subjectName = kSubjectByAlias[subjectAlias] == null
        ? subjectAlias
        : kSubjectByAlias[subjectAlias];

    ClassListFilter classListFilter = Provider.of<ClassListFilter>(context, listen: false);
    
    return GestureDetector(
      onTap: () {
        // todo: navigate to ClassListPage
        List<Class> subjectClasses = classes.classesBySubject[subjectAlias];
        classListFilter.init(subjectClasses);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClassListPage()),
        );
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Color(color),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(3, 7),
            ),
          ],
        ),
        margin: EdgeInsets.only(left: 15, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(image),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Text(
              subjectName,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
