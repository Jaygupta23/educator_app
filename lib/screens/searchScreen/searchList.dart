import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:reelies/screens/searchScreen/searchErrorScreen.dart';
import '../../utils/appColors.dart';
import '../reels/VideoListScreen.dart';

class SearchListScreen extends StatefulWidget {
  const SearchListScreen({super.key});

  @override
  State<SearchListScreen> createState() => _SearchListScreenState();
}

class _SearchListScreenState extends State<SearchListScreen> {
  List<Map<String, dynamic>> listMap = []; // Use dynamic type for flexibility
  bool isLoading = false; // To track loading state
  String error = ''; // To hold any error messages
  String apiKey = dotenv.env['API_KEY'] ?? '';

  // Function to make API call
  Future<void> fetchSearchResults(String name) async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      // Making a GET request to the search API
      var response = await http.get(
        Uri.parse('http://192.168.1.48:8000/user/searchItem?name=$name'),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("data: $data");
        final List sliders = data['data'] ?? [];

        if (sliders.isEmpty) {
          setState(() {
            error = 'No results found';
            isLoading = false;
          });
          return;
        }

        setState(() {
          listMap = sliders.map((slider) {
            String fileLocation = slider['fileLocation'] ?? '';
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
          isLoading = false; // Stop loading after data is set
        });
      } else {
        setState(() {
          error = 'Failed to load data: ${data['msg']}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  Future<List<String>> fetchVideoUrls(String movieID) async {
    print("movie: $movieID");
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
                      fetchSearchResults(value); // Fetch results on search
                    },
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
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
          isLoading
              ? const Center(
                  child: CircularProgressIndicator()) // Show loading spinner
              : error.isNotEmpty
                  ? const SearchErrorScreen()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: listMap.length,
                        itemBuilder: (_, index) {
                          // Ensure that the map contains the keys 'path' and 'name'
                          var item = listMap[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Stack(
                                children: [
                                  Container(
                                    height: 130.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorGrey,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 92.h,
                                            width: 108.w,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              // Make sure you're using Image.network to load images from the 'path'
                                              child: Image.network(
                                                item['path'] ?? '',
                                                // Accessing the 'path' key from the map
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Icon(
                                                    Icons.broken_image,
                                                    size: 92.h,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['name'] ?? '',
                                                  // Accessing the 'name' key from the map
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .merge(
                                                        const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .colorWhiteHighEmp,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                ),
                                                SizedBox(height: 5.h),
                                                InkWell(
                                                  onTap: () async {
                                                    String? videoId = item[
                                                        'id']; // Access the thumbnail ID correctly
                                                    try {
                                                      final fetchedVideoUrls =
                                                          await fetchVideoUrls(
                                                              videoId!);

                                                      if (fetchedVideoUrls
                                                          .isEmpty) {
                                                        // Show a modal if no video URLs are found
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Column(
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/chicken1.png",
                                                                    height: 150,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                  Text(
                                                                    "No Episodes Found!",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            26),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(); // Close the dialog
                                                                  },
                                                                  child: Text(
                                                                    "OK",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      } else {
                                                        // // Navigate to the video screen with the list of URLs
                                                        // Get.to(VideoListScreen(
                                                        //   urls:
                                                        //       fetchedVideoUrls,
                                                        //   movieName:
                                                        //   item['name'] ??
                                                        //       'Untitled',
                                                        // ));
                                                      }
                                                    } catch (e) {
                                                      print(
                                                          'Error fetching video URLs: $e');
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 32,
                                                    width: 92,
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .colorPrimary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
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
                                                                    FontWeight
                                                                        .w400,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 85,
                                    left: 65,
                                    child: const Icon(
                                      Icons.play_circle_rounded,
                                      color: AppColors.colorWhiteHighEmp,
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
