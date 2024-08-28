import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/appColors.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final List<Map<String, dynamic>> listMap = [
    {
      "title": "Avatar",
      "subtitle": "8 Seasons",
      "images": "assets/images/avatar.png",
    },
    {
      "title": "Avatar 2",
      "subtitle": "8 Seasons",
      "images": "assets/images/avatar2.png",
    },
    {
      "title": "Avatar",
      "subtitle": "8 Seasons",
      "images": "assets/images/avatar.png",
    },
    {
      "title": "Avatar 2",
      "subtitle": "8 Seasons",
      "images": "assets/images/avatar2.png",
    },
    {
      "title": "Avatar",
      "subtitle": "8 Seasons",
      "images": "assets/images/avatar.png",
    },
    {
      "title": "Avatar 2",
      "subtitle": "8 Seasons",
      "images": "assets/images/avatar2.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Download'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.search,
              color: AppColors.colorWhiteHighEmp,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: listMap.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Stack(children: [
                      Container(
                          height: 110.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppColors.colorGrey,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  AppColors.colorWhiteHighEmp,
                                              fontSize: 10,
                                            ),
                                          ),
                                    ),
                                    SizedBox(height: 5.h),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 32.h,
                                        width: 92.w,
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
                                                    fontWeight: FontWeight.w400,
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
                                SizedBox(width: 70.w),
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.45,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: SizedBox(
                                              height: 20.h,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 1.6.h),
                                                  Center(
                                                    child: Image.asset(
                                                        'assets/images/top.png',
                                                        height: 4.h,
                                                        width: 32.w),
                                                  ),
                                                  SizedBox(height: 1.5.h),
                                                  Center(
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors
                                                            .colorWhiteHighEmp,
                                                        fontSize: 24.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Center(
                                                    child: Text(
                                                      'Are you sure want to delete this Movie\ndownloaded?',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .colorWhiteHighEmp,
                                                          fontSize: 14.sp,
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.5.h),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 60),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image.asset(
                                                            'assets/images/avatar.png',
                                                            height: 90.h,
                                                            width: 160.w),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              'Avatar',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: AppColors
                                                                    .colorWhiteHighEmp,
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 2.h),
                                                            Text(
                                                              '1hr  47m  54s',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: AppColors
                                                                    .colorWhiteHighEmp,
                                                                fontSize: 8.sp,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10.h),
                                                            Container(
                                                              height: 15,
                                                              width: 53,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .colorWhiteMidEmp,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  '1.34 GB',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: AppColors
                                                                        .colorPrimary,
                                                                    fontSize:
                                                                        10.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Container(
                                                          height: 45.h,
                                                          width: 148.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .colorWhiteMidEmp,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                                'CANCEL',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: AppColors
                                                                      .colorSecondaryDarkest,
                                                                  fontSize:
                                                                      16.sp,
                                                                )),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20.w),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Container(
                                                          height: 45.h,
                                                          width: 148.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .colorPrimary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'DELETE',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                  child: const Icon(
                                    CupertinoIcons.delete,
                                    color: AppColors.colorPrimary,
                                    size: 24,
                                  ),
                                )
                              ],
                            ),
                          )),
                      const Positioned(
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
