import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/screens/profileFillupScreen/fingerPrintScreen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/appColors.dart';


class NewPinScreen extends StatefulWidget {
  const NewPinScreen({super.key});

  @override
  _NewPinScreenState createState() => _NewPinScreenState();
}

class _NewPinScreenState extends State<NewPinScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Create new PIN'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Image.asset(
                  'assets/images/lock.png', width: 124.w,
                  height: 124.h
                ),
                SizedBox(height: 30.h),
                Text(
                  "Add your PIN number to make your \naccount more secure.",
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
                      SizedBox(height: 80.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                           Get.to( const FingerPrintScreen());
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.colorPrimary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              'CONTINUE',
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
      height: 45.h,
      decoration:  BoxDecoration(color: AppColors.colorPrimaryLightest, borderRadius: BorderRadius.circular(8)),
      child: AspectRatio(
        aspectRatio: 1.4,
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
              color: AppColors.colorPrimary),
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
