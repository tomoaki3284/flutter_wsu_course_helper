import 'package:flutter/material.dart';

class GeneralHeader extends StatelessWidget {

  String title = '';

  GeneralHeader({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 8,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                'See all >',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
