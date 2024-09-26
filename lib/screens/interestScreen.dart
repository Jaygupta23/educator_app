import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/myBottomNavModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/appColors.dart';

class InterestScreen extends StatefulWidget {
  final String userId;

  const InterestScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  List<String> _selectedData = [];
  String apiKey = dotenv.env['API_KEY'] ?? ''; // Ensure API_KEY is set in .env
  List<Map<String, dynamic>> _languages = []; // List to hold languages
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchLanguages(); // Fetch languages when the widget is initialized
  }

  Future<void> fetchLanguages() async {
    final url = Uri.parse(
        "http://$apiKey:8000/user/languageList"); // Use the API key from .env

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = jsonDecode(response.body);
        // Extract the language list
        List<dynamic> languageList = jsonResponse['languageList'];
        print(languageList); // Print for debugging

        // Convert to List<Map<String, dynamic>>
        List<Map<String, dynamic>> languages = languageList.map((language) {
          return {
            'id': language['_id'], // Extracting ID
            'name': language['name'], // Extracting name
          };
        }).toList();

        setState(() {
          _languages = languages; // Update the state with fetched languages
          _isLoading = false; // Set loading to false after fetching
        });
      } else {
        throw Exception('Failed to load languages');
      }
    } catch (e) {
      print('Error fetching languages: $e');
      setState(() {
        _isLoading = false; // Set loading to false on error
      });
    }
  }

  Future<List<String>> getSelectedLanguageIds(
      List<String> selectedLanguages) async {
    List<String> selectedLanguageIds = [];

    for (String language in selectedLanguages) {
      // Find the corresponding language object in _languages
      Map<String, dynamic>? languageObj = _languages.firstWhere(
        (lang) => lang['name'] == language,
        orElse: () =>
            {'id': '', 'name': ''}, // Return a default map instead of null
      );

      // Check if the id is not empty before adding
      if (languageObj['id'] != '') {
        selectedLanguageIds.add(languageObj['id']);
      }
    }

    return selectedLanguageIds;
  }

  Future<void> setLanguages(List<String> languageIds) async {
    print("languageIds: $languageIds");
    final url = Uri.parse("http://$apiKey:8000/user/languageSelector/");
    try {
      final loginId = widget.userId;
      final body = {
        'userId': loginId,
        'selectedLanguages': languageIds,
      };
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print(responseData['msg']);
        Future.delayed(Duration(milliseconds: 100), () {
          Get.to(() =>
              const MyBottomNavModel()); // Navigate to bottom navigation model
        });
      } else {
        print('Failed to set languages: ${response.statusCode}');
        // await showNotification(
        //   'Try Again',
        //   'Something went wrong!',
        // );
      }
    } catch (e) {
      print('Error saving languages: $e');
      setState(() {
        _isLoading = false; // Set loading to false on error
      });
    }
  }

  void _onSelected(bool selected, String data) {
    setState(() {
      if (selected) {
        _selectedData.add(data);
      } else {
        _selectedData.remove(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text(
          'Choose your interest',
          style: TextStyle(color: AppColors.colorPrimary, fontSize: 28),
        ),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Choose your interests here and get the best movie\nand shows recommendations. Don't worry you can always change it later.",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.colorWhiteHighEmp,
                height: 1.2,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 5,
                runSpacing: 3,
                children: _languages.map((language) {
                  // Use fetched languages instead of _data
                  return FilterChip(
                    showCheckmark: false,
                    backgroundColor: AppColors.colorSecondaryDarkest,
                    label: Text(
                      language['name'], // Display language name
                      style: TextStyle(color: AppColors.colorWhiteHighEmp),
                    ),
                    shape: const StadiumBorder(
                        side: BorderSide(color: AppColors.colorPrimary)),
                    selected: _selectedData.contains(language['name']),
                    selectedColor: AppColors.colorPrimary,
                    padding: const EdgeInsets.all(5),
                    onSelected: (selected) =>
                        _onSelected(selected, language['name']),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 200.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (_selectedData.isNotEmpty) {
                      List<String> selectedLanguageIds =
                          await getSelectedLanguageIds(_selectedData);
                      await setLanguages(
                          selectedLanguageIds); // Call setLanguages with IDs
                    }

                    Get.to(() => const MyBottomNavModel());
                  },
                  child: Container(
                    height: 45.h,
                    width: 148.w,
                    decoration: BoxDecoration(
                      color: AppColors.colorWhiteMidEmp,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        'SKIP',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorSecondaryDarkest,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    print("Selected interests (CONTINUE): $_selectedData");
                    if (_selectedData.isNotEmpty) {
                      // Check if any interests are selected
                      List<String> selectedLanguageIds =
                          await getSelectedLanguageIds(_selectedData);
                      await setLanguages(selectedLanguageIds);
                    }
                  },
                  child: Container(
                    height: 45.h,
                    width: 148.w,
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        'CONTINUE',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorWhiteHighEmp,
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
    );
  }
}
