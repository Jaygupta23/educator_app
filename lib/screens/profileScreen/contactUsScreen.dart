import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/appColors.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
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
                            color: AppColors.colorWhiteHighEmp,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                              color: AppColors.colorWhiteHighEmp),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.colorWhiteHighEmp),
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
                        size: 28,
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Container(
                  height: 55.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 12.w),
                      const Icon(
                        Icons.headphones,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '  Customer Services',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 55.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 12.w),
                      Image.asset("assets/images/hWhatsapp.png",
                          height: 24.h, width: 24.w),
                      SizedBox(width: 12.w),
                      Text(
                        '  Whatsapp',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 55.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 12.w),
                      const Icon(
                        Icons.language,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '  Website',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 55.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 12.w),
                      Image.asset("assets/images/hFacebook.png",
                          height: 24.h, width: 24.w),
                      SizedBox(width: 12.w),
                      Text(
                        '  Facebook',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 55.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 12.w),
                      Image.asset("assets/images/hTweet.png",
                          height: 24.h, width: 24.w),
                      SizedBox(width: 12.w),
                      Text(
                        '  Twitter',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 55.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 12.w),
                      Image.asset("assets/images/hInsta.png",
                          height: 24.h, width: 24.w),
                      SizedBox(width: 12.w),
                      Text(
                        '  Instagram',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
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
