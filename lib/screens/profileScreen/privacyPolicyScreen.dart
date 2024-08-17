// Import necessary packages and files
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/appColors.dart';
import '../../utils/constants.dart';

// Define a Privacy Policy Screen widget
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
// Define the body of the screen
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Display privacy policy information
              Text(
                privacyPolicy1,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                privacyPolicyDesc,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                privacyPolicy2,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                privacyPolicyDesc,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                privacyPolicy3,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                privacyPolicyDesc,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                privacyPolicyDesc2,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
