import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/ClassListFilter.dart';
import 'package:wsu_course_helper/View/ClassListPage/DropDown.dart';
import 'package:wsu_course_helper/WidgetUtils.dart';
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
            _buildDropDownButton(kCores, 'core'),
            _buildHeader('Extra'),
            _buildDropDownButton(kSpecials, 'special'),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    ClassListFilter classListFilter = Provider.of<ClassListFilter>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              goBackScreen(context);
            },
            child: WidgetUtils.buildGeneralButtonWidget('cancel', Colors.red),
          ),
          GestureDetector(
            onTap: () {
              applyFilter(context);
            },
            child: WidgetUtils.buildGeneralButtonWidget('filter', kPrimaryColor),
          ),
        ],
      ),
    );
  }

  void applyFilter(BuildContext context) {
    ClassListFilter classListFilter =
        Provider.of<ClassListFilter>(context, listen: false);
    classListFilter.applyFilter();
    goBackScreen(context);
  }

  void goBackScreen(BuildContext context) {
    return Navigator.of(context).pop(true);
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

  Widget _buildDropDownButton(
      List<String> dropdownMenuItemArray, String filterType) {
    assert(filterType != null);

    return Container(
      alignment: Alignment.centerLeft,
      height: 40,
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 20),
        child: DropDown(
          dropdownItemArray: dropdownMenuItemArray,
          filterType: filterType,
      ),
    );
  }
}
