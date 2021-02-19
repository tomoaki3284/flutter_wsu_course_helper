import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wsu_course_helper/Model/Class.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:provider/provider.dart';

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue, statusBarBrightness: Brightness.dark
    ));

    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: _buildWelcomeBlock(context),
              ),
              Flexible(
                flex: 8,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// most top layered view
  Widget _buildWelcomeBlock(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 8,
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Container(
                    height: double.infinity, width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Hello, User",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    height: double.infinity, width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "explore",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: RawMaterialButton(
              onPressed: () {},
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 20.0,
              ),
              padding: EdgeInsets.all(8),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
    );
  }
}