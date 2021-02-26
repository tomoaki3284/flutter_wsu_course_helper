import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsu_course_helper/Model/ClassListFilter.dart';

class DropDown extends StatefulWidget {
  List<String> dropdownItemArray;
  String filterType;

  DropDown({@required this.dropdownItemArray, @required this.filterType});

  @override
  _DropDownState createState() => _DropDownState(
      dropdownItemArray: this.dropdownItemArray, filterType: filterType);
}

class _DropDownState extends State<DropDown> {
  List<String> dropdownItemArray;
  String filterType;

  List<DropdownMenuItem<String>> items = [];
  String _selectedItems;

  ClassListFilter classListFilter;

  _DropDownState({@required this.dropdownItemArray, filterType}){
    this.filterType = filterType;
  }

  @override
  void initState() {
    for (String item in dropdownItemArray) {
      items.add(DropdownMenuItem(
        value: item,
        child: Text(
          item,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ));
    }
    _selectedItems = items[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    classListFilter = Provider.of<ClassListFilter>(context, listen: false);

    return DropdownButton(
      isExpanded: true,
      value: _selectedItems,
      items: items,
      onChanged: onChangeItem,
    );
  }

  void onChangeItem(String selectedItem) {
    classListFilter.setFilter(selectedItem, filterType);

    setState(() {
      _selectedItems = selectedItem;
      classListFilter.setFilter(selectedItem, filterType);
    });
  }
}
