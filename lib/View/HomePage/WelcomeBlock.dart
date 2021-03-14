import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/AppUser.dart';

class WelcomeBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              color: Theme.of(context).primaryColor,
            ),
          ),
          _buildBlock(context),
        ],
      ),
    );
  }

  Widget _buildBlock(BuildContext context) {
    AppUser user = Provider.of<AppUser>(context);

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 9,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 24.0,
                  color: Colors.white,
                  height: 1.9,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Hello, ${user.username}\n",
                  ),
                  TextSpan(
                    text: "Explore WSU Courses",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {},
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(
                // TODO: Should reflect user image instead of person icon
                Icons.person,
                size: 18.0,
              ),
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height - 10;
    double width = size.width;
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
