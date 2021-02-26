import 'package:flutter/cupertino.dart';

class WidgetUtils {

  static addClick(Widget container, Function function) {
    return new GestureDetector(
      child: container,
      onTap: function,
    );
  }
}