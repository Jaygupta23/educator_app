import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/appColors.dart';

class LatestShowsScreen extends StatefulWidget {
  const LatestShowsScreen({Key? key}) : super(key: key);

  @override
  State<LatestShowsScreen> createState() => _LatestShowsScreenState();
}

class _LatestShowsScreenState extends State<LatestShowsScreen> {
  final List<Map<String, dynamic>> gridMap = [
    // List of maps containing the title and image path of the shows
    {
      "title": "Pushpa",
      "images": "assets/images/Image1.png",
    },
    {
      "title": "Action",
      "images": "assets/images/Image-1.png",
    },
    {
      "title": "The last Airbender",
      "images": "assets/images/Image-3.png",
    },
    {
      "title": "Top Gun Mavrik",
      "images": "assets/images/mavrik.png",
    },
    {
      "title": "Oblivion",
      "images": "assets/images/oblivion.png",
    },
    {
      "title": "Bullet Train",
      "images": "assets/images/Image-4.png",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Latest Shows'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
        actions: const [
          // Search icon button in the app bar
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            // Grid layout for the show tiles
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            mainAxisExtent: 210,
          ),
          itemCount: gridMap.length,
          itemBuilder: (_, index) {
            return Stack(children: [
              // Each show tile
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "${gridMap.elementAt(index)['images']}",
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show title
                          Text(
                            "${gridMap.elementAt(index)['title']}",
                            style:
                                Theme.of(context).textTheme.titleSmall!.merge(
                                      const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 12,
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 141,
                  left: 140,
                  child: Container(
                    height: 22.h,
                    width: 22.w,
                    decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                      child: Text(
                        '8.5',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.colorWhiteHighEmp,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ))
            ]);
          },
        ),
      ),
    );
  }
}
