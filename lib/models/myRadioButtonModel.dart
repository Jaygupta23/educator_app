import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/appColors.dart';



class MyRadioButtonModel extends StatefulWidget {
  @override
  _MyRadioButtonModelState createState() => _MyRadioButtonModelState();
}

class _MyRadioButtonModelState extends State<MyRadioButtonModel> {
  int _selectedValue = 1;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 75.h,
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.colorGrey,
              borderRadius: BorderRadius.circular(6)),
          child: RadioListTile(
            subtitle: Text(
              "+111 234 45677",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.colorWhiteHighEmp,
                height: 1.2,
              ),
            ),
            title: Text(
              "Via Sms",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.colorWhiteHighEmp,
                height: 1.2,
              ),
            ),
            value: 1,
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          height: 75.h,
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.colorGrey,
              borderRadius: BorderRadius.circular(6)),
          child: RadioListTile(
            subtitle: Text(
              "john.kiniya@gmail.com",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.colorWhiteHighEmp,
                height: 1.2,
              ),
            ),
            title: Text(
              "Via Email",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.colorWhiteHighEmp,
                height: 1.2,
              ),
            ),
            value: 2,
            groupValue: _selectedValue,
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
          ),
        ),


      ],
    );
  }
}