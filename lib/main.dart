import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/InternalStorage.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'dart:convert';

import 'Model/Class.dart';
import 'Model/User.dart';
import 'View/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // this line is needed to use async/await in main()

  await InternalStorage.init();
  final String sharedPrefUserKey = 'user';

  //load user
  Future<User> loadSharedPreferences() async {
    try {
      var json = await InternalStorage.read(sharedPrefUserKey);
      User user = User.fromJson(json);
      print('Successfully read user object from pref');
      return user;
    } catch (Exception) {
      print('Exception loading User START -------------------');
      print(Exception);
      print('Exception loading User END ----------------------');
      // if no data initially, return default user object
      User user = User(username: User.defaultUsername);
      InternalStorage.save(sharedPrefUserKey, user);
      return user;
    }
  }

  final User user = await loadSharedPreferences();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClassList()),
        ChangeNotifierProvider(create: (context) => User(username: user.username)),
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
        primaryColor: Color(0xFF3EBACE),
        accentColor: Color(0xFFD8ECF1),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      home: HomePage(),
    );
  }
}





