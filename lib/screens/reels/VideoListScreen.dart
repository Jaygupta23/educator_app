import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelies/screens/reels/components/ListModals.dart';
import 'package:reelies/utils/appColors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoListScreen extends StatefulWidget {
  final List<String> urls; // List of video URLs
  final String movieName; // List of video URLs

  const VideoListScreen({Key? key, required this.urls, required this.movieName})
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
  late Future<void> _initializeVideoPlayerFuture;
  Duration _currentTime = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _playbackSpeed = 1.0; // Default playback speed
  List<double> _speedOptions = [0.5, 1.0, 1.25, 1.5];

  void initState() {
    super.initState();
    // Retrieve initialIndex from Get arguments if available
    final int? initialIndex = Get.arguments as int?;
    if (initialIndex != null) {
      _currentVideoIndex =
          initialIndex; // Set current video index from arguments
    }
    print(widget.urls);
    print("hello ${widget.movieName}");
    if (widget.urls.isNotEmpty) {
      _initializeVideo();
    } else {
      print("No video URLs provided.");
    }
  }

  void _initializeVideo() {
    print("Initializing video at index $_currentVideoIndex");
    _controller?.dispose();
    _controller =
        VideoPlayerController.network(widget.urls[_currentVideoIndex]);
    _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
      setState(() {
        _sliderMax = _controller!.value.duration.inSeconds.toDouble();
        _sliderValue = 0; // Reset the slider value to the start
        _totalDuration = _controller!.value.duration;
        _currentTime = _controller!.value.position;
        _controller!.play();
        _isPlaying = true;
      });

      // Listen for changes in video playback
      _controller!.addListener(() {
        if (_controller!.value.isInitialized) {
          setState(() {
            // Update slider and current time
            _sliderValue = _controller!.value.position.inSeconds
                .toDouble()
                .clamp(0, _sliderMax);
            _currentTime = _controller!.value.position;

            // Check if the video has ended
            if (_controller!.value.position >= _controller!.value.duration) {
              // Move to the next video if available
              if (_currentVideoIndex + 1 < widget.urls.length) {
                _currentVideoIndex++;
                // Dispose of the current controller and initialize the next video
                _controller!.dispose();
                _initializeVideo();
              } else {
                // Optionally handle end of playlist
                _controller!.pause();
                _isPlaying = false;
              }
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _hideControlIconTimer?.cancel();
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

  void _togglePlayPause() {
    if (_controller == null) return;
    if (_isPlaying) {
      _controller!.pause();
      setState(() {
        _isPlaying = false;
        _showControlIcon = true; // Keep control icon visible when paused
      });
      // Cancel timer when paused
      _hideControlIconTimer?.cancel();
    } else {
      _controller!.play();
      setState(() {
        _isPlaying = true;
        _showControlIcon = true; // Show control icon temporarily
      });
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
            onPressed: () => Get.back(), // Navigate back using GetX
          ),
          title: Text(
            widget.movieName,
            style: TextStyle(color: AppColors.colorWhiteHighEmp),
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(left: 8.0),
              margin: EdgeInsets.only(right: 10),
              height: 35,
              decoration: BoxDecoration(
                color: AppColors.colorError,
                // Replace with your desired background color
                borderRadius:
                    BorderRadius.circular(4.0), // Optional: rounded corners
              ),
              child: DropdownButton<double>(
                value: _playbackSpeed,
                dropdownColor: AppColors.colorError,
                borderRadius: BorderRadius.circular(8.0),

                items: _speedOptions.map((double speed) {
                  return DropdownMenuItem<double>(
                    value: speed,
                    child: Text(
                      '${speed}x',
                      style: TextStyle(
                          color: AppColors.colorWhiteHighEmp, fontSize: 18),
                    ),
                  );
                }).toList(),
                onChanged: (double? newValue) {
                  if (newValue != null) {
                    _changePlaybackSpeed(newValue);
                  }
                },
                underline: SizedBox(),
                iconSize: 30,
                // Removes default underline
                iconEnabledColor:
                    AppColors.colorWhiteHighEmp, // Dropdown icon color
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(
                  child: _controller!.value.isInitialized
                      ? VisibilityDetector(
                          key: const Key('video-player-key'),
                          onVisibilityChanged: (info) {
                            if (info.visibleFraction == 0.0) {
                              _controller?.pause();
                            } else {
                              _controller?.play();
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
                            padding: const EdgeInsets.only(left: 5, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SliderTheme(
                                            data: SliderThemeData(
                                              activeTrackColor:
                                                  AppColors.colorWhiteHighEmp,
                                              inactiveTrackColor: AppColors
                                                  .colorSecondaryDarkest,
                                              thumbColor:
                                                  AppColors.colorWhiteHighEmp,
                                              overlayColor:
                                                  Colors.red.withOpacity(0.2),
                                              thumbShape:
                                                  const RoundSliderThumbShape(
                                                      enabledThumbRadius: 6),
                                              trackHeight: 2.0,
                                              overlayShape: SliderComponentShape
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
                                            padding: const EdgeInsets.only(
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
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      "/",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      _formatDuration(
                                                          _totalDuration),
                                                      style: TextStyle(
                                                          color: Colors.white),
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
                      bottom: 100,
                      right: 0,
                      child: SizedBox(
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TweenAnimationBuilder(
                              tween:
                                  Tween(begin: 1.0, end: isLiked ? 1.1 : 1.0),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.elasticInOut,
                              builder: (context, double scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: IconButton(
                                    onPressed: _onIconPressed,
                                    icon: Icon(
                                      Icons.favorite_rounded,
                                      // shadows: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.5),
                                      //     spreadRadius: 2,
                                      //     blurRadius: 10,
                                      //     offset: const Offset(0, 3),
                                      //   ),
                                      // ],
                                      size: 40,
                                      color: isLiked
                                          ? Colors.red[400]
                                          : Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            TweenAnimationBuilder(
                              tween: Tween(
                                  begin: 1.0, end: isBookmark ? 1.1 : 1.0),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.elasticInOut,
                              builder: (context, double scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: IconButton(
                                    onPressed: _onStarPressed,
                                    icon: Icon(
                                      Icons.star_rounded,
                                      size: 40,
                                      // shadows: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.5),
                                      //     spreadRadius: 2,
                                      //     blurRadius: 10,
                                      //     offset: const Offset(0, 3),
                                      //   ),
                                      // ],
                                      color: isBookmark
                                          ? Colors.amber[300]
                                          : Colors.white,
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
                                Icons.layers,
                                size: 40,
                                // shadows: [
                                //   BoxShadow(
                                //     color: Colors.black.withOpacity(0.5),
                                //     spreadRadius: 2,
                                //     blurRadius: 10,
                                //     offset: const Offset(0, 3),
                                //   ),
                                // ],
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _shareVideo(widget
                                    .urls[_currentVideoIndex]); // Share video
                              },
                              icon: Icon(
                                Icons.share_rounded,
                                size: 40,
                                // shadows: [
                                //   BoxShadow(
                                //     color: Colors.black.withOpacity(0.5),
                                //     spreadRadius: 2,
                                //     blurRadius: 10,
                                //     offset: const Offset(0, 3),
                                //   ),
                                // ],
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
  }
}
