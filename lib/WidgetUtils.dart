import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetUtils {

  static Widget buildGeneralButtonWidget(String text, Color color) {
    return Container(
      height: 40,
      width: 100,
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
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}