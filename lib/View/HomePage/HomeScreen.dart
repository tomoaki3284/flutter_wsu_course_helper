import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Backend/Database.dart';
import 'package:wsu_course_helper/LifecycleEventHandler.dart';
import 'package:wsu_course_helper/Model/AppUser.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/View/HomePage/HomeCategoryTabs.dart';
import 'package:wsu_course_helper/View/HomePage/WelcomeBlock.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Database database;
  AppUser user;

  @override
  void initState() {
    super.initState();

    database = new Database();

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
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  WelcomeBlock(),
                  HomeCategoryTabs(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
