import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/screens/profileScreen/paymentMethodScreen.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';

class SubToPremiumScreen extends StatelessWidget {
  const SubToPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Plans'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 15.h),
          Center(
              child: Text(
            'Subscribe to Premium',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.colorPrimary,
              fontSize: 24.sp,
            ),
          )),
          Center(
            child: Text(
              'Enjoy watching Full-HD movies, without\nrestrictions & without ads',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 14.sp,
                  height: 1.2),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Features',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Downloads',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Screens',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Originals',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Devices',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Ads',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20.w),
                Container(
                  height: 260.h,
                  width: 102.w,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          'Bd 1 year..',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        const Icon(
                          Icons.check,
                          color: AppColors.colorWhiteHighEmp,
                        ),
                        SizedBox(height: 10.h),
                        const Icon(
                          Icons.check,
                          color: AppColors.colorWhiteHighEmp,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          '7',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'No Ads',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'BDT 899',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorPrimary,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          'Per year',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 12.sp,
                          ),
                        ),
                      ]),
                ),
                SizedBox(width: 20.w),
                Container(
                  height: 260.h,
                  width: 102.w,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          'Bd 1 year..',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          '1',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        const Icon(
                          Icons.check,
                          color: AppColors.colorWhiteHighEmp,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          '4',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'No Ads',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'BDT 599',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorPrimary,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          'Per year',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 12.sp,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
          SizedBox(height: 150.h),
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                Get.to(const PaymentMethodScreen());
              },
              child: Container(
                height: 55.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorPrimary,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    'CONTINUE WITH BD 1 YEAR 2 STREMS',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorWhiteHighEmp,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
