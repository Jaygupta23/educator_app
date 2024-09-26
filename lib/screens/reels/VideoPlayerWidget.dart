import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _isPlaying = true;
  bool _showControlIcon = false;
  Timer? _hideControlIconTimer;
  Duration? _lastPosition;
  double _sliderValue = 0.0;
  double _sliderMax = 1.0;
  Timer? _sliderUpdateTimer;
  bool isLiked = false;
  bool isBookmark = false;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      // Start with network streaming for immediate playback
      _controller = VideoPlayerController.network(widget.url);
      await _controller!.initialize();

      if (!mounted) return;
      setState(() {
        _sliderMax = _controller!.value.duration.inSeconds.toDouble();
        if (_lastPosition != null) {
          _controller!.seekTo(_lastPosition!);
        }
        _controller!.play();
        _startSliderUpdateTimer();
      });

      // Start caching in the background
      _startCaching();
    } catch (error) {
      print("Error initializing video player: $error");
    }

    _controller!.addListener(() {
      if (_controller!.value.isInitialized && _controller!.value.isPlaying) {
        if (!mounted) return;
        setState(() {
          _isPlaying = _controller!.value.isPlaying;
          _sliderValue = _controller!.value.position.inSeconds.toDouble();

          if (!_isPlaying) {
            _lastPosition = _controller!.value.position;
          }

          if (_sliderValue >= _sliderMax) {
            _controller!.seekTo(Duration.zero);
            _controller!.play();
          }
        });
      }
      if (_controller!.value.hasError) {
        print("Video player error: ${_controller!.value.errorDescription}");
      }
    });
  }

  void _startCaching() async {
    try {
      // Start caching the file in the background
      await DefaultCacheManager().getSingleFile(widget.url);
      print("Video cached successfully: ${widget.url}");
    } catch (e) {
      print("Error caching video: $e");
    }
  }

  void _startSliderUpdateTimer() {
    _sliderUpdateTimer?.cancel();
    _sliderUpdateTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_controller != null && _controller!.value.isInitialized) {
        if (!mounted) return;
        setState(() {
          _sliderValue = _controller!.value.position.inSeconds.toDouble();
          _sliderMax = _controller!.value.duration.inSeconds.toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _sliderUpdateTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;

    if (_isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }

    setState(() {
      _isPlaying = !_isPlaying;
      _showControlIcon = true;
    });

    _hideControlIconTimer?.cancel();
    _hideControlIconTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showControlIcon = false;
        });
      }
    });
  }

  void _startHideControlIconTimer() {
    _hideControlIconTimer?.cancel();
    _hideControlIconTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _showControlIcon = false;
      });
    });
  }

  void _onSliderChanged(double value) {
    if (_controller != null && _controller!.value.isInitialized) {
      if (!mounted) return;
      setState(() {
        _sliderValue = value;
        _controller!.seekTo(Duration(seconds: value.toInt()));
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller != null && _controller!.value.isInitialized) {
      if (state == AppLifecycleState.inactive ||
          state == AppLifecycleState.paused) {
        _lastPosition = _controller!.value.position;
        _controller!.pause();
      } else if (state == AppLifecycleState.resumed) {
        _controller!.seekTo(_lastPosition ?? Duration.zero);
        _controller!.play();
      }
    }
  }

  void _onIconPressed() {
    if (!mounted) return;
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _onStarPressed() {
    if (!mounted) return;
    setState(() {
      isBookmark = !isBookmark;
    });
  }

  void _onDoubleTap() {
    if (!mounted) return;
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _shareVideo(String episodeName) {
    final videoUrl = episodeName; // Replace with your actual video URL
    Share.share('$videoUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              // Video is not visible
                              _controller?.pause();
                            } else {
                              // Video is visible
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
                                      width: double.infinity, // Full width
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
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.3,
                    right: MediaQuery.of(context).size.width / 2.3,
                    child: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 70.0,
                      color: Colors.white70,
                    ),
                  ),
                Positioned(
                  left: -42,
                  right: -42,
                  bottom: -22,
                  child: _controller!.value.isInitialized
                      ? SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: Colors.red,
                            inactiveTrackColor: Colors.white,
                            thumbColor: Colors.red,
                            overlayColor: Colors.red.withOpacity(0.2),
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 0),
                            trackHeight: 2.0,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Slider(
                              value: _sliderValue,
                              min: 0.0,
                              max: _sliderMax,
                              onChanged: _onSliderChanged,
                            ),
                          ),
                        )
                      : Container(),
                ),
                Positioned(
                    bottom: 50,
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
                              // Get.to(() => VideoListScreen(urls: widget.url));
                            },
                            icon: Icon(
                              Icons.layers,
                              size: 40,
                              color: Colors.white,
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
                          IconButton(
                            onPressed: () {
                              _shareVideo(widget.url);
                            },
                            icon: Icon(
                              Icons.share,
                              size: 40,
                              color: Colors.white,
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
                    )),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
