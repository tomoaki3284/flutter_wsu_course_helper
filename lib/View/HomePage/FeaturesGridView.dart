import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/ClassList.dart';
import 'package:wsu_course_helper/View/AutoSchedulerPage/AutoSchedulerListPage.dart';
import 'package:wsu_course_helper/constants.dart';

class FeaturesGridView extends StatelessWidget {
  Widget progressbar = Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      strokeWidth: 10.0,
      valueColor: AlwaysStoppedAnimation(kPrimaryColor),
    ),
  );
  ClassList classes;

  List<Feature> features = [
    Feature(
      name: 'scheduler',
      imgPath: kImgByFeatureName['scheduler'],
      featureScreen: AutoSchedulerListPage(),
    ),
    Feature(
      name: 'prof-rate',
      imgPath: kImgByFeatureName['prof. rating'],
      featureScreen: Scaffold(),
    ),
    Feature(
      name: 'donate',
      imgPath: kImgByFeatureName['donate'],
      featureScreen: Scaffold(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ClassList classes = Provider.of<ClassList>(context);
    Widget childWidget = classes == null || classes.classesBySubject.length == 0
        ? progressbar
        : gridView(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: childWidget,
    );
  }

  Widget gridView(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2),
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _buildFeatureCell(context, features[index]);
      },
    );
  }

  Widget _buildFeatureCell(BuildContext context, Feature feature) {
    return GestureDetector(
      onTap: () {
        var jumpTo = feature.featureScreen;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => jumpTo),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(3, 7),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(feature.imgPath),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Text(
              feature.name,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

class Feature {
  String name;
  String imgPath;
  Widget featureScreen;

  Feature(
      {@required this.name,
      @required this.imgPath,
      @required this.featureScreen});
}
