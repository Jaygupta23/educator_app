import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/latestShowsModel.dart';
import 'package:reelies/screens/homeScreen/latestShowsScreen.dart';
import 'package:reelies/screens/homeScreen/trendingVideosScreen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/appColors.dart';
import '../../utils/constants.dart';
import 'notificationScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _data = [
    "All", // list of movie genres
    "Movies",
    "Drama",
    "Thriller",
    "Romance",
    "Comedy",
    "Horror",
  ];
  List<String> _selectedData =
      []; // initially empty list for selected movie genres

// function to handle selection of movie genres
  _onSelected(bool selected, String data) {
    setState(() {
      // this is likely within a StatefulWidget's build() method
      if (selected) {
        // if the genre is selected
        _selectedData
            .clear(); // clear the previous selection (only one selection allowed)
        _selectedData.add(data); // add the selected genre to _selectedData
      } else {
        // if the genre is deselected
        _selectedData.remove(data); // remove it from the selected genres list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container with background image and some text
              Container(
                height: 460.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/homeBig.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Notification icon
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              Get.to(const NotificationScreen());
                            },
                            icon: Icon(
                              Icons.notifications,
                              size: 26.sp,
                              color: AppColors.colorWhiteHighEmp,
                            )),
                      ),
                    ),
                    // Title and play button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'The Winter Lake',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '8 Seasons | Thriller | 2020',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              SizedBox(width: 10.w),
                              // Play button
                              MaterialButton(
                                onPressed: () {},
                                height: 45.h,
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: AppColors.colorSecondaryLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: SizedBox(
                                    height: 42.h,
                                    width: 104.w,
                                    child: Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.play_circle_outline,
                                          color: AppColors.colorWhiteHighEmp,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Play',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Playlist icon
                          Container(
                            height: 42.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  width: 1, color: AppColors.colorWhiteHighEmp),
                            ),
                            child: const Icon(
                              Icons.playlist_add,
                              color: AppColors.colorWhiteHighEmp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Create a row with a title and a "show all" button
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 14, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title text for "Latest Shows"
                    Text(
                      'Latest Shows',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // "Show all" button that navigates to LatestShowsScreen on tap
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LatestShowsScreen()),
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

              SingleChildScrollView(
                // A widget that allows its child to scroll horizontally
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 16.w), // A box with a fixed width
                    Wrap(
                      spacing:
                          5, // The amount of spacing between chips horizontally
                      runSpacing:
                          3, // The amount of spacing between chips vertically
                      children: _data.map((data) {
                        // Map each item in _data to a FilterChip widget
                        return FilterChip(
                          showCheckmark: false,
                          // Whether to show a checkmark when selected
                          backgroundColor: AppColors.colorSecondaryDarkest,
                          // The background color of the chip
                          label: Text(
                            data,
                            style: const TextStyle(
                                color: AppColors
                                    .colorWhiteHighEmp), // The label text of the chip
                          ),
                          shape: const StadiumBorder(
                              side: BorderSide(color: AppColors.colorPrimary)),
                          // The border shape of the chip
                          selected: _selectedData.contains(data),
                          // Whether the chip is selected
                          selectedColor: AppColors.colorPrimary,
                          // The background color of the chip when selected
                          padding: const EdgeInsets.all(5),
                          // The padding of the chip
                          onSelected: (selected) => _onSelected(selected,
                              data), // The callback function when the chip is selected/deselected
                        );
                      }).toList(), // Convert the mapped FilterChip widgets to a list
                    ),
                    SizedBox(width: 16.w), // A box with a fixed width
                  ],
                ),
              ),

              const LatestShowsModel(),
              // Creates a Padding widget with specific padding and a Row widget as a child
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 14, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
// Displays the "trendingNow" text using a Text widget with a specific style
                    Text(
                      trendingNow,
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.w600),
                    ),
// Displays the "Show all" text using an InkWell widget that navigates to the TrendingVideosScreen on tap
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TrendingVideosScreen()));
                      },
                      child: Text(
                        'Show all',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.colorWhiteHighEmp,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
              const LatestShowsModel(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
