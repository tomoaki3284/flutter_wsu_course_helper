import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Backend/Database.dart';
import 'package:wsu_course_helper/InternalStorage.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/Model/ClassListFilter.dart';
import 'package:wsu_course_helper/View/HomePage/HomeScreen.dart';
import 'package:wsu_course_helper/View/SignupPage/SignupPage.dart';
import 'package:wsu_course_helper/constants.dart';

import '../Logger.dart';
import '../Model/AppUser.dart';
import 'HomePage/HomePage.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // this line is needed to use async/await in main()
  await Firebase.initializeApp();
  await InternalStorage.init();
  final String sharedPrefUserKey = 'user';

  //load user
  Future<AppUser> loadSharedPreferences() async {
    try {
      var json = await InternalStorage.read(sharedPrefUserKey);
      AppUser user = AppUser.fromJson(json);
      return user;
    } catch (Exception) {
      Logger.LogException(Exception);
      // if no data initially, return default user object
      AppUser user = AppUser(username: AppUser.defaultUsername);
      user.schedulePool.addSchedule('schedule 1');
      InternalStorage.save(sharedPrefUserKey, user);
      return user;
    }
  }

  // final AppUser user = await loadSharedPreferences();
  Database database = new Database();
  AppUser user = await database.checkoutCurrentUser();
  Logger.LogDetailed('main', 'main', '$user');
  if (user == null) {
    user = await loadSharedPreferences();
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ClassList()),
      ChangeNotifierProvider(create: (context) => user),
      ChangeNotifierProvider(create: (context) => user.schedulePool),
      ChangeNotifierProvider(create: (context) => ClassListFilter()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Database database = new Database();
  AppUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: Color(0xFFD8ECF1),
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
      ),
      home: user.email.length == 0 ? SignupPage() : HomeScreen(),
    );
  }
}
