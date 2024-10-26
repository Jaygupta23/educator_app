import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../../utils/appColors.dart';

class FilterContent extends StatefulWidget {
  const FilterContent({super.key});

  @override
  State<FilterContent> createState() => _FilterContentState();
}

class _FilterContentState extends State<FilterContent> {
  bool isLoading = true;
  List<Map<String, String>> imagePaths = [];
  String apiKey = dotenv.env['API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    fetchGenreItems();
  }

  Future<void> fetchGenreItems() async {
    final url = Uri.parse("http://$apiKey:8000/user/genreList/");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response data: ${data['genreList']}");
        final List genreSliders = data['genreList'];

        setState(() {
          imagePaths = [
            {
              'icon': '', // Empty icon for "All"
              'name': 'All', // "All" as the name
              '_id': 'all' // Optional ID for "All"
            },
            ...genreSliders.map((slider) {
              String fileLocation = slider['icon']?.toString() ?? '';
              String genreName = slider['name']?.toString() ?? 'Unknown';
              String sliderId = slider['_id']?.toString() ?? '';
              String updatedPath = fileLocation.replaceFirst(
                'uploads/genreImage',
                'http://$apiKey:8765/genreIcon/',
              );
              return {
                'icon': updatedPath,
                'name': genreName,
                '_id': sliderId,
              };
            }).toList()
          ];

          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load images, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching genre: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
            children: imagePaths.map((data) {
              return FilterChip(
                showCheckmark: false,
                backgroundColor: AppColors.colorSecondaryDarkest,
                label: Text(
                  data['name'] ?? 'Unknown', // Access genre name
                  style: const TextStyle(color: AppColors.colorWhiteHighEmp),
                ),
                shape: const StadiumBorder(
                    side: BorderSide(color: AppColors.colorPrimary)),
                selected: _selectedData.contains(data['name']),
                selectedColor: AppColors.colorPrimary,
                padding: const EdgeInsets.all(5),
                onSelected: (selected) =>
                    _onSelected(selected, data['name'] ?? ''),
              );
            }).toList(),
          ),
          SizedBox(width: 16.w),
        ],
      ),
    );
  }
}
