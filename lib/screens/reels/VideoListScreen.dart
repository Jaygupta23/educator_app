import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/myBottomNavModel.dart';
import '../../screens/reels/components/ListModals.dart';
import '../../utils/appColors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoListScreen extends StatefulWidget {
  final List<String> urls; // List of video URLs
  final String movieName;
  final String moviePath;

  const VideoListScreen(
      {Key? key,
      required this.urls,
      required this.movieName,
      required this.moviePath})
      : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _showControlIcon = false;
  int _currentVideoIndex = 0;
  Timer? _hideControlIconTimer;
  double _sliderValue = 0.0;
  double _sliderMax = 1.0;
  bool isLiked = false;
  bool isBookmark = false;
  Future<void>? _initializeVideoPlayerFuture;
  Duration _currentTime = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _playbackSpeed = 1.0; // Default playback speed
  List<double> _speedOptions = [0.5, 1.0, 1.25, 1.5, 2.0];
  late PageController _pageController;
  int? savedTimestamp;
  bool isCountdownVisible = false;
  int countdown = 10;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentVideoIndex);

    // Load video progress with continueWatch flag handling
    _loadVideoProgress().then((timestamp) async {
      final prefs = await SharedPreferences.getInstance();
      String? continueWatching = prefs.getString("continueWatch");

      if (continueWatching == "true") {
        setState(() {
          savedTimestamp = timestamp ?? 0;
        });
        // Clear the flag after using it to prevent it from interfering with other tabs
        await prefs.remove("continueWatch");
      } else {
        setState(() {
          savedTimestamp = 0;
        });
      }

      _initializeVideo();
    });

    _pageController.addListener(() {
      int nextPage = _pageController.page!.round();
      if (nextPage != _currentVideoIndex && nextPage < widget.urls.length) {
        setState(() {
          _currentVideoIndex = nextPage;
        });
        _initializeVideo();
      }
    });
  }

  void _initializeVideo() {
    if (_currentVideoIndex < 0 || _currentVideoIndex >= widget.urls.length) {
      return;
    }

    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.pause();
      _controller!.dispose();
    }

    _controller =
        VideoPlayerController.network(widget.urls[_currentVideoIndex]);

    _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
      if (mounted) {
        setState(() {
          _sliderMax = _controller!.value.duration.inSeconds.toDouble();
          _sliderValue = 0;
          _totalDuration = _controller!.value.duration;
          _currentTime = _controller!.value.position;
        });

        if (savedTimestamp != null && savedTimestamp! > 0) {
          _controller!.seekTo(Duration(seconds: savedTimestamp!));
        }

        _controller!.play();
        _isPlaying = true;
      }
    }).catchError((error) {
      if (mounted) {
        _showErrorDialog('Playback Error',
            'This video cannot be played due to an unsupported codec or a playback issue.');
      }
    });

    _initializeVideoPlayerFuture?.then((_) {
      _controller!.addListener(() {
        if (_controller!.value.isInitialized && mounted) {
          setState(() {
            _sliderValue = _controller!.value.position.inSeconds.toDouble();
            _currentTime = _controller!.value.position;

            if (_controller!.value.duration.inSeconds -
                    _controller!.value.position.inSeconds <=
                10) {
              _startCountdown();
            } else {
              _stopCountdownTimer();
            }
            if (_controller!.value.position >= _controller!.value.duration) {
              // If the video finishes playing, remove the progress
              _handleVideoEnd();
            } else {
              // Save progress while playing
              _saveVideoProgress();
            }
          });
        }
      });
    });
  }

  void _togglePlayPause() {
    if (_controller == null) return;

    if (_isPlaying) {
      _controller!.pause();
      setState(() {
        _isPlaying = false;
        _showControlIcon = true;
      });
      // Stop the countdown timer
      countdownTimer?.cancel();
    } else {
      _controller!.play();
      setState(() {
        _isPlaying = true;
        _showControlIcon = true;
      });

      // Resume or start the countdown if within the last 10 seconds
      if (_controller!.value.duration.inSeconds -
              _controller!.value.position.inSeconds <=
          10) {
        _startCountdown();
      }
      final remainingTime = _controller!.value.duration.inSeconds -
          _controller!.value.position.inSeconds;
      if (remainingTime <= 10) {
        _resumeCountdown(remainingTime);
      }

      // Start a timer to hide control icon after a delay
      _hideControlIconTimer?.cancel();
      _hideControlIconTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showControlIcon = false;
          });
        }
      });
    }
  }

  void _startCountdown() {
    // Make the countdown visible
    if (_isPlaying && !isCountdownVisible) {
      setState(() {
        isCountdownVisible = true;
      });

      countdownTimer?.cancel();
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final remainingTime = _controller!.value.duration.inSeconds -
            _controller!.value.position.inSeconds;

        if (remainingTime <= 0 || !_isPlaying) {
          timer.cancel();
        } else if (remainingTime <= 10) {
          setState(() {
            countdown =
                remainingTime; // Set countdown to seconds left within the last 10 seconds
          });
        } else {
          // If more than 10 seconds are left, stop showing countdown
          _stopCountdownTimer();
        }
      });
    }
  }

  void _resumeCountdown(int remainingTime) {
    if (_isPlaying && isCountdownVisible) {
      countdownTimer?.cancel();
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingTime <= 0 || !_isPlaying) {
          timer.cancel();
        } else {
          setState(() {
            countdown = remainingTime;
            remainingTime -= 1; // Decrease remaining time each second
          });
        }
      });
    }
  }

  void _stopCountdownTimer() {
    if (isCountdownVisible) {
      setState(() {
        isCountdownVisible = false;
        countdown = 10; // Reset countdown to 10 for the next video
      });
      countdownTimer?.cancel();
    }
  }

  void _handleVideoEnd() {
    if (_currentVideoIndex + 1 < widget.urls.length) {
      setState(() {
        _currentVideoIndex++;
      });
      _initializeVideo();
    } else {
      _controller!.pause();
      _isPlaying = false;
      _removeVideoProgress().then((_) {
        // Return to the previous screen with a result to refresh the list
        if (mounted) {
          Get.back(result: true);
        }
      });
    }
  }

  Future<void> _removeVideoProgress() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedProgress = prefs.getStringList("videoProgress") ?? [];

    int existingIndex = savedProgress.indexWhere((item) {
      Map<String, dynamic> progress = jsonDecode(item);
      return progress['movieName'] == widget.movieName;
    });

    if (existingIndex != -1) {
      savedProgress.removeAt(existingIndex);
      await prefs.setStringList("videoProgress", savedProgress);
    }

    print("Updated savedProgress after removal: $savedProgress");
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveVideoProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedProgress = prefs.getStringList("videoProgress") ?? [];

    if (_currentVideoIndex >= 0 && _currentVideoIndex < widget.urls.length) {
      String currentVideoId = widget.urls[_currentVideoIndex];

      int existingIndex = savedProgress.indexWhere((item) {
        Map<String, dynamic> progress = jsonDecode(item);
        return progress['movieName'] == widget.movieName;
      });

      Map<String, dynamic> currentProgress = {
        "movieName": widget.movieName,
        "moviePath": widget.moviePath,
        "videoId": currentVideoId,
        "timestamp": _controller!.value.position.inSeconds,
      };

      if (existingIndex != -1) {
        savedProgress[existingIndex] = jsonEncode(currentProgress);
      } else {
        savedProgress.add(jsonEncode(currentProgress));
      }

      await prefs.setStringList("videoProgress", savedProgress);
    }
  }

  Future<int?> _loadVideoProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? continueWatching = prefs.getString("continueWatch");
    print("continueWatching: $continueWatching");

    List<String> savedProgress = prefs.getStringList("videoProgress") ?? [];

    int existingIndex = savedProgress.indexWhere((item) {
      Map<String, dynamic> progress = jsonDecode(item);
      return progress['movieName'] == widget.movieName;
    });

    if (existingIndex != -1) {
      Map<String, dynamic> lastProgress =
          jsonDecode(savedProgress[existingIndex]);
      int savedTimestamp = lastProgress["timestamp"];

      if (continueWatching == "true") {
        return savedTimestamp;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pageController.dispose();
    _hideControlIconTimer?.cancel();
    countdownTimer?.cancel();
    super.dispose();
  }

  void _changePlaybackSpeed(double speed) {
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        _playbackSpeed = speed;
        _controller!
            .setPlaybackSpeed(_playbackSpeed); // Set the new playback speed
      });
    }
  }

  void _onSliderChanged(double value) {
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        _sliderValue = value;
        // Seek to the new position
        _controller!.seekTo(Duration(seconds: value.toInt()));
      });
    }
  }

  void _onIconPressed() {
    setState(() {
      isLiked = !isLiked; // Toggle like status
    });
  }

  void _onStarPressed() {
    setState(() {
      isBookmark = !isBookmark; // Toggle bookmark status
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _seekForward5Seconds() {
    if (_controller != null && _controller!.value.isInitialized) {
      final currentPosition = _controller!.value.position;
      final newPosition = currentPosition + const Duration(seconds: 5);
      final maxDuration = _controller!.value.duration;
      final seekPosition =
          newPosition > maxDuration ? maxDuration : newPosition;
      setState(() {
        // Seek to new position and update slider value
        _sliderValue = seekPosition.inSeconds.toDouble();
        _controller!.seekTo(seekPosition);
      });
    }
  }

  void _seekReplay5Seconds() {
    if (_controller != null && _controller!.value.isInitialized) {
      final currentPosition = _controller!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 5);
      final seekPosition =
          newPosition < Duration.zero ? Duration.zero : newPosition;
      setState(() {
        // Seek to new position and update slider value
        _sliderValue = seekPosition.inSeconds.toDouble();
        _controller!.seekTo(seekPosition);
      });
    }
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListModals(
          urls: widget.urls,
          initialSelectedIndex: _currentVideoIndex,
        );
      },
    ).then((selectedIndex) {
      if (selectedIndex != null) {
        setState(() {
          _currentVideoIndex = selectedIndex;
          _initializeVideo(); // Initialize the selected video
        });
        _pageController.jumpToPage(selectedIndex);
      }
    });
  }

  void _shareVideo(String episodeUrl) {
    Share.share(episodeUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: AppColors.colorSecondaryDarkest,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColors.colorWhiteHighEmp,
            onPressed: () => Get.offAll(
                () => MyBottomNavModel()), // Navigate back using GetX
          ),
          title: Text(
            widget.movieName,
            style: TextStyle(color: AppColors.colorWhiteHighEmp),
          ),
          actions: [
            PopupMenuButton<double>(
              icon: Icon(
                Icons.settings_rounded,
                color: AppColors.colorWhiteHighEmp,
                size: 30,
              ),
              color: Color(0xFF2C2C2C),
              // Set the dropdown background color
              offset: Offset(0, 40),
              // Adjust vertical offset if needed
              itemBuilder: (BuildContext context) {
                return _speedOptions.map((double speed) {
                  return PopupMenuItem<double>(
                    value: speed,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '${speed}x',
                            style: TextStyle(
                              color: AppColors.colorWhiteHighEmp,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_playbackSpeed ==
                              speed) // Show underline only if selected
                            Positioned(
                              bottom: 0,
                              // Adjust this to control the space between text and underline
                              child: Container(
                                width: 25, // Width of the underline
                                height: 2, // Thickness of the underline

                                decoration: BoxDecoration(
                                    color: AppColors.colorError,
                                    borderRadius: BorderRadius.circular(
                                        10)), // Color of the underline
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList();
              },
              onSelected: (selectedSpeed) {
                _changePlaybackSpeed(selectedSpeed);
              },
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.urls.length,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          setState(() {
            _currentVideoIndex = index;
            _initializeVideo(); // Initialize without parameters
          });
        },
        itemBuilder: (context, index) {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      Center(
                        child: _controller!.value.isInitialized
                            ? VisibilityDetector(
                                key: const Key('video-player-key'),
                                onVisibilityChanged: (info) {
                                  if (info.visibleFraction == 0.0) {
                                    if (_currentVideoIndex == index) {
                                      _controller?.pause();
                                    }
                                  } else {
                                    if (_currentVideoIndex == index &&
                                        !_isPlaying) {
                                      _controller?.play();
                                    }
                                  }
                                },
                                child: GestureDetector(
                                  onDoubleTap: () => setState(() {
                                    isLiked = !isLiked;
                                  }),
                                  onTap: _togglePlayPause,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: VideoPlayer(_controller!),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                      if (isCountdownVisible)
                        Positioned(
                          bottom: 80,
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.linear,
                                width:
                                    (MediaQuery.of(context).size.width / 10) *
                                        countdown,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white,
                                    ],
                                    stops: [0.2, 1.0],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "${countdown}s",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_showControlIcon)
                        Stack(alignment: Alignment.center, children: [
                          Positioned(
                              top: MediaQuery.of(context).size.height / 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: _seekReplay5Seconds,
                                    icon: const Icon(Icons.replay_5,
                                        size: 50, color: Colors.white70),
                                  ),
                                  GestureDetector(
                                    onTap: _togglePlayPause,
                                    child: Icon(
                                      _isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      size: 80.0,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _seekForward5Seconds,
                                    icon: const Icon(Icons.forward_5,
                                        size: 50, color: Colors.white70),
                                  )
                                ],
                              )),
                        ]),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: _controller!.value.isInitialized
                            ? Container(
                                color: Colors.black,
                                height: 80,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SliderTheme(
                                                  data: SliderThemeData(
                                                    activeTrackColor: AppColors
                                                        .colorWhiteHighEmp,
                                                    inactiveTrackColor: AppColors
                                                        .colorSecondaryDarkest,
                                                    thumbColor: AppColors
                                                        .colorWhiteHighEmp,
                                                    overlayColor: Colors.red
                                                        .withOpacity(0.2),
                                                    thumbShape:
                                                        const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                6),
                                                    trackHeight: 2.0,
                                                    overlayShape:
                                                        SliderComponentShape
                                                            .noOverlay,
                                                    trackShape:
                                                        const RoundedRectSliderTrackShape(),
                                                  ),
                                                  child: Slider(
                                                    value: _sliderValue,
                                                    min: 0.0,
                                                    max: _sliderMax,
                                                    onChanged: (double value) {
                                                      _onSliderChanged(value);
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0, left: 7),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            _formatDuration(
                                                                _currentTime),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                            "/",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                            _formatDuration(
                                                                _totalDuration),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                      if (_showControlIcon)
                        Positioned(
                            bottom: 130,
                            right: 0,
                            child: SizedBox(
                              height: 250,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TweenAnimationBuilder(
                                    tween: Tween(
                                        begin: 1.0, end: isLiked ? 1.1 : 1.0),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.elasticInOut,
                                    builder: (context, double scale, child) {
                                      return Transform.scale(
                                        scale: scale,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: _onIconPressed,
                                              icon: Icon(
                                                isLiked
                                                    ? Icons.favorite_rounded
                                                    : Icons
                                                        .favorite_outline_rounded,
                                                shadows: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                                size: 38,
                                                color: isLiked
                                                    ? AppColors.colorError
                                                    : AppColors
                                                        .colorWhiteHighEmp,
                                              ),
                                            ),
                                            Transform.translate(
                                              offset: const Offset(0, -10),
                                              child: Text(
                                                "1M",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors
                                                      .colorWhiteHighEmp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  TweenAnimationBuilder(
                                    tween: Tween(
                                        begin: 1.0,
                                        end: isBookmark ? 1.1 : 1.0),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.elasticInOut,
                                    builder: (context, double scale, child) {
                                      return Transform.scale(
                                        scale: scale,
                                        child: IconButton(
                                          onPressed: _onStarPressed,
                                          icon: Icon(
                                            isBookmark
                                                ? Icons.bookmark_rounded
                                                : Icons.bookmark_add_outlined,
                                            size: 38,
                                            shadows: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                            color: isBookmark
                                                ? AppColors.colorAlert
                                                : AppColors.colorWhiteHighEmp,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showModal(context);
                                    },
                                    icon: Icon(
                                      Icons.layers_outlined,
                                      size: 38,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      color: AppColors.colorWhiteHighEmp,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _shareVideo(widget.urls[
                                          _currentVideoIndex]); // Share video
                                    },
                                    icon: Icon(
                                      Icons.share_outlined,
                                      size: 38,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
