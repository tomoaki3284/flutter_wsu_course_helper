import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'dart:convert';

import 'Model/Class.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ClassList(),
      child: MyApp(),
    )
  );
}

Future<List<Class>> fetchClasses() async {
  final String url = "https://wsucoursehelper.s3.amazonaws.com/current-semester.json";
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Iterable l = json.decode(response.body);
    List<Class> classes = List<Class>.from(l.map((model) => Class.fromJson(model)));
    return classes;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load json file from $url');
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    // addPostFrameCallbackは、initStateが呼ばれた後に一度のみ実行されるコールバック
    // ウィジェットの描画を行う際、最初の一度のみ実行したい処理を記述する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<T>() to get classList reference
      final classes = context.read<ClassList>();
      if (classes.allClasses == null || classes.allClasses.isEmpty) {
        classes.fetchClasses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassList>(
      builder: (context, classList, _) => Scaffold(
        body: ListView.separated(
          itemCount: classList.allClasses == null ? 0 : classList.allClasses.length,
          itemBuilder: (context, index) {
            Class clss = classList.allClasses[index];
            return _buildRow(clss);
          },
          separatorBuilder: (context, index){
            return Divider();
          },
        ),
      )
    );
  }

  Widget _buildRow(Class clss) {
    return ListTile(
      title: Text(clss.title),
    );
  }
}



