import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:wsu_course_helper/Backend/Database.dart';
import 'package:wsu_course_helper/Logger.dart';
import 'package:wsu_course_helper/Model/AppUser.dart';
import 'package:wsu_course_helper/View/HomePage/HomePage.dart';
import 'package:wsu_course_helper/View/SignupPage/SignupPage.dart';

class LoginPage extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Database database = new Database();

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

  void processInput(BuildContext context) async {
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

    try {
      AppUser user = await database.loginAndAuthenticateUser(
          email: email, password: password);
      if (user != null) {
        // use provider to change user, since user logged in
        AppUser oldUser = Provider.of<AppUser>(context, listen: false);
        oldUser.changeReference(user);

        // now navigate after the user change
        Route route = MaterialPageRoute(builder: (context) => HomePage());
        Navigator.pushReplacement(context, route);
      } else {
        showToast('something wrong', 3, context);
      }
    } catch (err) {
      Logger.LogException(err);
      showToast('Couldn\'t log in', 3, context);
    }
  }

  void showToast(String msg, int duration, BuildContext context) {
    Toast.show(msg, context, duration: duration, gravity: Toast.BOTTOM);
  }
}
