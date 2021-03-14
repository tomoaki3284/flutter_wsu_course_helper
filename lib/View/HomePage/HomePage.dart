import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Backend/Database.dart';
import 'package:wsu_course_helper/LifecycleEventHandler.dart';
import 'package:wsu_course_helper/Model/AppUser.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/View/HomePage/FeaturesBlock.dart';
import 'package:wsu_course_helper/View/HomePage/WelcomeBlock.dart';

import '../../Logger.dart';
import 'CoursesBlock.dart';
import 'SchedulePagerBlock.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Database database = new Database();
  AppUser user;

  @override
  void initState() {
    super.initState();

    Logger.LogDetailed('HomePage.dart', 'initState', 'method called');

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      detachedCallBack: () async => database.updateUser(user),
    ));

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
    user = Provider.of<AppUser>(context, listen: false);
    print(user.getAppUserDataMap());

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView(
            children: <Widget>[
              // GestureDetector(
              //   onTap: () {
              //     if (user.email.length != 0) database.updateUser(user);
              //   },
              //   child: Container(
              //     height: 50,
              //     color: Colors.cyan,
              //     child: Text('save'),
              //   ),
              // ),
              Stack(
                children: <Widget>[
                  WelcomeBlock(),
                  SchedulePagerBlock(),
                ],
              ),
              FeaturesBlock(),
              CoursesBlock(),
            ],
          ),
        ),
      ),
    );
  }
}
