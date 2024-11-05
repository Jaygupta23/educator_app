import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/screens/authScreens/mainSignInScreen.dart';
import 'package:reelies/screens/profileScreen/EditSelectedContent.dart';
import 'package:reelies/screens/profileScreen/downloadScreenProfile.dart';
import 'package:reelies/screens/profileScreen/languageScreenProfile.dart';
import 'package:reelies/screens/profileScreen/notificationScreenProfile.dart';
import 'package:reelies/screens/profileScreen/privacyPolicyScreen.dart';
import 'package:reelies/screens/profileScreen/securityScreenProfile.dart';
import 'package:reelies/screens/profileScreen/subToPremiumScreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/appColors.dart';
import 'editProfileScreen.dart';
import 'helpCenterScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String apiKey = dotenv.env['API_KEY'] ?? '';
  List<Map<String, dynamic>> userDetails = [];
  bool isLoading = false;
  File? _imageFile;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fetchUserDetails();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImagePath');

    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> fetchUserDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUserData = prefs.getString('userData');

      if (storedUserData != null) {
        // Decode the stored user data from JSON
        Map<String, dynamic> userData = jsonDecode(storedUserData);

        // Debugging: Print retrieved user data
        print("Retrieved user data: $userData");

        // Update the state with user details
        setState(() {
          userDetails.clear();
          userDetails.add({
            '_id': userData['_id'],
            'name': userData['name'],
            'email': userData['email'],
            'mobile': userData['mobile'],
            'gender': userData['gender'],
            'loggedInBefore': true,
            'selectedGenre': userData['selectedGenre'],
            // Full genre data
            'selectedLanguages': userData['selectedLanguages'],
            // Full languages data
          });

          // Print user details for debugging
          print("User Details: $userDetails");
        });
      } else {
        print("No user data found in SharedPreferences.");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
                SizedBox(
                  height: 86.h,
                  width: 86.w,
                  child: CircleAvatar(
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const AssetImage('assets/images/blank.webp')
                            as ImageProvider,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: isLoading // Show loading indicator while fetching
                      ? CircularProgressIndicator()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10.h),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${userDetails.isNotEmpty ? userDetails[0]['name'] : 'N/A'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.colorWhiteHighEmp,
                                    fontSize: 24.sp,
                                  ),
                                ),
                                SizedBox(height: 4),
                                // Add some space between name and email
                                Text(
                                  '${userDetails.isNotEmpty ? userDetails[0]['email'] : 'N/A'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.colorWhiteHighEmp,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            InkWell(
                              onTap: () {
                                Get.to(() => const SubToPremiumScreen());
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Get Premium!',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  AppColors.colorWhiteHighEmp,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          Text(
                                            'Generate subscription for this account',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.colorWhiteHighEmp,
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
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => EditProfileScreen(
                                    userData: userDetails[0]));
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
                                Get.to(() => EditSelectedContent(
                                    userData: userDetails[0]));
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
                                      hintText: "Edit Content Refrence",
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
                                          MediaQuery.of(context).size.height *
                                              0.23,
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
                                                    color: AppColors
                                                        .colorWhiteHighEmp,
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .colorWhiteHighEmp,
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
                                                            BorderRadius
                                                                .circular(6),
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
                                                    onTap: () async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      await prefs.clear();
                                                      Get.offAll(
                                                          MainSignInScreen());
                                                    },
                                                    child: Container(
                                                      height: 45,
                                                      width: 148,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .colorPrimary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
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
