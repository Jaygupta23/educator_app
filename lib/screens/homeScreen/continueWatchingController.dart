import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContinueWatchingController extends GetxController {
  // Observable list for continue-watching items
  var continueWatchingMovies = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshContinueWatching(); // Initial load
  }

  // Fetches data from SharedPreferences and updates the list
  Future<void> refreshContinueWatching() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedProgress = prefs.getStringList("videoProgress") ?? [];

    // Decode saved progress data
    continueWatchingMovies.value = savedProgress.map((item) {
      Map<String, dynamic> progress = jsonDecode(item);
      return {
        'name': progress['movieName'] ?? 'Unknown',
        'moviePath': progress['moviePath'] ?? '',
        'videoUrl': progress['videoId'] ?? '',
      };
    }).toList();
  }
}
