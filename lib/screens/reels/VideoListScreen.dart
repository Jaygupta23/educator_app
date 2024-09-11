import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelies/screens/reels/components/ListModals.dart';
import 'package:reelies/utils/appColors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoListScreen extends StatefulWidget {
  final String url;

  const VideoListScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _showControlIcon = false;
  Timer? _hideControlIconTimer;
  double _sliderValue = 0.0;
  double _sliderMax = 1.0;
  bool isLiked = false;
  bool isBookmark = false;
  late Future<void> _initializeVideoPlayerFuture;

  Duration _currentTime = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
      // Update state with video duration and initialize the slider max value
      setState(() {
        _sliderMax = _controller!.value.duration.inSeconds.toDouble();
        _totalDuration = _controller!.value.duration;
        _currentTime = _controller!.value.position;
      });

      // Automatically start playing the video
      _controller!.play();
      _isPlaying = true;

      // Add listener to update current time and slider value
      _controller!.addListener(() {
        if (_controller!.value.isInitialized && _controller!.value.isPlaying) {
          setState(() {
            _sliderValue = _controller!.value.position.inSeconds.toDouble();
            _currentTime = _controller!.value.position;
          });
        }
        if (_controller!.value.isInitialized && !_controller!.value.isPlaying) {
          setState(() {
            _sliderValue = _controller!.value.position.inSeconds.toDouble();
            _currentTime = _controller!.value.position;
          });
        }

        // Restart video when it ends
        if (_controller!.value.isInitialized &&
            _controller!.value.position == _controller!.value.duration) {
          _controller!.seekTo(Duration.zero);
          _controller!.play();
        }
      });
    });

    // Uncomment and modify this to show modal bottom sheet when needed
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showModalBottomSheet(
    //     context: context,
    //     builder: (context) {
    //       return ListModals();
    //     },
    //   );
    // });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _hideControlIconTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;

    if (_isPlaying) {
      _controller!.pause();

      // If video is paused, don't hide the control icon
      setState(() {
        _isPlaying = false;
        _showControlIcon = true; // Keep the control icon visible
      });

      // Cancel any running timer when the video is paused
      _hideControlIconTimer?.cancel();
    } else {
      _controller!.play();

      // If video is playing, hide the control icon after 2 seconds
      setState(() {
        _isPlaying = true;
        _showControlIcon = true; // Show the control icon temporarily
      });

      // Cancel any previous timers to avoid multiple timers
      _hideControlIconTimer?.cancel();

      // Start a new timer to hide the control icon after 2 seconds
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
        _controller!.seekTo(Duration(seconds: value.toInt()));
      });
    }
  }

  void _onIconPressed() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _onStarPressed() {
    setState(() {
      isBookmark = !isBookmark;
    });
  }

  void _onDoubleTap() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListModals();
      },
    );
  }

  void _shareVideo(String episodeName) {
    final videoUrl = episodeName;
    Share.share('$videoUrl');
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _seekForward5Seconds() {
    if (_controller != null && _controller!.value.isInitialized) {
      if (!mounted) return;
      final currentPosition = _controller!.value.position;
      final newPosition = currentPosition + const Duration(seconds: 5);
      final maxDuration = _controller!.value.duration;
      final seekPosition =
          newPosition > maxDuration ? maxDuration : newPosition;
      _controller!.seekTo(seekPosition);
      setState(() {
        _sliderValue = seekPosition.inSeconds.toDouble();
      });
    }
  }

  void _seekReplay5Seconds() {
    if (_controller != null && _controller!.value.isInitialized) {
      if (!mounted) return;
      final currentPosition = _controller!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 5);
      final seekPosition =
          newPosition < Duration.zero ? Duration.zero : newPosition;
      _controller!.seekTo(seekPosition);
      setState(() {
        _sliderValue = seekPosition.inSeconds.toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56), // Default AppBar height is 56
        child: AppBar(
          backgroundColor: AppColors.colorSecondaryDarkest,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: AppColors.colorWhiteHighEmp,
            onPressed: () {
              Get.back(); // This will navigate back using GetX
            },
          ),
          title: Text(
            "Trollerz",
            style: TextStyle(color: AppColors.colorWhiteHighEmp),
          ), // You can add a title or leave it blank
          // Optional: Center the title if you need
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
                            onDoubleTap: _onDoubleTap,
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: MediaQuery.of(context).size.height / 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Replay Button
                            IconButton(
                              onPressed: _seekReplay5Seconds,
                              icon: Icon(
                                Icons.replay_5,
                                size: 50,
                                color: Colors.white70,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
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
                            // Add some spacing between the buttons

                            // Forward Button
                            IconButton(
                              onPressed: _seekForward5Seconds,
                              icon: Icon(
                                Icons.forward_5,
                                size: 50,
                                color: Colors.white70,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                                // GestureDetector(
                                //   onTap: _togglePlayPause,
                                //   child: Icon(
                                //     _isPlaying
                                //         ? Icons.pause_rounded
                                //         : Icons.play_arrow_rounded,
                                //     color: Colors.white,
                                //     size: 50,
                                //   ),
                                // ),
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
                                                      enabledThumbRadius: 4),
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
                                              onChanged: _onSliderChanged,
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
                                                // Row(
                                                //   mainAxisSize:
                                                //       MainAxisSize.min,
                                                //   children: [
                                                //     GestureDetector(
                                                //       onTap:
                                                //           _seekReplay5Seconds,
                                                //       child: Icon(
                                                //         Icons.replay_5,
                                                //         size: 30,
                                                //         color: Colors.white,
                                                //       ),
                                                //     ),
                                                //     GestureDetector(
                                                //       onTap:
                                                //           _seekForward5Seconds,
                                                //       child: Icon(
                                                //         Icons.forward_5,
                                                //         size: 30,
                                                //         color: Colors.white,
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
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
                              tween: Tween<double>(
                                  begin: 1.0, end: isLiked ? 1.1 : 1.0),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.elasticInOut,
                              builder: (context, double scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: IconButton(
                                    onPressed: _onIconPressed,
                                    icon: Icon(
                                      Icons.favorite_rounded,
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
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
                              tween: Tween<double>(
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
                                      shadows: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
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
                            IconButton(
                              onPressed: () {
                                _shareVideo(widget.url);
                              },
                              icon: Icon(
                                Icons.share_rounded,
                                size: 40,
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
  }
}
