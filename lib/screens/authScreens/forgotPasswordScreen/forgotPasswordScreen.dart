import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/myRadioButtonModel.dart';
import 'package:get/get.dart';

import '../../../utils/appColors.dart';
import 'otpVarificationScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String? sms, email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('assets/images/lock.png',
                  height: 162.h, width: 162.w),
            ),
            SizedBox(height: 30.h),
            Text(
              "Select which contact details should we use to reset\nyour password",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.colorWhiteHighEmp,
                height: 1.2,
              ),
            ),
            SizedBox(height: 10.h),
            MyRadioButtonModel(),
            SizedBox(height: 110.h),
            InkWell(
              onTap: () {
                Get.to(const OtpVarificationScreen());
              },
              child: Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorWhiteHighEmp,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
