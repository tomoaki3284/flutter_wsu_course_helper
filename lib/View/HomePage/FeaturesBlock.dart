import 'package:flutter/material.dart';

import '../../constants.dart';

class FeaturesBlock extends StatelessWidget {
  List<Feature> features = [
    Feature(
      name: 'scheduler',
      imgPath: kImgByFeatureName['scheduler'],
      featureScreen: Scaffold(),
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
    return _buildFeaturesListView();
  }

  Widget _buildFeaturesListView() {
    return Container(
      height: 130,
      padding: EdgeInsets.symmetric(horizontal: 35),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 0,
        ),
        itemBuilder: (context, index) {
          return _buildFeatureCell(context, index);
        },
        itemCount: features.length,
      ),
    );
  }

  Widget _buildFeatureCell(BuildContext context, int index) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            child: Image(
              image: AssetImage(features[index].imgPath),
            ),
          ),
          Text(
            features[index].name,
            maxLines: 1,
            style: TextStyle(
              letterSpacing: -0.5,
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
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

  Feature(
      {@required this.name,
      @required this.imgPath,
      @required this.featureScreen});
}
