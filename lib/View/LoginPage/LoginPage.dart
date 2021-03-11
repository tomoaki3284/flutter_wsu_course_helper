import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wsu_course_helper/View/SignupPage/SignupPage.dart';

class LoginPage extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Database _database;

  @override
  Widget build(BuildContext context) {
    // _database = Provider.of<Database>

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: SafeArea(
        child: body(context),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'email',
              ),
              controller: _emailController,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'password',
              ),
              controller: _passwordController,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              processInput(context);
            },
            child: Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (context) => SignupPage());
              Navigator.pushReplacement(context, route);
            },
            child: Text('Sign up your account'),
          ),
        ],
      ),
    );
  }

  void processInput(BuildContext context) {
    String email = _emailController.text.toString();
    String password = _passwordController.text.toString();

    if (password == null || password.length <= 0) {
      showToast('password cannot be empty', 3, context);
      return;
    }
    if (!email.contains('@')) {
      showToast('invalid email', 2, context);
      return;
    }

    // todo: use database to log in
  }

  void showToast(String msg, int duration, BuildContext context) {
    Toast.show(msg, context, duration: duration, gravity: Toast.BOTTOM);
  }
}
