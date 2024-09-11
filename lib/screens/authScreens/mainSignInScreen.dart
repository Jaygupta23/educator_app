import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/myBottomNavModel.dart';
import 'package:reelies/screens/authScreens/signInScreen.dart';
import 'package:reelies/screens/authScreens/signUpScreen.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';
import '../../utils/constants.dart';
import '../../utils/myButton.dart';

class MainSignInScreen extends StatelessWidget {
  const MainSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      body: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/onBoard3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 230.h),
            Text(
              "Let's you in",
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.colorWhiteHighEmp,
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () {
                Get.offAll(const MyBottomNavModel());
              },
              child: Container(
                height: 56.h,
                width: 300.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(width: 1, color: AppColors.colorBlackHighEmp),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/facebook.png',
                        height: 26.h, width: 26.w),
                    SizedBox(width: 10.w),
                    Text(
                      "Continue with Facebook",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () {
                Get.offAll(const MyBottomNavModel());
              },
              child: Container(
                height: 56.h,
                width: 300.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(width: 1, color: AppColors.colorBlackHighEmp),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/google.png',
                        height: 30.h, width: 30.w),
                    SizedBox(width: 5.w),
                    Text(
                      "Continue with Google",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () {
                Get.offAll(const MyBottomNavModel());
              },
              child: Container(
                height: 56.h,
                width: 300.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(width: 1, color: AppColors.colorBlackHighEmp),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/apple.png',
                        height: 40.h, width: 36.w),
                    SizedBox(width: 2.w),
                    Text(
                      "Continue with Apple ID",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/Line 1.png',
                    height: 40.h, width: 130.w),
                SizedBox(width: 10.w),
                Text(
                  "or",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10.w),
                Image.asset('assets/images/Line 2.png', height: 40, width: 130),
              ],
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: MyButton(
                  onPressed: () {
                    Get.offAll(const SignInScreen());
                  },
                  text: "SIGN IN WITH PASSWORD"),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dontHaveAccount,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.colorWhiteHighEmp,
                  ),
                ),
                SizedBox(width: 5.w),
                InkWell(
                  onTap: () {
                    Get.to(() => const SignUpScreen());
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
