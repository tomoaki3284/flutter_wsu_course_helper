import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/InternalStorage.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';
import 'package:wsu_course_helper/constants.dart';
import 'dart:convert';

import 'Logger.dart';
import 'Model/Class.dart';
import 'Model/Schedule.dart';
import 'Model/User.dart';
import 'View/HomePage/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // this line is needed to use async/await in main()

  await InternalStorage.init();
  final String sharedPrefUserKey = 'user';

  //load user
  Future<User> loadSharedPreferences() async {
    try {
      var json = await InternalStorage.read(sharedPrefUserKey);
      User user = User.fromJson(json);
      Logger.LogDetailed('main', 'loadSharedPreferences', 'Successfully read user object from pref');
      user.schedulePool.addSchedule('schedule 1');
      user.schedulePool.addSchedule('schedule 2');
      user.schedulePool.addSchedule('schedule 3');
      // InternalStorage.remove(sharedPrefUserKey);
      return user;
    } catch (Exception) {
      Logger.LogException(Exception);
      // if no data initially, return default user object
      User user = User(username: User.defaultUsername);
      user.schedulePool.addSchedule('schedule 1');
      InternalStorage.save(sharedPrefUserKey, user);
      return user;
    }
  }

  final User user = await loadSharedPreferences();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClassList()),
        ChangeNotifierProvider(create: (context) => user),
        ChangeNotifierProvider(create: (context) => user.schedulePool),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          accentColor: Color(0xFFD8ECF1),
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        ),
        home: HomePage(),
    );
  }
}





