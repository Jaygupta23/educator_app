import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/myBottomNavModel.dart';
import 'package:reelies/utils/myButton.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';

class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({super.key});

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
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
                  'You have successfully Subscribed 1\nmonth premium. Enjoy the benefits!',
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
                        'CONTINUE',
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
        title: const Text('Payment'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.qr_code,
              color: AppColors.colorWhiteHighEmp,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Select the payment method you want to use.',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                height: 85.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/paypal.png',
                        height: 24.h, width: 22.w),
                    SizedBox(height: 5.h),
                    Text(
                      'PayPal',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 85,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/gpay.png',
                      height: 24.h,
                      width: 100.w,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Google Pay',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 85.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/apay.png',
                      height: 24.h,
                      width: 32.w,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Apple Pay',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 85.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/master card.png',
                      height: 24.h,
                      width: 32.w,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      '*****35465',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => NewCard()));
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'ADD NEW CARD',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70.h),
              MyButton(onPressed: _showSimpleDialog, text: "CONTINUE"),
            ],
          ),
        ),
      ),
    );
  }
}
