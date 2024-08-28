import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/myBottomNavModel.dart';
import 'package:reelies/models/rememberMeModel.dart';
import 'package:reelies/utils/myButton.dart';
import 'package:get/get.dart';

import '../../../utils/appColors.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formfield = GlobalKey<FormState>();
  var obscureText = true;
  var obscureText2 = true;

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
                    height: 108.h, width: 108.w),
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
                    height: 52.h,
                    width: 200.w,
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
        title: const Text('Create new password'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formfield,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Center(
                child: Image.asset('assets/images/lock2.png',
                    height: 162.h, width: 162.w),
              ),
              SizedBox(height: 30.h),
              Text(
                "Create your new password",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.colorWhiteHighEmp,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Container(
                  width: 296.w,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    obscureText: obscureText,
                    style: const TextStyle(color: AppColors.colorDisabled),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: AppColors.colorDisabled,
                      ),
                      hintText: 'Password',
                      hintStyle:
                          const TextStyle(color: AppColors.colorDisabled),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: obscureText
                            ? const Icon(Icons.visibility_off,
                                color: AppColors.colorPrimary, size: 20)
                            : const Icon(Icons.visibility_outlined,
                                color: AppColors.colorPrimary, size: 20),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorGrey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorGrey,
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorError,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorError,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Container(
                  width: 296.w,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    obscureText: obscureText2,
                    style: const TextStyle(color: AppColors.colorDisabled),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: AppColors.colorDisabled,
                      ),
                      hintText: 'Password',
                      hintStyle:
                          const TextStyle(color: AppColors.colorDisabled),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText2 = !obscureText2;
                          });
                        },
                        child: obscureText2
                            ? const Icon(Icons.visibility_off,
                                color: AppColors.colorPrimary, size: 20)
                            : const Icon(Icons.visibility_outlined,
                                color: AppColors.colorPrimary, size: 20),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorGrey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorGrey,
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorError,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorError,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const RememberMeModel(),
              SizedBox(height: 120.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: MyButton(onPressed: _showSimpleDialog, text: "Continue"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
