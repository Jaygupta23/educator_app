import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/latestShowsModel.dart';
import 'package:reelies/models/mostTrendingShowsModel.dart';
import 'package:reelies/screens/homeScreen/latestShowsScreen.dart';
import 'package:reelies/screens/homeScreen/trendingVideosScreen.dart';
import 'package:get/get.dart';
import 'package:reelies/screens/reels/VideoListScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../../utils/appColors.dart';
import '../../utils/constants.dart';
import 'notificationScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _data = [
    "All", // list of movie genres
    "Movies",
    "Drama",
    "Thriller",
    "Romance",
    "Comedy",
    "Horror",
  ];
  final List<String> imagePaths = [
    "https://drive.google.com/uc?export=view&id=1czrK2IHT8jb0IoDddzqFnta9DUf3OcsU",
    "https://drive.google.com/uc?export=view&id=1r5RhogLJhzlibJ7m0og5QnSQzoTTgm0-",
    "https://drive.google.com/uc?export=view&id=1InwHi17wiV2kpgbgalq3DQkHihywIETi",
    "https://drive.google.com/uc?export=view&id=1Xyp-U_SYRfpoLfBeyksOZttQXEb5WvGW",
    "https://drive.google.com/uc?export=view&id=14SCebPpJbQ6qF_xF6S95dxTksgXCi5Pw",
    "https://drive.google.com/uc?export=view&id=1Iwtrue8j3BiGN2ZauXo2WGWA1vGoDuuV",
    "https://drive.google.com/uc?export=view&id=12wDYHOjAFNHcjAy8_J0C62uZQcsFc-Jf",
  ];

  final List<String> trailerUrls = [
    "https://videos.pexels.com/video-files/26183148/11937275_1080_1920_30fps.mp4",
    "https://website-assets.vidyo.ai/SwiperVideo%20-Jacktorr.webm",
    "https://drive.google.com/uc?export=download&id=1U6n0HO-1cH-IZ0bGk5YcMht2faMAowDn",
    "https://videos.pexels.com/video-files/17301128/17301128-sd_360_640_30fps.mp4",
    "https://videos.pexels.com/video-files/26524813/11956374_360_640_25fps.mp4",
    "https://videos.pexels.com/video-files/20684425/20684425-sd_360_640_30fps.mp4",
    "https://videos.pexels.com/video-files/20417426/20417426-sd_360_640_30fps.mp4"
  ];

  List<VideoPlayerController> _controllers = [];
  int _currentPageIndex = 0;
  bool _isHolding = false;
  Timer? _autoSlideTimer;

  // Set the initial index to a large number to simulate infinite looping
  static const int initialPageIndex = 0;
  late final PageController _pageController;

  List<String> _selectedData =
      []; // initially empty list for selected movie genres

  final List<String> videoUrls = [
    "https://drive.google.com/uc?export=download&id=1QsQc5JLknurEyu8oi_XfPJ4oRG_iu9SL",
    "https://drive.google.com/uc?export=download&id=168yaRUwX9W0mCPxk6LHRzQTs-Le4dCXT",
    "https://drive.google.com/uc?export=download&id=1AewdzLeebn-D3IsHHAj9Eqo0s6fjkhUY",
    "https://drive.google.com/uc?export=download&id=1voVeMTKZuyoIzHHH70wTT7uAujRmq-_N",
    "https://drive.google.com/uc?export=download&id=1OA0UGOVfVPeIl8_ycyFefC0uvLXC2UhU",
    "https://drive.google.com/uc?export=download&id=1suA9MraPrtoG5AGm6e5n4iEA2pYaKL83",
  ];

// function to handle selection of movie genres
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
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentPageIndex = 0;
    _controllers = trailerUrls.map((videoUrl) {
      VideoPlayerController controller = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {}); // Refresh the widget after initialization
        });

      // Add a listener to replay the video after it finishes
      controller.addListener(() {
        if (controller.value.position == controller.value.duration) {
          controller.seekTo(Duration.zero); // Reset video to the start
          controller.play(); // Replay the video
        }
      });

      return controller;
    }).toList();

    // Initialize the PageController at a high index

    _pageController =
        PageController(viewportFraction: 0.85, initialPage: initialPageIndex);

    // Start the auto-slide timer
    _startAutoSlideTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _autoSlideTimer?.cancel(); // Cancel the timer on dispose
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlideTimer() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isHolding) {
        setState(() {
          _currentPageIndex = (_currentPageIndex + 1) %
              imagePaths.length; // Loop index using modulo
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
                  Get.to(const NotificationScreen());
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.56,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Stack(
                        children: [
                          // Background with dynamic blur effect
                          Positioned.fill(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: CachedNetworkImage(
                                imageUrl: imagePaths[
                                    _currentPageIndex % imagePaths.length],
                                key: ValueKey<String>(imagePaths[
                                    _currentPageIndex % imagePaths.length]),
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
                              filter:
                                  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                          // Carousel slider with GestureDetector for hold functionality
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  _isHolding = true;
                                  _controllers[_currentPageIndex %
                                          _controllers.length]
                                      .play();
                                });
                              },
                              onTap: () {
                                // Get the current video URL based on the current page index
                                final currentVideoUrl = videoUrls[
                                    _currentPageIndex % videoUrls.length];

                                // Navigate to VideoListScreen with the current video URL
                                Get.to(VideoListScreen(url: currentVideoUrl));
                              },
                              onLongPressUp: () {
                                setState(() {
                                  _isHolding = false;
                                  _controllers[_currentPageIndex %
                                          _controllers.length]
                                      .pause();
                                  _startAutoSlideTimer(); // Restart auto-slide after release
                                });
                              },
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    // Pause the previous video when page changes
                                    _controllers[_currentPageIndex %
                                            _controllers.length]
                                        .pause();
                                    _currentPageIndex =
                                        index % imagePaths.length;

                                    // Play the new current page video if holding
                                    if (_isHolding) {
                                      _controllers[_currentPageIndex].play();
                                    }
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final actualIndex = index % imagePaths.length;
                                  final isCurrentPage =
                                      actualIndex == _currentPageIndex;

                                  return Transform.scale(
                                    scale: isCurrentPage ? 1 : 0.9,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: isCurrentPage
                                            ? [
                                                BoxShadow(
                                                  blurRadius: 10,
                                                  color: AppColors
                                                      .colorSecondaryDarkest,
                                                  spreadRadius: 5,
                                                )
                                              ]
                                            : [],
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: _isHolding && isCurrentPage
                                              ? (_controllers[_currentPageIndex]
                                                      .value
                                                      .isInitialized
                                                  ? AspectRatio(
                                                      aspectRatio: _controllers[
                                                              _currentPageIndex]
                                                          .value
                                                          .aspectRatio,
                                                      child: VideoPlayer(
                                                          _controllers[
                                                              _currentPageIndex]),
                                                    )
                                                  : Container(
                                                      color: Colors.black))
                                              : CachedNetworkImage(
                                                  imageUrl:
                                                      imagePaths[actualIndex],
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Add spacing between image and indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imagePaths.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: 15.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: _currentPageIndex % imagePaths.length == index
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  // Notification icon moved to an AppBar-style layout
                ],
              ),
              // Title and "Show all" button for Latest Shows
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 14, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Latest Shows',
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
              ),
              // Movie genres FilterChips
              SingleChildScrollView(
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
                            style: const TextStyle(
                                color: AppColors.colorWhiteHighEmp),
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
              ),
              const LatestShowsModel(),
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
                              builder: (context) =>
                                  const TrendingVideosScreen()),
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
              const MostTrendingShowsModel(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
