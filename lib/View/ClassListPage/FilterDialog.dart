import 'package:flutter/material.dart';
import 'package:wsu_course_helper/constants.dart';

class FilterDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Dialog(
      child: Container(
        height: 350,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              child: Text(
                'Filter categories',
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            _buildHeader('Core'),
            _buildDropDownButton(),
            _buildHeader('Extra'),
            _buildDropDownButton(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildButtonWidget('cancel', Colors.red),
        _buildButtonWidget('add', kPrimaryColor),
      ],
    );
  }

  Widget _buildButtonWidget(String text, Color color) {
    return Container(
      height: 40,
      width: 100,
      margin: EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ]),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: color
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(20, 25, 20, 5),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          decoration: TextDecoration.none,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildDropDownButton() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ]),
    );
  }
}
