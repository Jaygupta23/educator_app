import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/latestShowsModel.dart';
import 'package:reelies/models/mostTrendingShowsModel.dart';
import 'package:reelies/screens/homeScreen/latestShowsScreen.dart';
import 'package:reelies/screens/homeScreen/trendingVideosScreen.dart';
import 'package:get/get.dart';
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
    "assets/images/homeBig.png",
    "assets/images/slide1.png",
    "assets/images/slide2.png",
    "assets/images/slide6.png",
    "assets/images/slide8.png",
    "assets/images/slide9.png",
  ];

  final List<String> videoUrls = [
    "https://videos.pexels.com/video-files/26183148/11937275_1080_1920_30fps.mp4",
    "https://website-assets.vidyo.ai/SwiperVideo%20-Jacktorr.webm",
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
    _controllers = videoUrls.map((videoUrl) {
      return VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {}); // Refresh the widget after initialization
        });
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
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            // Changed to center alignment
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Reelies",
                    style: TextStyle(
                      color: AppColors.colorWhiteMidEmp,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
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
                              child: Image.asset(
                                imagePaths[
                                    _currentPageIndex % imagePaths.length],
                                key: ValueKey<String>(imagePaths[
                                    _currentPageIndex % imagePaths.length]),
                                fit: BoxFit.cover,
                                color: Colors.black.withOpacity(0.5),
                                colorBlendMode: BlendMode.darken,
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
                                    _currentPageIndex =
                                        index % imagePaths.length;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final actualIndex = index % imagePaths.length;
                                  final isCurrentPage =
                                      (index % imagePaths.length) ==
                                          _currentPageIndex;

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
                                                    spreadRadius: 5)
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
                                              : Image.asset(
                                                  imagePaths[actualIndex],
                                                  fit: BoxFit.cover,
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
