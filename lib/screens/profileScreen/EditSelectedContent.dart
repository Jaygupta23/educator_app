import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:reelies/models/myBottomNavModel.dart';
import 'package:reelies/screens/interestScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/appColors.dart';
import '../onboardingScreen/genreScreen.dart';

class EditSelectedContent extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditSelectedContent({Key? key, required this.userData})
      : super(key: key);

  @override
  _EditSelectedContentState createState() => _EditSelectedContentState();
}

class _EditSelectedContentState extends State<EditSelectedContent> {
  // Initialize selected genres and languages based on userData
  List<Map<String, dynamic>> genres = [];
  List<Map<String, dynamic>> languages = [];

  // To track selected genres and languages
  List<String> selectedGenres = [];
  List<String> selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    print("props: ${widget.userData}");

    // Extract genres and languages from userData, with null checks
    if (widget.userData.containsKey('selectedGenre') &&
        widget.userData['selectedGenre'] != null) {
      genres =
          List<Map<String, dynamic>>.from(widget.userData['selectedGenre']);
      selectedGenres =
          genres.map((genre) => genre['name']?.toString() ?? '').toList();
    }
    if (widget.userData.containsKey('selectedLanguages') &&
        widget.userData['selectedLanguages'] != null) {
      languages =
          List<Map<String, dynamic>>.from(widget.userData['selectedLanguages']);
      selectedLanguages = languages
          .map((language) => language['name']?.toString() ?? '')
          .toList();
    }
  }

  // Function to handle genre and language selection
  void toggleSelection(String item, List<String> selectedList) {
    setState(() {
      if (selectedList.contains(item)) {
        selectedList.remove(item);
      } else {
        selectedList.add(item);
      }
    });
  }

  void ShowGenreContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserData = prefs.getString('userData');
    if (storedUserData != null) {
      Map<String, dynamic> userData = jsonDecode(storedUserData);
      final userId = userData['_id'] ?? ''; // Handle null userId safely
      Get.to(() => GenreScreen(userId: userId));
    }
  }

  void ShowLanguageContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserData = prefs.getString('userData');
    if (storedUserData != null) {
      Map<String, dynamic> userData = jsonDecode(storedUserData);
      final userId = userData['_id'] ?? ''; // Handle null userId safely
      Get.to(() => InterestScreen(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        backgroundColor: AppColors.colorSecondaryDarkest,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: AppColors.colorSecondaryLight,
          onPressed: () {
            Get.back(); // This will navigate back using GetX
          },
        ),
        title: const Text(
          'Edit Content Preference',
          style: TextStyle(color: AppColors.colorSecondaryLight),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            // Section for Genres
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Genre',
                  style: TextStyle(
                    color: AppColors.colorWhiteHighEmp,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.square_pencil_fill,
                  ),
                  color: AppColors.colorWhiteHighEmp,
                  onPressed: () {
                    ShowGenreContent();
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: genres.map((genre) {
                final isSelected = selectedGenres.contains(genre['name']);
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        // Shadow color with opacity
                        spreadRadius: 2,
                        // Spread radius
                        blurRadius: 6,
                        // Blur radius
                        offset: Offset(0, 3), // Offset in X and Y directions
                      ),
                    ],
                  ),
                  child: ChoiceChip(
                    label: Text(genre['name'] ?? 'Unknown'),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.colorError,
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.colorPrimary,
                    backgroundColor: Colors.transparent,
                    onSelected: (selected) {
                      toggleSelection(genre['name'] ?? '', selectedGenres);
                    },
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            // Section for Languages
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Language',
                  style: TextStyle(
                    color: AppColors.colorWhiteHighEmp,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.square_pencil_fill),
                  color: AppColors.colorWhiteHighEmp,
                  onPressed: () {
                    ShowLanguageContent();
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: languages.map((language) {
                final isSelected = selectedLanguages.contains(language['name']);
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        // Shadow color with opacity
                        spreadRadius: 2,
                        // Spread radius
                        blurRadius: 6,
                        // Blur radius
                        offset: Offset(0, 3), // Offset in X and Y directions
                      ),
                    ],
                  ),
                  child: ChoiceChip(
                    label: Text(language['name'] ?? 'Unknown'),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.colorSecondaryLight,
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.colorPrimary,
                    onSelected: (selected) {
                      toggleSelection(
                          language['name'] ?? '', selectedLanguages);
                    },
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 100),
            InkWell(
              onTap: () async {
                Get.offAll(() => MyBottomNavModel());
              },
              child: Center(
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
