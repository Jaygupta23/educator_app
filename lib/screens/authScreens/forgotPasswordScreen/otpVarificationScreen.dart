import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/appColors.dart';
import 'newPasswordScreen.dart';

class OtpVarificationScreen extends StatefulWidget {
  const OtpVarificationScreen({super.key});

  @override
  _OtpVarificationScreenState createState() => _OtpVarificationScreenState();
}

class _OtpVarificationScreenState extends State<OtpVarificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 26,
                          color: AppColors.colorWhiteHighEmp,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80.h),
                Image.asset('assets/images/lock.png',
                    width: 200.h, height: 200.w),
                SizedBox(height: 30.h),
                Text(
                  "Code has been send to +111 23******77",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorWhiteHighEmp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _textFieldOTP(first: true, last: false),
                          _textFieldOTP(first: false, last: false),
                          _textFieldOTP(first: false, last: false),
                          _textFieldOTP(first: false, last: true),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Resend code in 55 s",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.colorWhiteHighEmp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 140.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const NewPasswordScreen());
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                AppColors.colorPrimary),
                            shape: WidgetStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              'VERIFY',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({required bool first, last}) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
          color: AppColors.colorGrey, borderRadius: BorderRadius.circular(8)),
      child: AspectRatio(
        aspectRatio: 1.3,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.colorWhiteHighEmp),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: const InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
