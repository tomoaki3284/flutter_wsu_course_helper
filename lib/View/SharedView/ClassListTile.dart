import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Model/Class.dart';

import '../../constants.dart';

class ClassListTile extends StatelessWidget {
  final Class course;

  ClassListTile({@required this.course});

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width * 0.95;

    String imagePath = kImageBySubject[course.subject] == null ? 'assets/images/BOOK.png' : kImageBySubject[course.subject];

    return Container(
      width: width,
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
}
