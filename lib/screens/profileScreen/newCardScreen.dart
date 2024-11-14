import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../screens/profileScreen/paymentGatewayScreen.dart';
import '../../utils/myButton.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';

class NewCardScreen extends StatefulWidget {
  const NewCardScreen({super.key});

  @override
  State<NewCardScreen> createState() => _NewCardScreenState();
}

class _NewCardScreenState extends State<NewCardScreen> {
  bool? check1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Add New Card'),
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
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Center(
              child: Image.asset('assets/images/credit card.png',
                  height: 173.h, width: 288.w),
            ),
            SizedBox(height: 20.h),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    style: const TextStyle(color: AppColors.colorBlackLowEmp),
                    decoration: InputDecoration(
                      hintText: 'Enter your card number',
                      hintStyle:
                          const TextStyle(color: AppColors.colorBlackLowEmp),
                      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    style: const TextStyle(color: AppColors.colorBlackLowEmp),
                    decoration: InputDecoration(
                      hintText: 'Enter card holder name',
                      hintStyle:
                          const TextStyle(color: AppColors.colorBlackLowEmp),
                      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
                    ),
                  ),
                )),
            SizedBox(height: 16.h),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16, right: 20),
                    child: Container(
                      height: 50.h,
                      width: 155.w,
                      decoration: BoxDecoration(
                          color: AppColors.colorGrey,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                        style:
                            const TextStyle(color: AppColors.colorBlackLowEmp),
                        decoration: InputDecoration(
                          hintText: 'Expires on',
                          hintStyle: const TextStyle(
                              color: AppColors.colorBlackLowEmp),
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
                        ),
                      ),
                    )),
                Container(
                  height: 50.h,
                  width: 155.w,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextFormField(
                    style: const TextStyle(color: AppColors.colorBlackLowEmp),
                    decoration: InputDecoration(
                      hintText: '3 Digit CVV',
                      hintStyle:
                          const TextStyle(color: AppColors.colorBlackLowEmp),
                      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Checkbox(
                        value: check1,
                        onChanged: (bool? value) {
                          setState(() {
                            check1 = value;
                          });
                        }),
                  ),
                ),
                Text(
                  "Save for future",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.colorWhiteHighEmp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 80.h),
            Padding(
              padding: const EdgeInsets.all(16),
              child: MyButton(
                  onPressed: () {
                    Get.to(const PaymentGatewayScreen());
                  },
                  text: "ADD"),
            )
          ],
        ),
      ),
    );
  }
}
