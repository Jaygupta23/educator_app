import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reelies/screens/reels/VideoListScreen.dart';
import '../screens/homeScreen/trendingVideosScreen.dart';
import '../utils/appColors.dart';
import '../utils/constants.dart';

class MostTrendingShowsModel extends StatefulWidget {
  const MostTrendingShowsModel({super.key});

  @override
  State<MostTrendingShowsModel> createState() => _MostTrendingShowsModelState();
}

class _MostTrendingShowsModelState extends State<MostTrendingShowsModel> {
  String apiKey = dotenv.env['API_KEY'] ?? '';
  List<Map<String, String>> trendingMovies = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTrendingShows();
  }

  Future<void> fetchTrendingShows() async {
    try {
      final url = Uri.parse("http://$apiKey:8000/user/trendingMovies");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List sliders = data['movies'] ?? [];
        setState(() {
          trendingMovies = sliders.map((slider) {
            String fileLocation = slider['fileLocation'] as String? ?? '';
            String sliderName = (slider['name'] ?? '').toString();
            String sliderId = (slider['_id'] ?? '').toString();

            String updatedPath = fileLocation.replaceFirst(
                'uploads/thumbnail/', 'http://$apiKey:8765/thumbnails/');

            return {
              'path': updatedPath,
              'id': sliderId,
              'name': sliderName,
            };
          }).toList();
        });
      }
    } catch (e) {
      print("error: $e");
    }
  }

  Future<List<String>> fetchVideoUrls(String movieID) async {
    final url = Uri.parse('http://$apiKey:8000/getMovieData/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'movieID': movieID}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Initialize videoUrls list and map shortsData if 'fileLocation' exists
        final List<String> videoUrls = (jsonResponse['shortsData'] as List)
            .where((data) => data['fileLocation'] != null)
            .map((data) {
          String videoPath = data['fileLocation'] as String;
          return videoPath.replaceFirst(
              'uploads/shorts/', 'http://$apiKey:8765/video/');
        }).toList();

        // Safely insert the trailerUrl if it exists
        if (jsonResponse['shortsData'].isNotEmpty &&
            jsonResponse['shortsData'][0]['trailerUrl'] != null) {
          videoUrls.insert(0, jsonResponse['shortsData'][0]['trailerUrl']);
        }

        return videoUrls;
      } else {
        print('Server error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load video URLs');
      }
    } on SocketException {
      print('Network error: Could not connect to the server');
      throw Exception('Network error');
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load video URLs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 14, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  trendingNow,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.colorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TrendingVideosScreen()),
                    );
                  },
                  child: Text(
                    'Show all',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.colorWhiteHighEmp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 125.h, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: trendingMovies.length,
              itemBuilder: (context, index) {
                final item = trendingMovies[index];
                return InkWell(
                  onTap: () async {
                    String? videoId =
                        item['id']; // Access the thumbnail ID correctly
                    try {
                      final fetchedVideoUrls = await fetchVideoUrls(videoId!);

                      if (fetchedVideoUrls.isEmpty) {
                        // Show a modal if no video URLs are found
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/chicken1.png",
                                    height: 150,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "No Episodes Found!",
                                    style: TextStyle(fontSize: 26),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Navigate to the video screen with the list of URLs
                        Get.to(() => VideoListScreen(
                              urls: fetchedVideoUrls,
                              movieName: item['name'] ?? 'Untitled',
                            ));
                      }
                    } catch (e) {
                      print('Error fetching video URLs: $e');
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 16 : 10.w,
                      right: index == trendingMovies.length - 1 ? 16 : 0,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Use Image.network instead of Image.asset
                            Container(
                              height: 105.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10), // Optional: for the container itself
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                // Set the border radius here
                                child: Image.network(
                                  item['path']!, // This should be the URL
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 105.h,
                                      width: 100.w,
                                      color: Colors.grey, // Placeholder color
                                      child: Center(
                                          child: Text('Image not found')),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
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
                        Positioned(
                          bottom: 20.h,
                          right: 0.w,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(10)),
                            child: Container(
                              height: 32.h,
                              width: 30.w,
                              color: Colors.blueGrey.withOpacity(0.7),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                          ),
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
