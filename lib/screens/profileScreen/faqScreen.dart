import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/appColors.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<String> _data = [
    "Genaral",
    "Account",
    "Service",
    "Video",
  ];
  List<String> _selectedData = [];

  _onSelected(bool selected, String data) {
    setState(() {
      if (selected) {
        _selectedData.clear();
        _selectedData.add(data);
      } else {
        _selectedData.remove(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 16.w),
                Wrap(
                  spacing: 15,
                  runSpacing: 3,
                  children: _data.map((data) {
                    return FilterChip(
                      showCheckmark: false,
                      backgroundColor: AppColors.colorSecondaryDarkest,
                      label: Text(
                        data,
                        style: TextStyle(
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp),
                      ),
                      shape: const StadiumBorder(
                          side: BorderSide(color: AppColors.colorPrimary)),
                      selected: _selectedData.contains(data),
                      selectedColor: AppColors.colorPrimary,
                      padding: const EdgeInsets.all(8),
                      onSelected: (selected) => _onSelected(selected, data),
                    );
                  }).toList(),
                ),
                SizedBox(width: 16.w),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 55.h,
                      width: 270.w,
                      child: TextField(
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white),
                          hintText: "Search",
                          filled: true,
                          fillColor: AppColors.colorGrey,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    Container(
                      height: 55.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                          color: AppColors.colorGrey,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(
                        Icons.filter_list,
                        size: 26,
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Container(
                  height: 185.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        width: 2, color: AppColors.colorWhiteHighEmp),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'How to create an account?',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.colorWhiteHighEmp,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Icon(
                              Icons.minimize,
                              color: AppColors.colorWhiteHighEmp,
                            )
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'Open the Tradebase app to get started and follow the steps. Tradebase doesn’t charge a fee to create or maintain your Tradebase account.',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.colorWhiteHighEmp,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  height: 100.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        width: 2, color: AppColors.colorWhiteHighEmp),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'How to add a payment method \nby this app?',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.colorWhiteHighEmp,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Icon(
                              Icons.add,
                              color: AppColors.colorPrimary,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  height: 100.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        width: 2, color: AppColors.colorWhiteHighEmp),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'What Time Does The Stock Market \n Open?',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.colorWhiteHighEmp,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Icon(
                              Icons.add,
                              color: AppColors.colorPrimary,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  height: 100.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        width: 2, color: AppColors.colorWhiteHighEmp),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Is The Stock Market Open On \nWeekends?',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.colorWhiteHighEmp,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Icon(
                              Icons.add,
                              color: AppColors.colorPrimary,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
