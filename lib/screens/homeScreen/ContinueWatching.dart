import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/appColors.dart';
import 'package:reelies/screens/reels/VideoListScreen.dart';

class ContinueWatching extends StatefulWidget {
  const ContinueWatching({super.key});

  @override
  State<ContinueWatching> createState() => _ContinueWatchingState();
}

class _ContinueWatchingState extends State<ContinueWatching> {
  String apiKey = dotenv.env['API_KEY'] ?? '';
  List<Map<String, String>> continueWatchingMovies = [];

  @override
  void initState() {
    super.initState();
    fetchContinueWatchingMovies();
  }

  Future<void> fetchContinueWatchingMovies() async {
    // Fetch from local storage
    final prefs = await SharedPreferences.getInstance();
    List<String> savedProgress = prefs.getStringList("videoProgress") ?? [];
    print("savedProgress1 : $savedProgress");

    setState(() {
      continueWatchingMovies = savedProgress.isEmpty
          ? [] // Empty list when no progress
          : savedProgress.map((item) {
              Map<String, dynamic> progress = jsonDecode(item);
              String moviePath = progress['moviePath'] ?? 'Unknown';
              String movieName = progress['movieName'] ??
                  'Unknown'; // Ensure movie name is present
              String videoUrl =
                  progress['videoId'] ?? ''; // Ensure videoId is present

              print(
                  'Movie: $movieName, Video URL: $videoUrl, moviePath : $moviePath'); // Debugging line

              return {
                'name': movieName,
                'moviePath': moviePath,
                'videoUrl': videoUrl,
              };
            }).toList();
    });

    if (continueWatchingMovies.isEmpty) {
      print('No movies found in continue watching list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return continueWatchingMovies.isEmpty
        ? SizedBox() // Return an empty SizedBox to hide the section if no movies found
        : Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 14, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Continue Watching",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.colorPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 125.h, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: continueWatchingMovies.length,
                    itemBuilder: (context, index) {
                      final item = continueWatchingMovies[index];
                      return InkWell(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString("continueWatch", "true");

                          // Listen for result from VideoListScreen
                          final result = await Get.to(() => VideoListScreen(
                                urls: [item['videoUrl']!],
                                movieName: item['name'] ?? 'Untitled',
                                moviePath: item['moviePath'] ?? '',
                              ));

                          // Refresh the continue watching list if VideoListScreen removed the progress
                          if (result == true) {
                            fetchContinueWatchingMovies();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 16 : 10.w,
                            right: index == continueWatchingMovies.length - 1
                                ? 16
                                : 0,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Thumbnail container
                                  Container(
                                    height: 105.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: item['moviePath']!.isNotEmpty
                                          ? Image.network(
                                              item['moviePath']!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                color: Colors.grey,
                                                // Fallback placeholder color
                                                child: Center(
                                                  child: Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              color: Colors
                                                  .blueAccent, // Placeholder color when no path
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  // Movie name text
                                  Text(
                                    item['name']!,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.colorWhiteHighEmp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
