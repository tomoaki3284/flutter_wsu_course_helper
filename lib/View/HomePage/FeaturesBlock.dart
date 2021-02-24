import 'package:flutter/material.dart';

import '../../constants.dart';
import '../GeneralHeader.dart';

class FeaturesBlock extends StatelessWidget {
  List<Feature> features = [
    Feature(
        name: 'scheduler',
        imgPath: kImgByFeatureName['auto scheduler'],
        featureScreen: Scaffold(),
    ),
    Feature(
      name: 'prof. rating',
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
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          GeneralHeader(title: 'Features'),
          _buildFeaturesListView(context),
        ],
      ),
    );
  }

  Widget _buildFeaturesListView(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        itemCount: features.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext ctxt, int index) {
          return _buildFeatureCell(ctxt, index);
        },
      ),
    );
  }

  Widget _buildFeatureCell(BuildContext context, int index) {
    return Container(
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
      margin: EdgeInsets.only(left: 15),
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(features[index].imgPath),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Text(
            features[index].name,
            style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

class Feature {

  String name;
  String imgPath;
  Widget featureScreen;

  Feature({@required this.name, @required this.imgPath, @required this.featureScreen});
}
