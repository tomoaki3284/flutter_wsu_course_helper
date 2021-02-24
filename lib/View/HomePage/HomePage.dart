import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/Model/User.dart';
import 'package:wsu_course_helper/View/HomePage/FeaturesBlock.dart';
import 'package:wsu_course_helper/View/HomePage/WelcomeBlock.dart';
import 'package:wsu_course_helper/constants.dart';

import '../../Logger.dart';
import 'CoursesBlock.dart';
import 'SchedulePagerBlock.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Logger.LogDetailed('HomePage.dart', 'initState', 'method called');

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<T>() to get classList reference
      // fetch classes
      final classes = context.read<ClassList>();
      if (classes.allClasses == null || classes.allClasses.isEmpty) {
        classes.fetchClasses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[
              WelcomeBlock(),
              CoursesBlock(),
              FeaturesBlock(),
              SchedulePagerBlock(),
            ],
          ),
        ),
      ),
    );
  }
}
