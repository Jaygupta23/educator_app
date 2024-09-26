import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../screens/homeScreen/trendingVideosScreen.dart';
import '../screens/movieDetailsScreen.dart';
import '../utils/appColors.dart';
import '../utils/constants.dart';

class MostTrendingShowsModel extends StatelessWidget {
  const MostTrendingShowsModel({super.key});

  @override
  Widget build(BuildContext context) {
    // List of items with image paths and titles
    final items = [
      {'image': 'assets/images/Image.png', 'title': 'Pushpa'},
      {'image': 'assets/images/Image-2.png', 'title': 'Agilan'},
      {'image': 'assets/images/Image-1.png', 'title': 'Action'},
      {'image': 'assets/images/Image.png', 'title': 'Pushpa'},
    ];

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 14, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  trendingNow,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.colorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TrendingVideosScreen()),
                    );
                  },
                  child: Text(
                    'Show all',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 125.h, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: () {
                    // Get.to(const MovieDetailsScreen());
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 16 : 10.w,
                      right: index == items.length - 1 ? 16 : 0,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              item['image']!,
                              height: 105.h,
                              width: 100.w,
                            ),
                            Text(
                              item['title']!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.colorWhiteHighEmp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 27.h,
                          right: 0.w,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(10)),
                            child: Container(
                              height: 32.h,
                              width: 30.w,
                              color: Colors.blueGrey.withOpacity(0.7),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
