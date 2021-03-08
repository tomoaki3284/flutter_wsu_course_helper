import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Model/AutoScheduler.dart';
import 'package:wsu_course_helper/Model/Mode.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:wsu_course_helper/View/SchedulePage/SchedulePage.dart';
import 'package:wsu_course_helper/constants.dart';

// ignore: must_be_immutable
class OptionsPage extends StatelessWidget {
  AutoScheduler autoScheduler;

  OptionsPage({@required this.autoScheduler});

  @override
  Widget build(BuildContext context) {
    assert(autoScheduler != null);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Options',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: kBackgroundColor,
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    if (autoScheduler.options.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: Text('no combination found'),
      );
    }

    return ListView.builder(
      itemCount: autoScheduler.options.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SchedulePage(
                  schedule: autoScheduler.options[index],
                  mode: Mode.NOT_EDITABLE,
                ),
              ),
            );
          },
          child: _buildOptionTile(index),
        );
      },
    );
  }

  Widget _buildOptionTile(int index) {
    Schedule option = autoScheduler.options[index];
    String imagePath = 'assets/images/option_schedule.png';

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
                      'Tap to see schedule detail',
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
                      option.name,
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
    );
  }
}
