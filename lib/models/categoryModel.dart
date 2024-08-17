import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/appColors.dart';


class CategoryModel extends StatelessWidget {
  const CategoryModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              height: 30.h,
              width: 80.w,
              decoration: BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  'All',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              height: 30.h,
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: AppColors.colorPrimary),
              ),
              child: Center(
                child: Text(
                  'Movies',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              height: 30.h,
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: AppColors.colorPrimary),
              ),
              child: Center(
                child: Text(
                  'Drama',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              height: 30.h,
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: AppColors.colorPrimary),
              ),
              child: Center(
                child: Text(
                  'Thriller',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              height: 30.h,
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: AppColors.colorPrimary),
              ),
              child: Center(
                child: Text(
                  'Romance',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              height: 30.h,
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: AppColors.colorPrimary),
              ),
              child: Center(
                child: Text(
                  'Comedy',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              margin: const EdgeInsets.only(right: 16),
              height: 30.h,
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: AppColors.colorPrimary),
              ),
              child: Center(
                child: Text(
                  'Horror',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
