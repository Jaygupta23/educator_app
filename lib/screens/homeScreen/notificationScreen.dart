import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/appColors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen(
      {super.key}); // Define a StatefulWidget for the notification screen

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState(); // Returns the state for the notification screen
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> listMap = [
    // Define a list of maps containing data for each item in the notification list
    {
      "title": "Pushpa",
      "subtitle": "2h 30min",
      "subtitle2": "Uploaded: 12 December, 2022",
      "images": "assets/images/Image1.png",
    },
    {
      "title": "Action",
      "subtitle": "2h 30min",
      "subtitle2": "Uploaded: 12 December, 2022",
      "images": "assets/images/Image-1.png",
    },
    {
      "title": "The Airbender",
      "subtitle": "2h 30min",
      "subtitle2": "Uploaded: 12 December, 2022",
      "images": "assets/images/Image-3.png",
    },
    {
      "title": "Top Gun Mavrik",
      "subtitle": "2h 30min",
      "subtitle2": "Uploaded: 12 December, 2022",
      "images": "assets/images/mavrik.png",
    },
    {
      "title": "Oblivion",
      "subtitle": "2h 30min",
      "subtitle2": "Uploaded: 12 December, 2022",
      "images": "assets/images/oblivion.png",
    },
    {
      "title": "Fallout",
      "subtitle": "2h 30min",
      "subtitle2": "Uploaded: 12 December, 2022",
      "images": "assets/images/fallout.png",
    },
    {
      "title": "Bullet Train",
      "subtitle": "2h 30min",
      "subtitle2": "Uploaded: 12 December, 2022",
      "images": "assets/images/Image-4.png",
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Build the UI for the notification screen
    return Scaffold(
      backgroundColor: AppColors
          .colorSecondaryDarkest, // Set the background color of the screen
      appBar: AppBar(
        title: const Text('Notifications'), // Set the title of the app bar
        backgroundColor: AppColors
            .colorSecondaryDarkest, // Set the background color of the app bar
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
            ), // Add a more options icon to the app bar
          )
        ],
      ),
      body: ListView.builder(
        itemCount: listMap.length,
        // Set the number of items in the list view to the length of the listMap
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Stack(children: [
                Container(
                    height: 85.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.colorGrey,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              "${listMap.elementAt(index)['images']}",
                              height: 60.h,
                              width: 60.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${listMap.elementAt(index)['title']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.colorWhiteHighEmp,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                ),
                                Text(
                                  "${listMap.elementAt(index)['subtitle']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.colorWhiteHighEmp,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  "${listMap.elementAt(index)['subtitle2']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.colorWhiteHighEmp,
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              height: 32,
                              width: 92,
                              decoration: BoxDecoration(
                                color: AppColors.colorPrimary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  'Watch Now',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.colorWhiteHighEmp,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const Positioned(
                    top: 40,
                    left: 32,
                    child: Icon(
                      Icons.play_circle_rounded,
                      color: AppColors.colorWhiteHighEmp,
                    )),
              ]),
            ),
          );
        },
      ),
    );
  }
}
