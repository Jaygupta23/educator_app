import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/appColors.dart';

class FaqCategoryModel extends StatelessWidget {
  const FaqCategoryModel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            Container(
              height: 30.h,
              width: 80.w,
              decoration: BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  'Genaral',
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
                color: AppColors.colorPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Account',
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
                color: AppColors.colorPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Service',
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
                color: AppColors.colorPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Video',
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
