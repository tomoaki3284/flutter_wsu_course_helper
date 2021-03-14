import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/Model/ClassListFilter.dart';
import 'package:wsu_course_helper/View/ClassListPage/ClassListPage.dart';
import 'package:wsu_course_helper/constants.dart';

class CoursesGridView extends StatelessWidget {
  Widget progressbar = Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      strokeWidth: 10.0,
      valueColor: AlwaysStoppedAnimation(kPrimaryColor),
    ),
  );
  ClassList classes;

  @override
  Widget build(BuildContext context) {
    classes = Provider.of<ClassList>(context);
    Widget childWidget = classes == null || classes.classesBySubject.length == 0
        ? progressbar
        : gridView(context);

    return Container(
      child: childWidget,
    );
  }

  Widget gridView(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2.2),
      ),
      itemCount: classes.subjects.length,
      itemBuilder: (context, index) {
        return _buildSubjectCell(context, classes.subjects[index], classes);
      },
    );
  }

  Widget _buildSubjectCell(
      BuildContext context, String subjectAlias, ClassList classes) {
    var color = kColorBySubject[subjectAlias] == null
        ? 0xFF0F6AD7
        : kColorBySubject[subjectAlias];
    var image = kImageBySubject[subjectAlias] == null
        ? 'assets/images/BOOK.png'
        : kImageBySubject[subjectAlias];
    var subjectName = kSubjectByAlias[subjectAlias] == null
        ? subjectAlias
        : kSubjectByAlias[subjectAlias];

    ClassListFilter classListFilter =
        Provider.of<ClassListFilter>(context, listen: false);

    return GestureDetector(
      onTap: () {
        List<Class> subjectClasses = classes.classesBySubject[subjectAlias];
        classListFilter.init(subjectClasses);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClassListPage()),
        );
      },
      child: Container(
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
