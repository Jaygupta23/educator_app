import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../screens/movieDetailsScreen.dart';
import '../utils/appColors.dart';

class LatestShowsModel extends StatelessWidget {
  const LatestShowsModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.to(const MovieDetailsScreen());
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/Image.png',
                        height: 105.h, width: 100.w),
                    Text(
                      'Pushpa',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.colorWhiteHighEmp,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () {
                Get.to(const MovieDetailsScreen());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/Image-2.png',
                      height: 105.h, width: 100.w),
                  Text(
                    'Agilan',
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.colorWhiteHighEmp,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () {
                Get.to(const MovieDetailsScreen());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/Image-1.png',
                      height: 105.h, width: 100.w),
                  Text(
                    'Action',
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.colorWhiteHighEmp,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () {
                Get.to(const MovieDetailsScreen());
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/Image.png',
                        height: 105.h, width: 100.w),
                    Text(
                      'Pushpa',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.colorWhiteHighEmp,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
