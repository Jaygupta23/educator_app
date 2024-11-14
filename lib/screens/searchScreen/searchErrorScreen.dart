import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../screens/searchScreen/searchScreen.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';

class SearchErrorScreen extends StatefulWidget {
  const SearchErrorScreen({super.key});

  @override
  State<SearchErrorScreen> createState() => _SearchErrorScreenState();
}

class _SearchErrorScreenState extends State<SearchErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      body: GestureDetector(
        child: Container(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: 70.h),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Container(
                        height: 218.h,
                        width: 218.w,
                        child: Image.asset('assets/images/error.png'),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Opps!',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.colorPrimary),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'Not found',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.colorWhiteHighEmp),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Sorry, the character you entered could \nnot be found. Try to check again or \nsearch with other characters.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp),
                    ),
                    Expanded(child: SizedBox()), // Spacer to push content up
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
