import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/User.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<T>() to get classList reference
      // fetch classes
      final classes = context.read<ClassList>();
      if (classes.allClasses == null || classes.allClasses.isEmpty) {
        classes.fetchClasses();
      }

      // TODO: load user
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue, statusBarBrightness: Brightness.dark
    ));

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _buildWelcomeBlock(context),
          ],
        ),
      ),
    );
  }

  /// most top layered view
  Widget _buildWelcomeBlock(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, _) => RichText(
        text: TextSpan(
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0),
          children: <TextSpan>[
            TextSpan(
                text: "Hello, ${user.username}"
            ),
            TextSpan(
                text: "Have Fun Exploring WSU Courses",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w100, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}