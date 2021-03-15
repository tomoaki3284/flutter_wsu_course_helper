import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/AppUser.dart';
import 'package:wsu_course_helper/Model/Mode.dart';
import 'package:wsu_course_helper/Model/Schedule.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';
import 'package:wsu_course_helper/View/SchedulePage/SchedulePage.dart';
import 'package:wsu_course_helper/constants.dart';

class ScheduleListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SchedulePool scheduleList = Provider.of<SchedulePool>(context);

    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (scheduleList == null) {
            return _buildScheduleCellContent(context, null);
          } else {
            String key = scheduleList.scheduleByName.keys.elementAt(index);
            return _buildScheduleCellContent(
                context, scheduleList.scheduleByName[key]);
          }
        },
        itemCount: scheduleList.scheduleByName.length,
      ),
    );
  }

  /// parameter schedule is nullable
  Widget _buildScheduleCellContent(BuildContext context, Schedule schedule) {
    AppUser user = Provider.of<AppUser>(context);

    String scheduleName = "";
    String totalCredit = "";
    if (schedule == null) {
      scheduleName = 'No Schedule';
      totalCredit = 'None';
    } else {
      assert(schedule.name != null);
      assert(schedule.totalCredit != null);
      scheduleName = schedule.name;
      totalCredit = schedule.totalCredit.toString();
    }

    bool scheduleOverlap = schedule.doesClassHoursOverlap();

    Color textColor = Colors.white;

    return GestureDetector(
      onTap: () {
        if (schedule == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SchedulePage(
                    schedule: schedule,
                    mode: Mode.EDITABLE,
                  )),
        );
      },
      child: Container(
        height: 130,
        margin: EdgeInsets.only(bottom: 15, right: 5, left: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(3, 7),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 6,
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        scheduleName,
                        style: TextStyle(color: textColor, fontSize: 18),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'total credit: $totalCredit',
                            style: TextStyle(color: textColor),
                          ),
                          Text(
                            'created by: ${user.username}',
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(scheduleOverlap
                    ? 'assets/images/schedule_no.png'
                    : 'assets/images/schedule_yes.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
