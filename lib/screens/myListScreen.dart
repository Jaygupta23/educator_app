// Importing required packages
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/utils/appColors.dart';

// Stateful widget for MyListScreen
class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

// State class for MyListScreen
class _MyListScreenState extends State<MyListScreen> {
// List of all filter chips
  List<String> _data = [
    "K-Drama",
    "South Korea",
    "Action",
    "Sci-fi",
    "Hollywood",
  ];

// List of selected filter chips
  List<String> _selectedData = [];

// Method to handle selection of filter chips
  _onSelected(bool selected, String data) {
    setState(() {
      if (selected) {
        _selectedData.clear();
        _selectedData.add(data);
      } else {
        _selectedData.remove(data);
      }
    });
  }

// List of data for gridview
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
        appBar: AppBar(
          title: const Text('My List'),
          backgroundColor: AppColors.colorSecondaryDarkest,
          elevation: 0,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.search),
            )
          ],
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  SizedBox(width: 16.w),
                  Wrap(
                    spacing: 5,
                    runSpacing: 3,
                    children: _data.map((data) {
                      return FilterChip(
                        showCheckmark: false,
                        backgroundColor: AppColors.colorSecondaryDarkest,
                        label: Text(
                          data,
                          style: const TextStyle(
                              color: AppColors.colorWhiteHighEmp),
                        ),
                        shape: const StadiumBorder(
                            side: BorderSide(color: AppColors.colorPrimary)),
                        selected: _selectedData.contains(data),
                        selectedColor: AppColors.colorPrimary,
                        padding: const EdgeInsets.all(5),
                        onSelected: (selected) => _onSelected(selected, data),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 16.w),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
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
                                          TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.colorWhiteHighEmp,
                                            fontSize: 12.sp,
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
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ))
                    ]);
                  },
                ),
              ),
            )
          ],
        ));
  }
}
