import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/appColors.dart';

class GenderDropdownModel extends StatefulWidget {
  @override
  _GenderDropdownModelState createState() => _GenderDropdownModelState();
}

class _GenderDropdownModelState extends State<GenderDropdownModel> {
  late String _selectedValue;

  final List<String> _items = [
    'Male',
    'Female',
  ];

  @override
  void initState() {
    super.initState();
    _selectedValue = _items[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.colorGrey,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: DropdownButton(
              dropdownColor: AppColors.colorGrey,
              borderRadius: BorderRadius.circular(12),
              value: _selectedValue,
              items: _items.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        fontSize: 14.sp, color: AppColors.colorWhiteHighEmp),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedValue = newValue!;
                });
              },
              underline: Container(
                height: 0,
                color: Colors.transparent,
              ),
              iconDisabledColor: Colors.transparent,
              icon: const Padding(
                padding: EdgeInsets.only(left: 230),
                child: Icon(Icons.arrow_drop_down,
                    color: AppColors.colorWhiteHighEmp),
              ), // add your own icon here
            ),
          ),
        ],
      ),
    );
  }
}
