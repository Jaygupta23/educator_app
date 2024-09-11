import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/screens/authScreens/mainSignInScreen.dart';
import 'package:reelies/screens/profileScreen/downloadScreenProfile.dart';
import 'package:reelies/screens/profileScreen/languageScreenProfile.dart';
import 'package:reelies/screens/profileScreen/notificationScreenProfile.dart';
import 'package:reelies/screens/profileScreen/privacyPolicyScreen.dart';
import 'package:reelies/screens/profileScreen/securityScreenProfile.dart';
import 'package:reelies/screens/profileScreen/subToPremiumScreen.dart';
import 'package:get/get.dart';
import '../../utils/appColors.dart';
import 'editProfileScreen.dart';
import 'helpCenterScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.colorSecondaryDarkest,
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(color: AppColors.colorSecondaryLight),
          ),
          backgroundColor: AppColors.colorSecondaryDarkest,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Image.asset('assets/images/profile2.png',
                    height: 100.h, width: 100.w),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      Center(
                          child: Text(
                        'Alexandar Golap',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 24.sp,
                        ),
                      )),
                      Center(
                        child: Text(
                          'username@website.com',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorWhiteHighEmp,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.to(const SubToPremiumScreen());
                        },
                        child: Container(
                          height: 70.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.colorSecondaryDarkest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 1, color: AppColors.colorPrimary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.colorPrimary,
                                  child: Center(
                                    child: Image.asset(
                                        'assets/images/crown.png',
                                        height: 15.h,
                                        width: 18.w),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Get Premium!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Text(
                                      'Generated faux Swedish for the masses!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 12.sp,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(width: 12.w),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 16,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const EditProfileScreen());
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          //
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: "Edit profile",
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 26,
                                ),
                                hintStyle: TextStyle(
                                    color: AppColors.colorWhiteHighEmp),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 16,
                                )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const NotificationScreenProfile());
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: "Notification Settings",
                                prefixIcon: Icon(
                                  Icons.notifications,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 26,
                                ),
                                hintStyle: TextStyle(
                                    color: AppColors.colorWhiteHighEmp),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 16,
                                )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const DownloadScreenProfile());
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: "Download",
                                prefixIcon: Icon(
                                  Icons.download,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 26,
                                ),
                                hintStyle: TextStyle(
                                    color: AppColors.colorWhiteHighEmp),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 16,
                                )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const SecurityScreenProfile());
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: "Security",
                                prefixIcon: Icon(
                                  Icons.security,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 26,
                                ),
                                hintStyle: TextStyle(
                                    color: AppColors.colorWhiteHighEmp),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 16,
                                )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const LanguageScreenProfile());
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText:
                                    "language                      English(US)",
                                prefixIcon: Icon(
                                  Icons.language,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 26,
                                ),
                                hintStyle: TextStyle(
                                    color: AppColors.colorWhiteHighEmp),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 16,
                                )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const HelpCenterScreen());
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: "Help Center",
                                prefixIcon: Icon(
                                  Icons.help,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 26,
                                ),
                                hintStyle: TextStyle(
                                    color: AppColors.colorWhiteHighEmp),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 16,
                                )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(const PrivacyPolicyScreen());
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: "Privacy Policy",
                                prefixIcon: Icon(
                                  Icons.privacy_tip,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 26,
                                ),
                                hintStyle: TextStyle(
                                    color: AppColors.colorWhiteHighEmp),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 16,
                                )),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet<void>(
                            backgroundColor: AppColors.colorGrey,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24.0),
                                topRight: Radius.circular(24.0),
                              ),
                            ),
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Image.asset(
                                              'assets/images/top.png',
                                              height: 4.h,
                                              width: 32.w),
                                        ),
                                        SizedBox(height: 1.5.h),
                                        Center(
                                          child: Text(
                                            'Logout',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  AppColors.colorWhiteHighEmp,
                                              fontSize: 24.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                        Center(
                                          child: Text(
                                            'Are you sure want to log out?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    AppColors.colorWhiteHighEmp,
                                                fontSize: 14.sp,
                                                height: 1.2),
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                height: 45.h,
                                                width: 148.w,
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .colorWhiteMidEmp,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'CANCEL',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .colorSecondaryDarkest,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20.w),
                                            InkWell(
                                              onTap: () {
                                                Get.offAll(
                                                    const MainSignInScreen());
                                              },
                                              child: Container(
                                                height: 45,
                                                width: 148,
                                                decoration: BoxDecoration(
                                                  color: AppColors.colorPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Log Out',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .colorWhiteHighEmp,
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
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 50.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            enabled: false,
                            decoration: InputDecoration(
                                hintText: "Logout",
                                prefixIcon: Icon(
                                  Icons.logout,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 26,
                                ),
                                hintStyle: TextStyle(
                                    color: AppColors.colorWhiteHighEmp),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppColors.colorWhiteHighEmp,
                                  size: 16,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
