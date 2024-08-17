import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/appColors.dart';

class SecurityScreenProfile extends StatefulWidget {
  const SecurityScreenProfile({super.key});

  @override
  State<SecurityScreenProfile> createState() => _SecurityScreenProfileState();
}

class _SecurityScreenProfileState extends State<SecurityScreenProfile> {
  bool isSwitched = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Security'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Control',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(8)),
                child: const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: "   Security Alerts",
                      hintStyle: TextStyle(color: AppColors.colorWhiteHighEmp),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.colorWhiteHighEmp,
                        size: 16,
                      )),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(8)),
                child: const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: "   Manage Devices",
                      hintStyle: TextStyle(color: AppColors.colorWhiteHighEmp),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.colorWhiteHighEmp,
                        size: 16,
                      )),
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(8)),
                child: const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: "   Manage Permision",
                      hintStyle: TextStyle(color: AppColors.colorWhiteHighEmp),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.colorWhiteHighEmp,
                        size: 16,
                      )),
                ),
              ),
              SizedBox(height: 10.h),
              Divider(height: 20.h),
              Text(
                'Security',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorWhiteHighEmp,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '   Remember me',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
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
                  )),
              SizedBox(height: 10.h),
              Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '   Biometric ID',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
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
                  )),
              SizedBox(height: 10.h),
              Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '   Face ID',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 16.sp,
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
                  )),
              SizedBox(height: 10.h),
              Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.colorGrey,
                    borderRadius: BorderRadius.circular(8)),
                child: const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      hintText: "   Google Authenticor",
                      hintStyle: TextStyle(color: AppColors.colorWhiteHighEmp),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.colorWhiteHighEmp,
                        size: 16,
                      )),
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ProfileScreen()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.colorWhiteHighEmp),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'CHANGE PIN',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorSecondaryDarkest),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ProfileScreen()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.colorPrimary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'CHANGE PASSWORD',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
