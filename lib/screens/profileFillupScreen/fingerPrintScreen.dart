import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/myBottomNavModel.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';

class FingerPrintScreen extends StatefulWidget {
  const FingerPrintScreen({super.key});

  @override
  State<FingerPrintScreen> createState() => _FingerPrintScreenState();
}

class _FingerPrintScreenState extends State<FingerPrintScreen> {
  Future<void> _showSimpleDialog() async {
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: AppColors.colorGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Image.asset('assets/images/confirm.png',
                    height: 108, width: 108),
              ),
              SimpleDialogOption(
                child: Center(
                  child: Text(
                    'Congratulations!',
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: AppColors.colorWhiteHighEmp,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SimpleDialogOption(
                child: Text(
                  'Your account ready to use. You will be\nredirect to the home page\nautomatically within few seconds. ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.w400,
                      height: 1.2),
                ),
              ),
              SimpleDialogOption(
                child: InkWell(
                  onTap: () {
                    Get.offAll(const MyBottomNavModel());
                  },
                  child: Container(
                    height: 52,
                    width: 200,
                    decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        'EXPLORE NOW',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.colorWhiteHighEmp,
                            fontWeight: FontWeight.w600,
                            height: 1.2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Create new PIN'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            SizedBox(height: 100.h),
            const Center(
              child: Icon(
                Icons.fingerprint_rounded,
                color: AppColors.colorPrimary,
                size: 200,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Add Fingerprint',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorWhiteHighEmp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add Fingerprint to make your account more secure. \nPlease put your finger on the fingerprint scanner to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.colorWhiteHighEmp),
            ),
            SizedBox(height: 150.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _showSimpleDialog,
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
                  onTap: _showSimpleDialog,
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
