import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../screens/homeScreen/latestShowsScreen.dart';
import '../screens/reels/VideoListScreen.dart';
import '../utils/appColors.dart';

class LatestShowsModel extends StatefulWidget {
  const LatestShowsModel({super.key});

  @override
  _LatestShowsModelState createState() => _LatestShowsModelState();
}

class _LatestShowsModelState extends State<LatestShowsModel> {
  Map<String, List<Map<String, dynamic>>> transformedLayouts = {};
  bool isLoading = true; // To track the loading state
  String layoutName = "Latest"; // Default title
  String apiKey = dotenv.env['API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    // Fetch data when the page loads
    fetchAndTransformLayouts();
  }

  Future<void> fetchAndTransformLayouts() async {
    try {
      final response =
          await http.get(Uri.parse('http://$apiKey:8000/getLayouts/'));
      if (response.statusCode == 200) {
        Map<String, dynamic> layoutsData = jsonDecode(response.body)['layouts'];

        // Temporary map to store all the layouts and their thumbnails
        Map<String, List<Map<String, dynamic>>> layouts = {};

        // Iterate through each layout and transform the data
        layoutsData.forEach((layoutKey, layoutItems) {
          List<dynamic> items = List.from(layoutItems);
          String layoutName = items.first['layoutName'] as String;

          // Extract thumbnails (name and fileLocation)
          List<Map<String, dynamic>> thumbnails = items.skip(1).map((item) {
            String fileLocation = item['fileLocation'] as String;
            String updatedPath = fileLocation.replaceFirst(
                'uploads/thumbnail/', 'http://$apiKey:8765/thumbnails/');
            return {
              'name': item['name'] as String,
              'fileLocation': updatedPath,
              'id': item['_id'] as String,
            };
          }).toList();
          print(thumbnails);
          // Add the layout name and its thumbnails to the map
          layouts[layoutName] = thumbnails;
        });

        // Update the state after processing all layouts
        setState(() {
          transformedLayouts = layouts;
          isLoading = false; // Stop loading
        });
      } else {
        throw Exception('Failed to load layouts');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false; // Stop loading in case of an error
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: transformedLayouts.keys.map((layoutName) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 14.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    layoutName.length > 25
                        ? layoutName.substring(0, 25) + '...'
                        : layoutName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.colorPrimary,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LatestShowsScreen()),
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
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: AppColors.colorSecondaryDarkest,
                    offset: const Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ]),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: transformedLayouts[layoutName]!
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key; // Get the index
                      var thumbnail = entry.value; // Get the thumbnail data

                      return InkWell(
                        onTap: () async {
                          String videoId = thumbnail[
                              'id']; // Access the thumbnail ID correctly

                          try {
                            final fetchedVideoUrls =
                                await fetchVideoUrls(videoId);

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
                              Get.to(VideoListScreen(
                                urls: fetchedVideoUrls,
                                movieName: thumbnail['name'] ?? 'Untitled',
                                moviePath:
                                    thumbnail['fileLocation'] ?? 'Untitled',
                              ));
                            }
                          } catch (e) {
                            print('Error fetching video URLs: $e');
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: index == 0 ? 0 : 5, right: 5),
                          // Adjust padding based on index
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 95.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    thumbnail['fileLocation']!,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons
                                          .error); // Show error icon if image loading fails
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.only(left: 1.0),
                                child: Text(thumbnail['name'] ?? '',
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
