import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/screens/searchScreen/searchScreen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/appColors.dart';

class SearchErrorScreen extends StatefulWidget {
  const SearchErrorScreen({super.key});

  @override
  State<SearchErrorScreen> createState() => _SearchErrorScreenState();
}

class _SearchErrorScreenState extends State<SearchErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      body: GestureDetector(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.offAll(SearchScreen());
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.colorWhiteHighEmp,
                          size: 24,
                        ),
                      ),
                      //SizedBox(width: 3),
                      Container(
                        height: 55.h,
                        width: 230.w,
                        child: TextField(
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.search, color: Colors.white),
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
                        child: Icon(
                          Icons.filter_list,
                          size: 28,
                          color: AppColors.colorSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 90.h),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                      height: 218.h,
                      width: 208.w,
                      child: Image.asset('assets/images/error.png')),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Opps!',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.colorPrimary),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Not found',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.colorWhiteHighEmp),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  'Sorry, the keyword you entered could \nnot be found. Try to check again or \nssearch with other keywords.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                      color: AppColors.colorWhiteHighEmp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
