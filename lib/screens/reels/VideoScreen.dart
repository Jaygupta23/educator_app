import 'dart:convert';
import 'package:flutter/material.dart';
import 'VideoPlayerWidget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  // List<String> videoUrls = [];
  bool isLoading = false;
  bool isFetchingMore = false;
  var sessionCookie = '';
  final PageController _pageController = PageController();
  String apiKey = dotenv.env['API_KEY'] ?? '';
  List<Map<String, dynamic>> videoUrls = [];

  @override
  void initState() {
    super.initState();
    // _fetchSessionId();
    _fetchVideoUrls();
    print(apiKey);
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchVideoUrls({bool isLoadMore = false}) async {
    try {
      final response = await http.get(
        Uri.parse("http://$apiKey:8000/user/trendingTrailers"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List mapResponse = data['trailersData'] ?? [];

        setState(
          () {
            // Map to a list of objects containing id, name, and trailerUrl
            final newVideoData = mapResponse
                .map((trailer) => {
                      "id": trailer['_id'],
                      "name": trailer['name'],
                      "trailerUrl": trailer['trailerUrl'],
                      "shortsData": trailer['shorts']
                    })
                .toList();

            if (isLoadMore) {
              videoUrls.addAll(newVideoData);
              isFetchingMore = false;
            } else {
              videoUrls = newVideoData;
              isLoading = false;
            }
          },
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        if (isLoadMore) isFetchingMore = false;
      });
    }
  }

  void _pageListener() {
    if (_pageController.position.atEdge) {
      if (_pageController.position.pixels != 0 && !isFetchingMore) {
        setState(() {
          isFetchingMore = true;
        });
        _fetchVideoUrls(isLoadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ))
        : PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              print("Video URL: ${videoUrls[index]}");
              return AspectRatio(
                aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                child: VideoPlayerWidget(videoData: videoUrls[index]),
              );
            },
            itemCount: videoUrls.length,
            scrollDirection: Axis.vertical,
          );
  }
}
