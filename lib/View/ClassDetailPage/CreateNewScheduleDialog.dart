import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';
import 'package:wsu_course_helper/WidgetUtils.dart';
import 'package:wsu_course_helper/constants.dart';

class CreateNewScheduleDialog extends StatefulWidget {
  @override
  _CreateNewScheduleDialogState createState() =>
      _CreateNewScheduleDialogState();
}

class _CreateNewScheduleDialogState extends State<CreateNewScheduleDialog> {
  final textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    SchedulePool scheduleList =
        Provider.of<SchedulePool>(context, listen: false);

    return Container(
      height: 250,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 30, bottom: 30),
            child: Text(
              'Create new schedule',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30, right: 15, left: 15),
            child: TextField(
              controller: textFieldController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'new schedule name'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  goBackScreen(context);
                },
                child:
                    WidgetUtils.buildGeneralButtonWidget('cancel', Colors.red),
              ),
              GestureDetector(
                onTap: () {
                  bool valid = scheduleList.addSchedule(textFieldController.text);
                  if (!valid) {
                    showToast('same name exist/invalid name', 3);
                  } else {
                    showToast('created new schedule', 2);
                    // close dialog and close bottom sheet as well
                    goBackScreen(context);
                    goBackScreen(context);
                  }
                },
                child: WidgetUtils.buildGeneralButtonWidget('create', kPrimaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void goBackScreen(BuildContext context) {
    return Navigator.of(context).pop(true);
  }

  void showToast(String msg, int duration) {
    Toast.show(msg, context, duration: duration, gravity: Toast.BOTTOM);
  }
}
