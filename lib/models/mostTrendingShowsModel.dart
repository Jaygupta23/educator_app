import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../screens/movieDetailsScreen.dart';
import '../utils/appColors.dart';

class Show {
  final String imagePath;
  final String title;

  Show({required this.imagePath, required this.title});
}

class MostTrendingShowsModel extends StatelessWidget {
  // List of shows
  final List<Show> shows = [
    Show(imagePath: 'assets/images/Image.png', title: 'Pushpa returns back'),
    Show(
        imagePath: 'assets/images/Image-2.png',
        title: 'Agilan thriller scne part should have not'),
    Show(imagePath: 'assets/images/Image-1.png', title: 'Action movies hub'),
    Show(imagePath: 'assets/images/Image.png', title: 'Pushpa returns'),
    Show(imagePath: 'assets/images/Image-2.png', title: 'Agilan returns'),
    Show(imagePath: 'assets/images/Image-1.png', title: 'Action returns'),
    Show(imagePath: 'assets/images/Image.png', title: 'Pushpa returns'),
    Show(
        imagePath: 'assets/images/Image-2.png',
        title: 'Agilan thriller scne part should have not'),
    Show(imagePath: 'assets/images/Image-1.png', title: 'Action movies hub'),
  ];

  MostTrendingShowsModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 20),
      height: 270.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Wrap(
          direction: Axis.vertical,
          children: List.generate(
            shows.length,
            (index) {
              final show = shows[index];
              return SizedBox(
                height: (270.h) / 3,
                // Divides the height by 3 for three items in a column
                width: 200.w,
                // Fixed width for each item
                child: GestureDetector(
                  onTap: () {
                    Get.to(const MovieDetailsScreen());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          show.imagePath,
                          height: 80.h,
                          width: 70.w,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 10),
                          child: Container(
                            width: 110.w, // Set the fixed width here
                            child: Text(
                              show.title,
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.white),
                              softWrap: true,
                              maxLines: 2,
                              // Ensures the text wraps within the width
                              overflow: TextOverflow.ellipsis,
                              // Handle overflow if needed
                            ),
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
