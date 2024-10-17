import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/appColors.dart';

class GenderDropdownModel extends StatefulWidget {
  final String gender;
  final Function(String) onGenderChanged; // Callback function
  final List<Map<String, String>> items; // List of items with value and image

  const GenderDropdownModel({
    Key? key,
    required this.gender,
    required this.onGenderChanged,
    required this.items, // Add items to the constructor
  }) : super(key: key);

  @override
  _GenderDropdownModelState createState() => _GenderDropdownModelState();
}

class _GenderDropdownModelState extends State<GenderDropdownModel> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue =
        widget.gender == '' ? widget.items[0]['value']! : widget.gender;
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: DropdownButton(
              dropdownColor: AppColors.colorGrey,
              borderRadius: BorderRadius.circular(12),
              value: _selectedValue,
              isDense: false,
              // Prevents compacting the items
              itemHeight: 50.h,
              // Set the itemHeight to match the desired height
              items: widget.items.map((item) {
                return DropdownMenuItem(
                  value: item['value'],
                  child: Container(
                    height: 300.h,
                    // Set the desired height for the background
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    // Add vertical padding

                    decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      // Background color for the dropdown item
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          item['image']!,
                          width: 35.w,
                          height: 30.h,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 20.w),
                        // Spacing between image and text
                        Text(
                          item['value']!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.colorWhiteHighEmp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedValue = newValue!;
                  widget.onGenderChanged(_selectedValue);
                });
              },
              underline: Container(
                height: 0,
                color: Colors.transparent,
              ),
              iconDisabledColor: Colors.transparent,
              icon: const Padding(
                padding: EdgeInsets.only(left: 130),
                child: Icon(Icons.arrow_drop_down,
                    color: AppColors.colorWhiteHighEmp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
