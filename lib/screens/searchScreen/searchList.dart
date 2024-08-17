import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/screens/searchScreen/searchErrorScreen.dart';

import '../../utils/appColors.dart';

class SearchListScreen extends StatefulWidget {
  const SearchListScreen({super.key});

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  int _selectedIndex = 2;

  final List<Map<String, dynamic>> listMap = [
    {
      "title": "Avatar",
      "subtitle":
          "established fact that a reader will b\n distract by the readable",
      "subtitle2": "Uploaded: 12 December, 2022",
      "images": "assets/images/avatar.png",
    },
    {
      "title": "Avatar 2",
      "subtitle":
          "established fact that a reader will be\n distract by the readable",
      "subtitle2": "Uploaded: 12 December, 2022",
      "images": "assets/images/avatar2.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      body: Column(
        children: [
          SizedBox(height: 60.h),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 60.h,
                  width: 260.w,
                  child: TextField(
                    onSubmitted: (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchErrorScreen()));
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
                Container(
                  height: 52.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(
                    Icons.filter_list,
                    size: 28,
                    color: AppColors.colorSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listMap.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Stack(children: [
                      Container(
                          height: 130.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColors.colorGrey,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  height: 92.h,
                                  width: 108.w,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      "${listMap.elementAt(index)['images']}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${listMap.elementAt(index)['title']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .merge(
                                              const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppColors.colorWhiteHighEmp,
                                                fontSize: 16,
                                              ),
                                            ),
                                      ),
                                      Text(
                                        "${listMap.elementAt(index)['subtitle']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .merge(
                                              const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    AppColors.colorWhiteLowEmp,
                                                fontSize: 10,
                                              ),
                                            ),
                                      ),
                                      SizedBox(height: 5.h),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 32,
                                          width: 92,
                                          decoration: BoxDecoration(
                                            color: AppColors.colorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Watch Now',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .merge(
                                                    const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .colorWhiteHighEmp,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          )),
                      Positioned(
                          top: 45,
                          left: 55,
                          child: Icon(
                            Icons.play_circle_rounded,
                            color: AppColors.colorWhiteHighEmp,
                          )),
                    ]),
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
