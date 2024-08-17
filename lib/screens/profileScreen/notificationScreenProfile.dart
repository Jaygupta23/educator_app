import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/appColors.dart';

class NotificationScreenProfile extends StatefulWidget {
  const NotificationScreenProfile({super.key});

  @override
  State<NotificationScreenProfile> createState() =>
      _NotificationScreenProfileState();
}

class _NotificationScreenProfileState extends State<NotificationScreenProfile> {
  bool isSwitched = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isSwitched4 = false;
  bool isSwitched5 = false;
  bool isSwitched6 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppColors.colorSecondaryDarkest,
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
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '  General Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 14.sp,
                        ),
                      ),
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
                )),
            SizedBox(height: 10.h),
            Container(
                height: 55.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '  New Arival',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 14.sp,
                        ),
                      ),
                      Switch(
                        value: isSwitched2,
                        onChanged: (value) {
                          setState(() {
                            isSwitched2 = value;
                            print(isSwitched2);
                          });
                        },
                        activeTrackColor: AppColors.colorPrimaryLighter,
                        activeColor: AppColors.colorPrimary,
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 10.h),
            Container(
                height: 55.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '  New Services Available',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 14.sp,
                        ),
                      ),
                      Switch(
                        value: isSwitched3,
                        onChanged: (value) {
                          setState(() {
                            isSwitched3 = value;
                            print(isSwitched3);
                          });
                        },
                        activeTrackColor: AppColors.colorPrimaryLighter,
                        activeColor: AppColors.colorPrimary,
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 10.h),
            Container(
                height: 55.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '  New release movie',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 14.sp,
                        ),
                      ),
                      Switch(
                        value: isSwitched4,
                        onChanged: (value) {
                          setState(() {
                            isSwitched4 = value;
                            print(isSwitched4);
                          });
                        },
                        activeTrackColor: AppColors.colorPrimaryLighter,
                        activeColor: AppColors.colorPrimary,
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 10.h),
            Container(
                height: 55.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '  Apps update',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 14.sp,
                        ),
                      ),
                      Switch(
                        value: isSwitched5,
                        onChanged: (value) {
                          setState(() {
                            isSwitched5 = value;
                            print(isSwitched5);
                          });
                        },
                        activeTrackColor: AppColors.colorPrimaryLighter,
                        activeColor: AppColors.colorPrimary,
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 10.h),
            Container(
                height: 55.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '  Subscriptions',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 14.sp,
                        ),
                      ),
                      Switch(
                        value: isSwitched6,
                        onChanged: (value) {
                          setState(() {
                            isSwitched6 = value;
                            print(isSwitched6);
                          });
                        },
                        activeTrackColor: AppColors.colorPrimaryLighter,
                        activeColor: AppColors.colorPrimary,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
