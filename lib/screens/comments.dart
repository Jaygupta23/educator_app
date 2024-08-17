import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/appColors.dart';

class Comments extends StatelessWidget {
  const Comments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.colorSecondaryDarkest,
        appBar: AppBar(
          title: const Text('Comments'),
          backgroundColor: AppColors.colorSecondaryDarkest,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2.5k Comments',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorWhiteHighEmp,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            height: 32.h,
                            width: 32.w,
                            child: Image.asset('assets/images/img5.png')),
                        SizedBox(width: 10.w),
                        Text(
                          'Kristin Watson',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Lörem ipsum suben beng häkönat pärlifiera. Dotivis astroras, prer. Sohäns komtes, sad fastän debårade hexasm. Fånegen teleskop. Degt oling laddstolpe resam. ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: AppColors.colorPrimary,
                          size: 22.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '356',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '4 days ago',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Reply',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            height: 32.h,
                            width: 32.w,
                            child: Image.asset('assets/images/img5.png')),
                        SizedBox(width: 10.w),
                        Text(
                          'Kristin Watson',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Lörem ipsum suben beng häkönat pärlifiera. Dotivis astroras, prer. Sohäns komtes, sad fastän debårade hexasm. Fånegen teleskop. Degt oling laddstolpe resam. ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: AppColors.colorWhiteHighEmp,
                          size: 22,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '356',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '4 days ago',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Reply',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            height: 32.h,
                            width: 32.w,
                            child: Image.asset('assets/images/img5.png')),
                        SizedBox(width: 10.w),
                        Text(
                          'Kristin Watson',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Lörem ipsum suben beng häkönat pärlifiera. Dotivis astroras, prer. Sohäns komtes, sad fastän debårade hexasm. Fånegen teleskop. Degt oling laddstolpe resam. ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: AppColors.colorWhiteHighEmp,
                          size: 22,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '356',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '4 days ago',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Reply',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            height: 32.h,
                            width: 32.w,
                            child: Image.asset('assets/images/img5.png')),
                        SizedBox(width: 10.w),
                        Text(
                          'Kristin Watson',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Lörem ipsum suben beng häkönat pärlifiera. Dotivis astroras, prer. Sohäns komtes, sad fastän debårade hexasm. Fånegen teleskop. Degt oling laddstolpe resam. ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: AppColors.colorPrimary,
                          size: 22.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '356',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '4 days ago',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Reply',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60.h,
            decoration: BoxDecoration(
              color: AppColors.colorGrey,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 45.h,
                  width: 252.w,
                  decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    style: TextStyle(color: AppColors.colorDisabled),
                    decoration: InputDecoration(
                        hintText: "Add a Comment",
                        hintStyle:
                            TextStyle(color: AppColors.colorWhiteHighEmp),
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: AppColors.colorWhiteHighEmp,
                          size: 26,
                        )),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  height: 40.h,
                  width: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.colorPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: AppColors.colorWhiteHighEmp,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
