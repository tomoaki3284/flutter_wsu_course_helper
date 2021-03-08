import 'package:flutter/material.dart';

class ScheduledClassesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 35, bottom: 35, left: 15, right: 15),
      child: Text(
        'Classes on your schedule',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
