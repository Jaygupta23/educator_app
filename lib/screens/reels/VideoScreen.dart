import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'VideoPlayerWidget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  final List<String> videoUrls = [
    "https://drive.google.com/uc?export=download&id=1QsQc5JLknurEyu8oi_XfPJ4oRG_iu9SL",
    "https://drive.google.com/uc?export=download&id=168yaRUwX9W0mCPxk6LHRzQTs-Le4dCXT",
    "https://drive.google.com/uc?export=download&id=1AewdzLeebn-D3IsHHAj9Eqo0s6fjkhUY",
    "https://drive.google.com/uc?export=download&id=1voVeMTKZuyoIzHHH70wTT7uAujRmq-_N",
    "https://drive.google.com/uc?export=download&id=1OA0UGOVfVPeIl8_ycyFefC0uvLXC2UhU",
    "https://drive.google.com/uc?export=download&id=1suA9MraPrtoG5AGm6e5n4iEA2pYaKL83",
  ];

  @override
  void initState() {
    super.initState();
    // _fetchSessionId();
    // _fetchVideoUrls();
    print(apiKey);
    // _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Future<void> _fetchSessionId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   sessionCookie = prefs.getString('sessionid') ?? '';
  //   print('session cookie ========= $sessionCookie');
  // }

  // Future<void> _saveSessionId(String sessionId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? storedSessionId = prefs.getString('sessionid');
  //
  //   if (storedSessionId != sessionId) {
  //     await prefs.setString('sessionid', sessionId);
  //     setState(() {
  //       sessionCookie = sessionId;
  //     });
  //   }
  //   print("save $sessionCookie");
  // }

  // Future<void> _fetchVideoUrls({bool isLoadMore = false}) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     sessionCookie = prefs.getString('sessionid') ?? '';
  //     print('session cookie ========= $sessionCookie');
  //     final response = await http.get(
  //       Uri.parse("http://$apiKey:8000/videos/getVideos/"),
  //       headers: {
  //         'Cookie': 'sessionid=$sessionCookie',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> mapResponse = jsonDecode(response.body);
  //       setState(
  //         () {
  //           if (isLoadMore) {
  //             print(apiKey);
  //
  //             videoUrls.addAll(List<String>.from(mapResponse['data'].map(
  //                 (video) => "http://$apiKey:8000/media/" + video['path'])));
  //             isFetchingMore = false;
  //           } else {
  //             videoUrls = List<String>.from(mapResponse['data'].map(
  //                 (video) => "http://$apiKey:8000/media/" + video['path']));
  //             isLoading = false;
  //             print("mapResponse $mapResponse");
  //           }
  //           ;
  //
  //           print("mapResponse $mapResponse");
  //           if (mapResponse['data'].length == 0) {
  //             print("ewmopty");
  //             _saveSessionId('');
  //             _fetchVideoUrls();
  //           }
  //         },
  //       );
  //
  //       // Save new session ID if present in the response headers
  //       String? setCookie = response.headers['set-cookie'];
  //       if (setCookie != null) {
  //         RegExp regex = RegExp(r'sessionid=([^;]+);');
  //         Match? match = regex.firstMatch(setCookie);
  //         if (match != null) {
  //           String newSessionId = match.group(1)!;
  //           await _saveSessionId(newSessionId);
  //         }
  //       }
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       if (isLoadMore) isFetchingMore = false;
  //     });
  //   }
  // }

  // void _pageListener() {
  //   if (_pageController.position.atEdge) {
  //     if (_pageController.position.pixels != 0 && !isFetchingMore) {
  //       setState(() {
  //         isFetchingMore = true;
  //       });
  //       _fetchVideoUrls(isLoadMore: true);
  //     }
  //   }
  // }
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
                child: VideoPlayerWidget(url: videoUrls[index]),
              );
            },
            itemCount: videoUrls.length,
            scrollDirection: Axis.vertical,
          );
  }
}
