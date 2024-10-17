import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/appColors.dart';

class filterContent extends StatefulWidget {
  const filterContent({super.key});

  @override
  State<filterContent> createState() => _filterContentState();
}

class _filterContentState extends State<filterContent> {
  bool isLoading = true;
  List<String> _data = [
    "All", // list of movie genres
    "Movies",
    "Drama",
    "Thriller",
    "Romance",
    "Comedy",
    "Horror",
  ];
  List<String> _selectedData = ['All'];

  _onSelected(bool selected, String data) {
    setState(() {
      if (selected) {
        _selectedData.clear(); // only one selection allowed
        _selectedData.add(data);
      } else {
        _selectedData.remove(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
                  style: const TextStyle(color: AppColors.colorWhiteHighEmp),
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
    );
  }
}
