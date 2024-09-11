import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';

class DownloadScreenProfile extends StatefulWidget {
  const DownloadScreenProfile({super.key});

  @override
  State<DownloadScreenProfile> createState() => _DownloadScreenProfileState();
}

class _DownloadScreenProfileState extends State<DownloadScreenProfile> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text(
          'Download',
          style: TextStyle(color: AppColors.colorSecondaryLight),
        ),
        backgroundColor: AppColors.colorSecondaryDarkest,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: AppColors.colorSecondaryLight,
          onPressed: () {
            Get.back(); // This will navigate back using GetX
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 12.w),
                  const Icon(
                    Icons.wifi,
                    color: AppColors.colorWhiteHighEmp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Wi-Fi Only',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.colorWhiteHighEmp,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(width: 135.w),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: AppColors.colorPrimaryLighter,
                    activeColor: AppColors.colorPrimary,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 12.w),
                      const Icon(
                        Icons.download_for_offline,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '  Smarts Download',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.colorWhiteHighEmp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 12.w),
                      const Icon(
                        Icons.high_quality,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '  Video Quality',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.colorWhiteHighEmp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 12.w),
                      const Icon(
                        Icons.mic_none,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '  Audio Quality',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.colorWhiteHighEmp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 12.w),
                      const Icon(
                        Icons.download,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '  Delete all downloads',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.colorWhiteHighEmp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 55.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.colorGrey,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 12.w),
                      const Icon(
                        Icons.delete_outline,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '  Delete Cache',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.colorWhiteHighEmp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
