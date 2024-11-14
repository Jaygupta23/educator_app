import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/latestShowsModel.dart';
import '../../models/mostTrendingShowsModel.dart';
import 'package:get/get.dart';
import '../../screens/homeScreen/ContinueWatching.dart';
import '../../screens/homeScreen/filterContent.dart';
import '../../screens/reels/VideoListScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../utils/appColors.dart';
import 'notificationScreen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> imagePaths = [];
  String apiKey = dotenv.env['API_KEY'] ?? '';
  bool isLoading = true;

  List<VideoPlayerController> _controllers = [];
  int _currentPageIndex = 0;
  bool _isHolding = false;
  bool _isEpisodeButtonVisible = false;
  Timer? _autoSlideTimer;

  // Set the initial index to a large number to simulate infinite looping
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _currentPageIndex = 0; // Initialize current page index
    _controllers = []; // Initialize controllers list
    _pageController = PageController(
        viewportFraction: 0.8,
        initialPage: _currentPageIndex); // Initialize PageController
    fetchHeroSlider(); // Fetch images on initialization
  }

  Future<void> fetchHeroSlider() async {
    try {
      final response =
          await http.get(Uri.parse("http://$apiKey:8000/getSliders"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List sliders = data['sliders'] ?? [];
        setState(() {
          imagePaths = sliders.map((slider) {
            String fileLocation = slider['fileLocation'] as String? ?? '';
            String heroSliderType = slider['type'] as String? ?? '';
            String heroSliderName = (slider['name'] ?? '').toString();
            String sliderId = (slider['_id'] ?? '').toString();
            String slideEpisode = (slider['parts'] ?? '0').toString();
            String sliderTrailer = slider['trailerUrl'] as String? ?? '';

            // Log for debugging
            print(
                "Slider parsed: $fileLocation, $heroSliderType, $slideEpisode, $heroSliderName, $sliderTrailer");

            String updatedPath = fileLocation.replaceFirst(
                'uploads/thumbnail/', 'http://$apiKey:8765/thumbnails/');
            return {
              'path': updatedPath,
              'type': heroSliderType,
              'name': heroSliderName,
              'id': sliderId,
              'trailerUrl': sliderTrailer,
              'episode': slideEpisode,
            };
          }).toList();

          // Initialize video controllers for trailers
          _controllers = List<VideoPlayerController>.filled(
              imagePaths.length, VideoPlayerController.network(''));

          for (int i = 0; i < imagePaths.length; i++) {
            String? trailerUrl = imagePaths[i]['trailerUrl'];
            if (imagePaths[i]['type'] == 'Trailer' &&
                trailerUrl != null &&
                trailerUrl.isNotEmpty) {
              try {
                VideoPlayerController controller =
                    VideoPlayerController.network(trailerUrl)
                      ..initialize().then((_) {
                        if (mounted) {
                          setState(
                              () {}); // Refresh the widget after initialization
                        }
                      });
                controller.addListener(() {
                  if (controller.value.position == controller.value.duration) {
                    controller.seekTo(Duration.zero);
                    controller.play(); // Loop the video
                  }
                });
                _controllers[i] =
                    controller; // Store the initialized controller
              } catch (e) {
                print('Error initializing video player: $e');
                _controllers[i] = VideoPlayerController.network(
                    ''); // Assign a default or placeholder controller
              }
            } else {
              _controllers[i] = VideoPlayerController.network(
                  ''); // Assign a default or placeholder controller
            }
          }

          isLoading = false; // Stop loading once data is fetched
        });

        _startAutoSlideTimer(); // Start the timer after loading images
      } else {
        throw Exception(
            'Failed to load images, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sliders: $e');
      if (mounted) {
        setState(() {
          isLoading = false; // Stop loading on error
        });
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose(); // Dispose of each video controller
    }
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // For SocketException

  Future<List<String>> fetchVideoUrls(String movieID, String trailerUrl) async {
    final url = Uri.parse('http://$apiKey:8000/getMovieData/');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'movieID': movieID}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Map shortsData to video URLs and replace the path
        final List<String> videoUrls = (jsonResponse['shortsData'] as List)
            .where((data) => data['fileLocation'] != null)
            .map((data) {
          String videoPath = data['fileLocation'] as String;
          String updatedPath = videoPath.replaceFirst(
              'uploads/shorts/', 'http://$apiKey:8765/video/');
          return updatedPath;
        }).toList();

        // Add the trailerUrl at the 0th index of videoUrls
        videoUrls.insert(0, trailerUrl);

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

  void _startAutoSlideTimer() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isHolding && imagePaths.isNotEmpty) {
        // Check if imagePaths is not empty
        setState(() {
          _currentPageIndex = (_currentPageIndex + 1) % imagePaths.length;
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // Changed to center alignment
            children: [
              Row(children: [
                Container(
                  width: 150,
                  height: 100,
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  child: Image.asset(
                    "assets/images/1.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ]),
              IconButton(
                onPressed: () {
                  Get.to(() => const NotificationScreen());
                },
                icon: Icon(
                  Icons.notifications,
                  size: 26.sp,
                  color: AppColors.colorWhiteHighEmp,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.colorSecondaryDarkest,
        ),
      ),
      body: SizedBox(
        height: screenHeight,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.53,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator()) // Show loader
                          : imagePaths.isNotEmpty
                              ? Stack(
                                  children: [
                                    Positioned.fill(
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: CachedNetworkImage(
                                          imageUrl: imagePaths.isNotEmpty
                                              ? imagePaths[_currentPageIndex %
                                                          imagePaths.length]
                                                      ['path'] ??
                                                  'https://via.placeholder.com/150'
                                              : 'https://via.placeholder.com/150',
                                          key: ValueKey(imagePaths.isNotEmpty
                                              ? imagePaths[_currentPageIndex %
                                                  imagePaths.length]['path']
                                              : 'fallback_image'),
                                          fit: BoxFit.cover,
                                          color: Colors.black.withOpacity(0.5),
                                          colorBlendMode: BlendMode.darken,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10.0, sigmaY: 10.0),
                                        child: Container(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: () async {
                                          // Ensure _currentPageIndex is valid and within bounds
                                          if (_currentPageIndex <
                                              imagePaths.length) {
                                            final sliderId =
                                                imagePaths[_currentPageIndex]
                                                    ['id'];
                                            final sliderTrailer =
                                                imagePaths[_currentPageIndex]
                                                    ['trailerUrl'];
                                            final sliderType =
                                                imagePaths[_currentPageIndex]
                                                    ['type'];
                                            final sliderName =
                                                imagePaths[_currentPageIndex]
                                                    ['name'];
                                            final sliderPath =
                                                imagePaths[_currentPageIndex]
                                                    ['path'];

                                            try {
                                              if (sliderType == 'Trailer') {
                                                final fetchedVideoUrls =
                                                    await fetchVideoUrls(
                                                        sliderId!,
                                                        sliderTrailer!);

                                                if (fetchedVideoUrls
                                                    .isNotEmpty) {
                                                  String movieName =
                                                      sliderName ?? '';
                                                  String moviePath =
                                                      sliderPath ?? '';
                                                  // Navigate to the next page after the animation completes
                                                  Get.to(() => VideoListScreen(
                                                      urls: fetchedVideoUrls,
                                                      movieName: movieName,
                                                      moviePath: moviePath));
                                                } else {
                                                  print(
                                                      'No videos found for this trailer.');
                                                }
                                              }
                                            } catch (e) {
                                              print(
                                                  'Error fetching video URLs: $e');
                                            }
                                          } else {
                                            print(
                                                "Current page index is out of bounds");
                                          }
                                        },
                                        onLongPress: () async {
                                          // Ensure _currentPageIndex is valid and within bounds of imagePaths
                                          setState(() {
                                            _isEpisodeButtonVisible =
                                                !_isEpisodeButtonVisible; // Toggle button visibility on long press
                                          });
                                          if (_currentPageIndex <
                                              imagePaths.length) {
                                            final sliderType =
                                                imagePaths[_currentPageIndex]
                                                    ['type'];
                                            final trailerUrl =
                                                imagePaths[_currentPageIndex]
                                                    ['trailerUrl'];

                                            // Proceed only if the current slider type is 'Trailer' and the trailer URL is valid
                                            if (sliderType == 'Trailer' &&
                                                trailerUrl != null &&
                                                trailerUrl.isNotEmpty) {
                                              print(
                                                  "Trailer URL found: $trailerUrl");

                                              // Ensure that the _currentPageIndex is within bounds of _controllers list
                                              if (_currentPageIndex <
                                                  _controllers.length) {
                                                final controller = _controllers[
                                                    _currentPageIndex];

                                                if (!controller
                                                    .value.isInitialized) {
                                                  // Initialize the controller asynchronously
                                                  print(
                                                      "Initializing video controller for URL: $trailerUrl");
                                                  _controllers[
                                                          _currentPageIndex] =
                                                      VideoPlayerController
                                                          .network(trailerUrl);

                                                  try {
                                                    await _controllers[
                                                            _currentPageIndex]
                                                        .initialize();
                                                    setState(() {
                                                      _isHolding = true;
                                                      _controllers[
                                                              _currentPageIndex]
                                                          .play(); // Play the trailer on long press
                                                    });
                                                    print(
                                                        "Video controller initialized and playing.");
                                                  } catch (error) {
                                                    print(
                                                        "Error initializing video controller: $error");
                                                  }
                                                } else {
                                                  // Play the video if already initialized
                                                  setState(() {
                                                    _isHolding = true;
                                                    controller
                                                        .play(); // Play the trailer on long press
                                                  });
                                                }
                                              } else {
                                                print(
                                                    "Invalid _currentPageIndex for _controllers: $_currentPageIndex");
                                              }
                                            } else {
                                              print(
                                                  "No valid trailer URL available for this slider.");
                                            }
                                          } else {
                                            print(
                                                "Invalid page index: $_currentPageIndex");
                                          }
                                        },
                                        onLongPressUp: () {
                                          setState(() {
                                            _isEpisodeButtonVisible =
                                                !_isEpisodeButtonVisible; // Toggle button visibility on long press
                                          });
                                          if (_currentPageIndex <
                                              _controllers.length) {
                                            final controller = _controllers[
                                                _currentPageIndex %
                                                    _controllers.length];
                                            if (controller
                                                .value.isInitialized) {
                                              setState(() {
                                                _isHolding = false;
                                                controller
                                                    .pause(); // Pause the trailer on long press release
                                                _startAutoSlideTimer(); // Restart auto-slide after release
                                              });
                                            } else {
                                              print(
                                                  "Controller not initialized for this trailer.");
                                            }
                                          }
                                        },
                                        child: PageView.builder(
                                          controller: _pageController,
                                          onPageChanged: (index) {
                                            setState(() {
                                              if (_controllers.isNotEmpty &&
                                                  _currentPageIndex >= 0) {
                                                _controllers[_currentPageIndex %
                                                        _controllers.length]
                                                    .pause();
                                              }

                                              if (imagePaths.isNotEmpty) {
                                                _currentPageIndex =
                                                    index % imagePaths.length;
                                              } else {
                                                _currentPageIndex =
                                                    0; // Set a default value if imagePaths is empty
                                              }

                                              if (_isHolding &&
                                                  _controllers.isNotEmpty &&
                                                  _currentPageIndex >= 0) {
                                                _controllers[_currentPageIndex]
                                                    .play();
                                              }
                                            });
                                          },
                                          itemBuilder: (context, index) {
                                            if (imagePaths.isNotEmpty) {
                                              final actualIndex =
                                                  index % imagePaths.length;
                                              final isCurrentPage =
                                                  actualIndex ==
                                                      _currentPageIndex;
                                              final sliderType =
                                                  imagePaths[actualIndex]
                                                      ['type'];

                                              return Transform.scale(
                                                scale: isCurrentPage ? 1 : 0.9,
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: isCurrentPage
                                                        ? [
                                                            BoxShadow(
                                                                blurRadius: 10,
                                                                color: Colors
                                                                    .black54,
                                                                spreadRadius: 5)
                                                          ]
                                                        : [],
                                                  ),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 3.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: _isHolding &&
                                                                isCurrentPage &&
                                                                sliderType ==
                                                                    'Trailer' &&
                                                                _currentPageIndex <
                                                                    _controllers
                                                                        .length &&
                                                                _controllers[
                                                                        _currentPageIndex]
                                                                    .value
                                                                    .isInitialized
                                                            ? AspectRatio(
                                                                aspectRatio:
                                                                    _controllers[
                                                                            _currentPageIndex]
                                                                        .value
                                                                        .aspectRatio,
                                                                child: VideoPlayer(
                                                                    _controllers[
                                                                        _currentPageIndex]),
                                                              )
                                                            : CachedNetworkImage(
                                                                imageUrl: imagePaths[
                                                                            actualIndex]
                                                                        [
                                                                        'path'] ??
                                                                    'https://via.placeholder.com/150',
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                              ),
                                                      )),
                                                ),
                                              );
                                            }

                                            return Container(); // Return empty container if no images are available
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  // Animation duration
                                  curve: Curves.easeInOut,
                                  // Animation curve
                                  color: AppColors.colorSecondaryDarkest,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorWhiteLowEmp,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 4),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.hourglass_empty,
                                          size: 60,
                                          color: AppColors.colorPrimary,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'We are working on it..',
                                          style: TextStyle(
                                            color: AppColors.colorPrimary,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // Add spacing between image and indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imagePaths.length,
                      (index) => isLoading
                          ? Center(
                              child: CircularProgressIndicator()) // Show loader
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              width: 15.0,
                              height: 4.0,
                              decoration: BoxDecoration(
                                color: _currentPageIndex % imagePaths.length ==
                                        index
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                    ),
                  ),
                  // Notification icon moved to an AppBar-style layout
                ],
              ),
              SizedBox(
                height: 25,
              ),
              const FilterContent(),
              // Title and "Show all" button for Latest Shows
              const ContinueWatching(),

              const MostTrendingShowsModel(),

              // Movie genres FilterChips

              const LatestShowsModel(),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
