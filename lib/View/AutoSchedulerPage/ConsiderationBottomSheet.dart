import 'package:flutter/material.dart';
import 'package:wsu_course_helper/Model/AutoScheduler.dart';

// ignore: must_be_immutable
class ConsiderationBottomSheet extends StatefulWidget {
  AutoScheduler autoScheduler;

  ConsiderationBottomSheet({@required this.autoScheduler});

  @override
  _ConsiderationBottomSheetState createState() =>
      _ConsiderationBottomSheetState(autoScheduler: autoScheduler);
}

class _ConsiderationBottomSheetState extends State<ConsiderationBottomSheet> {
  AutoScheduler autoScheduler;

  _ConsiderationBottomSheetState({@required this.autoScheduler});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: body(context),
    );
  }

  Widget body(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Consideration List',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: widget.autoScheduler.titleOfClassesConsideration.length,
            itemBuilder: (context, index) {
              return _buildListTile(
                  widget.autoScheduler.titleOfClassesConsideration[index]);
            },
            separatorBuilder: (context, index) => Divider(
              height: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(String title) {
    return ListTile(
      title: Text(title),
      trailing: GestureDetector(
        onTap: () {
          autoScheduler.titleOfClassesConsideration.remove(title);
          setState(() {
            autoScheduler = autoScheduler;
          });
        },
        child: Image.asset('assets/images/remove.png'),
      ),
    );
  }

  void goBackScreen(BuildContext context) {
    return Navigator.of(context).pop(true);
  }
}
