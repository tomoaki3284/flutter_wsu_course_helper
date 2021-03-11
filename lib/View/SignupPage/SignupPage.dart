import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:wsu_course_helper/View/LoginPage/LoginPage.dart';

class SignupPage extends StatelessWidget {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Your Account'),
      ),
      body: body(context),
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
                labelText: 'username',
              ),
              controller: _usernameController,
            ),
          ),
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
              singupUser(context);
            },
            child: Text('Sign Up'),
          ),
          ElevatedButton(
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (context) => LoginPage());
              Navigator.pushReplacement(context, route);
            },
            child: Text('log in instead'),
          ),
        ],
      ),
    );
  }

  void singupUser(BuildContext context) {
    String username = _usernameController.text.toString();
    String email = _emailController.text.toString();
    String password = _passwordController.text.toString();

    if (username == null || username.length < 5) {
      showToast('username has to be at least 5 characters', 5, context);
    } else if (email == null || !email.contains('@')) {
      showToast('email is not valid', 5, context);
    } else if (password == null || password.length < 5) {
      showToast('password has to be at least 5 characters', 5, context);
    } else {
      // todo: use database object to call signup user, pass data if needed
    }
  }

  void showToast(String msg, int duration, BuildContext context) {
    Toast.show(msg, context, duration: duration, gravity: Toast.BOTTOM);
  }
}
