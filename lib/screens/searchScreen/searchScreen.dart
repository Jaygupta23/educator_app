import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/screens/searchScreen/searchList.dart';
import 'package:reelies/screens/searchScreen/sortFilterChips/categoryChips.dart';
import 'package:reelies/screens/searchScreen/sortFilterChips/genreChips.dart';
import 'package:reelies/screens/searchScreen/sortFilterChips/regionChips.dart';
import 'package:reelies/screens/searchScreen/sortFilterChips/sortChips.dart';
import 'package:reelies/screens/searchScreen/sortFilterChips/timeChips.dart';

import '../../utils/appColors.dart';
import 'filterResultScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Map<String, dynamic>> gridMap = [
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
      "title": "Fallout",
      "images": "assets/images/fallout.png",
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
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.h,
                    width: 260.w,
                    child: TextField(
                      onSubmitted: (value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchListScreen()));
                      },
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        hintText: "Search",
                        filled: true,
                        fillColor: AppColors.colorGrey,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8)),
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
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SizedBox(
                                height: 50.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                          height: 4,
                                          width: 32,
                                          child: Image.asset(
                                              'assets/images/top.png')),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Text(
                                        'Sort & Filter',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.colorWhiteHighEmp,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                          width: 312,
                                          child: Image.asset(
                                              'assets/images/Separator.png')),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Category',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16,
                                      ),
                                    ),
                                    CategoryChips(),
                                    //SizedBox(height: 10),
                                    Text(
                                      'Regions',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16,
                                      ),
                                    ),
                                    RegionChips(),
                                    //SizedBox(height: 10),
                                    Text(
                                      'Genre',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16,
                                      ),
                                    ),
                                    GenreChips(),
                                    //SizedBox(height: 10),
                                    Text(
                                      'Time/Periods',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TimeChips(),
                                    //SizedBox(height: 10),
                                    Text(
                                      'Sort',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SortChips(),
                                    SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 148,
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.colorWhiteHighEmp,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'RESET',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors
                                                      .colorSecondaryDarkest,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FilterResultScreen()));
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
                                                'APPLY',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors
                                                      .colorWhiteHighEmp,
                                                  fontSize: 16,
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
                      height: 52.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                          color: AppColors.colorGrey,
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(
                        Icons.filter_list,
                        size: 28,
                        color: AppColors.colorSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    mainAxisExtent: 210,
                  ),
                  itemCount: gridMap.length,
                  itemBuilder: (_, index) {
                    return Stack(children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  Text(
                                    "${gridMap.elementAt(index)['title']}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .merge(
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
                          left: 135,
                          child: Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                                color: AppColors.colorPrimary,
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text(
                                '8.5',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.colorWhiteHighEmp,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ))
                    ]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
