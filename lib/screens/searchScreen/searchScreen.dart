import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../screens/searchScreen/searchErrorScreen.dart';
import '../../screens/searchScreen/sortFilterChips/categoryChips.dart';
import '../../screens/searchScreen/sortFilterChips/genreChips.dart';
import '../../screens/searchScreen/sortFilterChips/regionChips.dart';
import '../../screens/searchScreen/sortFilterChips/sortChips.dart';
import '../../screens/searchScreen/sortFilterChips/timeChips.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';
import '../../utils/appColors.dart';
import '../reels/VideoListScreen.dart';
import 'filterResultScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String apiKey = dotenv.env['API_KEY'] ?? '';
  List<Map<String, String>> gridMap = [];
  List<Map<String, String>> searchResults = []; // For search results
  bool isLoading = false;
  String errorMessage = '';

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
          gridMap = sliders.map((slider) {
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
      print("trending now: $gridMap");
    } catch (e) {
      print("error: $e");
    }
  }

  // Fetch search results API
  Future<void> fetchSearchResults(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = ''; // Clear previous error messages
    });

    try {
      final url = Uri.parse("http://$apiKey:8000/user/searchItem?name=$query");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List sliders = data['data'] ?? [];

        if (sliders.isEmpty) {
          setState(() {
            errorMessage = 'No results found for "$query"';
            searchResults = []; // Clear any previous search results
            isLoading = false;
          });
        } else {
          setState(() {
            searchResults = sliders.map((slider) {
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
            isLoading = false;
          });
        }
        print("searchResults: $searchResults");
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
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
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.h,
                    width: 260.w,
                    child: TextField(
                      onSubmitted: (value) {
                        fetchSearchResults(value);
                      },
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
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                        backgroundColor: AppColors.colorGrey,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0),
                          ),
                        ),
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SizedBox(
                                height: 50.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                          height: 4,
                                          width: 32,
                                          child: Image.asset(
                                              'assets/images/top.png')),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Text(
                                        'Sort & Filter',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.colorWhiteHighEmp,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                          width: 312,
                                          child: Image.asset(
                                              'assets/images/Separator.png')),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Category',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16,
                                      ),
                                    ),
                                    CategoryChips(),
                                    //SizedBox(height: 10),
                                    Text(
                                      'Regions',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16,
                                      ),
                                    ),
                                    RegionChips(),
                                    //SizedBox(height: 10),
                                    Text(
                                      'Genre',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16,
                                      ),
                                    ),
                                    GenreChips(),
                                    //SizedBox(height: 10),
                                    Text(
                                      'Time/Periods',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TimeChips(),
                                    //SizedBox(height: 10),
                                    Text(
                                      'Sort',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.colorWhiteHighEmp,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SortChips(),
                                    SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 148,
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.colorWhiteHighEmp,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'RESET',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors
                                                      .colorSecondaryDarkest,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FilterResultScreen()));
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 148,
                                            decoration: BoxDecoration(
                                              color: AppColors.colorPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'APPLY',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors
                                                      .colorWhiteHighEmp,
                                                  fontSize: 16,
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
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 52.h,
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
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: errorMessage.isNotEmpty
                    ? const SearchErrorScreen()
                    : searchResults.isNotEmpty
                        ? ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (_, index) {
                              // Ensure that the map contains the keys 'path' and 'name'
                              var item = searchResults[index];
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                                    fit: BoxFit.fill,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Icon(
                                                        Icons.broken_image,
                                                        size: 92.h,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20.w),
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
                                                                  FontWeight
                                                                      .w600,
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
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Column(
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        "assets/images/chicken1.png",
                                                                        height:
                                                                            150,
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
                                                                        Navigator.of(context)
                                                                            .pop(); // Close the dialog
                                                                      },
                                                                      child:
                                                                          Text(
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
                                                            // Navigate to the video screen with the list of URLs
                                                            Get.to(
                                                                VideoListScreen(
                                                              urls:
                                                                  fetchedVideoUrls,
                                                              movieName: item[
                                                                      'name'] ??
                                                                  'Untitled',
                                                              moviePath: item[
                                                                      'path'] ??
                                                                  'Untitled',
                                                            ));
                                                          }
                                                        } catch (e) {
                                                          print(
                                                              'Error fetching video URLs: $e');
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 32,
                                                        width: 92,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .colorPrimary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Watch Now',
                                                            style:
                                                                Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleSmall!
                                                                    .merge(
                                                                      const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: AppColors
                                                                            .colorWhiteHighEmp,
                                                                        fontSize:
                                                                            12,
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
                          )
                        : GridView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                              mainAxisExtent: 210,
                            ),
                            itemCount: gridMap.length,
                            itemBuilder: (_, index) {
                              final item = gridMap[
                                  index]; // Use search results if present

                              return GestureDetector(
                                onTap: () async {
                                  String? videoId = item[
                                      'id']; // Access the thumbnail ID correctly
                                  try {
                                    if (videoId != null) {
                                      final fetchedVideoUrls =
                                          await fetchVideoUrls(videoId!);

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
                                                    style:
                                                        TextStyle(fontSize: 26),
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
                                                    style:
                                                        TextStyle(fontSize: 20),
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
                                          movieName: item['name'] ?? 'Untitled',
                                          moviePath: item['path'] ?? 'Untitled',
                                        ));
                                      }
                                    }
                                  } catch (e) {
                                    print('Error fetching video URLs: $e');
                                  }
                                },
                                child: Stack(children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        16.0,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            item['path']!,
                                            // Use network image here
                                            height: 170,
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(
                                                Icons.broken_image,
                                                size: 170,
                                              ); // Display an error icon if the image fails to load
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['name']!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .merge(
                                                      const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .colorWhiteHighEmp,
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
                                      bottom: 40,
                                      right: 0,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: AppColors.colorPrimary,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Center(
                                          child: Text(
                                            '8.5',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.colorWhiteHighEmp,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ))
                                ]),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
