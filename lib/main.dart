import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Model/Class.dart';

void main() {
  runApp(MyApp());
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

  List<Class> classes;

  @override
  void initState() {
    super.initState();
    fetchClasses().then((classes) {
      print("done");
      setState(() {
        this.classes = classes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: classes == null ? 0 : classes.length,
        itemBuilder: (context, index) {
          Class clss = classes[index];
          return _buildRow(clss);
        },
        separatorBuilder: (context, index){
          return Divider();
        },
      ),
    );
  }

  Widget _buildRow(Class clss) {
    return ListTile(
      title: Text(clss.title),
    );
  }
}



