import 'package:flutter/material.dart';

import '../../../utils/appColors.dart';


class CategoryChips extends StatefulWidget {
  @override
  _CategoryChipsState createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  List<String> _data = ["Movies", "TV Show", "Drama", "Action"];
  List<String> _selectedData = [];

  _onSelected(bool selected, String data) {
    setState(() {
      if (selected) {
        _selectedData.add(data);
      } else {
        _selectedData.remove(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 3,
      //runSpacing: 6.0,
      children: _data.map((data) {
        return FilterChip(
          showCheckmark: false,
          backgroundColor: AppColors.colorGrey,
          label: Text(
            data,
            style: TextStyle(color: AppColors.colorWhiteHighEmp),
          ),
          shape: StadiumBorder(side: BorderSide(color: AppColors.colorPrimary)),
          selected: _selectedData.contains(data),
          selectedColor: AppColors.colorPrimary,
          padding: EdgeInsets.all(5),
          onSelected: (selected) => _onSelected(selected, data),
        );
      }).toList(),
    );
  }
}
