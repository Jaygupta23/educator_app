import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/screens/authScreens/mainSignInScreen.dart';

import '../../models/onboardingModel.dart';
import '../../utils/appColors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;

  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      body: Stack(alignment: Alignment.center, children: [
        PageView.builder(
            controller: _controller,
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemCount: contents.length,
            itemBuilder: (_, i) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(contents[i].image),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 400),
                        child: Text(
                          contents[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 1.2,
                              color: Colors.white,
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        contents[i].discription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.2,
                          color: AppColors.colorDisabled,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        height: 50.h,
                        width: 280.w,
                        //margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.colorPrimary,
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            if (currentIndex == contents.length - 1) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const MainSignInScreen()));
                            }
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.bounceIn,
                            );
                          },
                          child: Center(
                            child: Text(
                              currentIndex == contents.length - 1
                                  ? "GET STARTED"
                                  : "Next",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.colorWhiteHighEmp,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        Positioned(
          top: 420,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => buildDot(index, context),
            ),
          ),
        )
      ]),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 8.h,
      margin: const EdgeInsets.all(2),
      width: currentIndex == index ? 15.w : 8.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: currentIndex == index
              ? AppColors.colorPrimary
              : AppColors.colorBlackMidEmp),
    );
  }
}
