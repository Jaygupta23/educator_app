import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../..'
    '/models/myBottomNavModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/appColors.dart';
import 'onboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward().whenComplete(() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? storedUserData = prefs.getString('userData');
        if (storedUserData != null) {
          // Decode the storedUserData string to JSON
          var userData = jsonDecode(storedUserData);
          print("userdata: $userData");

          if (userData['loggedInBefore'] == true) {
            Get.off(() => const MyBottomNavModel());
          } else {
            Get.off(() => const OnBoardingScreen());
          }
        } else {
          // Handle case where there is no userData stored
          Get.off(() => const OnBoardingScreen());
        }
      });

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhiteHighEmp,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Center(
                      child: Image.asset('assets/images/logo_dark.png',
                          width: 600.w, height: 350.h),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
