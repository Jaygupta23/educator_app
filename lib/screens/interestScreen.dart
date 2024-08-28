import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/screens/profileFillupScreen/profileFillupScreen.dart';
import 'package:get/get.dart';

import '../utils/appColors.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  List<String> _data = [
    "Horror",
    "South Korea",
    "Action",
    "Adventure",
    "Drama",
    "War",
    "Crime",
    "Romance",
    "History",
    "Music",
    "Comedy",
    "Television",
    "Thriller",
    "Animation",
    "Sci-fi",
  ];
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
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Choose your interest'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Choose your interests here and get the best movie\nrecommendations. Don't worry you can always\nchange it later.",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.colorWhiteHighEmp,
                height: 1.2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 5,
                runSpacing: 3,
                children: _data.map((data) {
                  return FilterChip(
                    showCheckmark: false,
                    backgroundColor: AppColors.colorSecondaryDarkest,
                    label: Text(
                      data,
                      style: const TextStyle(color: AppColors.colorWhiteHighEmp),
                    ),
                    shape: const StadiumBorder(
                        side: BorderSide(color: AppColors.colorPrimary)),
                    selected: _selectedData.contains(data),
                    selectedColor: AppColors.colorPrimary,
                    padding: const EdgeInsets.all(5),
                    onSelected: (selected) => _onSelected(selected, data),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 240.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to( const ProfileFillupScreen());
                  },
                  child: Container(
                    height: 45.h,
                    width: 148.w,
                    decoration: BoxDecoration(
                      color: AppColors.colorWhiteMidEmp,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        'SKIP',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorSecondaryDarkest,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                InkWell(
                  onTap: () {
                    Get.to( const ProfileFillupScreen());
                  },
                  child: Container(
                    height: 45.h,
                    width: 148.w,
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        'CONTINUE',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
