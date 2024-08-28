import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/appColors.dart';

class FilterResultScreen extends StatefulWidget {
  const FilterResultScreen({super.key});

  @override
  State<FilterResultScreen> createState() => _FilterResultScreenState();
}

class _FilterResultScreenState extends State<FilterResultScreen> {
  List<String> _data = [
    "K-Drama",
    "South Korea",
    "Action",
    "Hollywood",
  ];
  List<String> _selectedData = [];

  _onSelected(bool selected, String data) {
    setState(() {
      if (selected) {
        _selectedData.add(data);
      } else {
        _selectedData.remove(data);
      }
    });
  }

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
      body: Column(
        children: [
          SizedBox(height: 60.h),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 55.h,
                  width: 270.w,
                  child: TextField(
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
                  height: 53.h,
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
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 5,
            children: _data.map((data) {
              return FilterChip(
                showCheckmark: false,
                backgroundColor: AppColors.colorPrimary,
                label: Text(
                  data,
                  style: TextStyle(color: AppColors.colorWhiteHighEmp),
                ),
                shape: StadiumBorder(
                    side: BorderSide(color: AppColors.colorPrimary)),
                selected: _selectedData.contains(data),
                selectedColor: AppColors.colorPrimary,
                padding: EdgeInsets.all(5),
                onSelected: (selected) => _onSelected(selected, data),
              );
            }).toList(),
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
                  mainAxisSpacing: 13,
                  mainAxisExtent: 240,
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
                              height: 170.h,
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
                        top: 160,
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
    );
  }
}
