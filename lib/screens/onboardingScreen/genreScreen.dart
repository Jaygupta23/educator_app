import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:reelies/screens/interestScreen.dart';
import '../../main.dart';
import '../../utils/appColors.dart';

class GenreItem {
  final String title;
  final String imagePath;

  GenreItem({required this.title, required this.imagePath});
}

class GenreScreen extends StatefulWidget {
  final String userId;

  const GenreScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen>
    with TickerProviderStateMixin {
  List<Map<String, String>> imagePaths = [];
  bool isLoading = true;
  List<bool> _isBalloonVisible = [];
  List<double> _balloonSizes = [];
  List<bool> _isExploding = [];
  List<AnimationController?> _controllers = [];
  List<Animation<double>?> _animations = [];
  String apiKey = dotenv.env['API_KEY'] ?? '';
  List<int> _selectedGenres = []; // Track selected genres
  List<AnimationController?> _shakeControllers = []; // For shaking effect

  @override
  void initState() {
    super.initState();
    fetchGenreItems();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      // Use the same channel ID as defined in main.dart
      'High Importance Notifications',
      channelDescription: 'Channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

  Future<void> fetchGenreItems() async {
    final url = Uri.parse("http://$apiKey:8000/user/genreList/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response data: $data['genreList']");
        final List genreSliders =
            data['genreList']; // Adjusted to match your API response
        setState(() {
          imagePaths = genreSliders.map((slider) {
            String fileLocation = slider['icon'] as String;
            String genreName = slider['name'] as String;
            String sliderId = slider['_id'] as String;
            String updatedPath = fileLocation.replaceFirst(
              'uploads/genreImage',
              'http://$apiKey:8765/genreIcon/',
            );
            return {
              'path': updatedPath,
              'title': genreName,
              'id': sliderId,
            };
          }).toList();

          isLoading = false;
          _initializeAnimations(); // Set loading to false after fetching
        });
      } else {
        throw Exception(
            'Failed to load images, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching genre: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  Future<void> setGenres({required List<String> selectedIds}) async {
    final url = Uri.parse("http://$apiKey:8000/user/genreSelector/");
    final loginId = widget.userId;
    final body = {
      'userId': loginId,
      'selectedGenre': selectedIds,
    };
    print("loginId: $loginId");
    print(selectedIds);
    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        // Handle successful response
        var responseData = jsonDecode(response.body);
        print('Genres set successfully: ${responseData}');
        Get.offAll(() => InterestScreen(userId: loginId));
        // await showNotification(
        //   'Genre Added in Queue',
        //   'You have successfully Selected Genres',
        // );
      } else {
        // Handle error response
        print('Failed to set genres: ${response.statusCode}');
        await showNotification(
          'Try Again',
          'Something went wrong!',
        );
      }
    } catch (e) {
      print('Error fetching genre: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  void _initializeAnimations() {
    for (int i = 0; i < imagePaths.length; i++) {
      _controllers.add(AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ));
      _animations.add(Tween(begin: 1.0, end: 2.0).animate(_controllers[i]!));
      _isBalloonVisible.add(true);
      _balloonSizes.add(80.0);
      _isExploding.add(false);
      _shakeControllers.add(AnimationController(
        vsync: this,
        duration: Duration(milliseconds: Random().nextInt(700) + 300),
      ));
    }
  }

  void _popBalloon(int index) {
    if (!_selectedGenres.contains(index)) {
      setState(() {
        _selectedGenres.add(index); // Add index to selected genres
        _isExploding[index] = true; // Trigger the explosion and fade effect
      });
      _controllers[index]?.forward().then((_) {
        setState(() {
          _balloonSizes[index] = 0.0; // Shrink the balloon after explosion
          _isBalloonVisible[index] = false; // Remove balloon from visible list
        });
        if (_selectedGenres.length == 3 ||
            _selectedGenres.length == imagePaths.length) {
          _showSelectedGenresDialog(); // Show modal if at least 3 genres are selected
        }
      });
    }
  }

  void _showSelectedGenresDialog() {
    bool allGenresSelected = _selectedGenres.length == imagePaths.length;
    showModalBottomSheet(
      context: context,
      isDismissible: !allGenresSelected,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            padding: EdgeInsets.all(10.0),
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Center(
                  child: Text(
                    'Selected Genres',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 2.0,
                      children: _selectedGenres.map((index) {
                        final genreItem = imagePaths[index];
                        return Container(
                          width: 110,
                          child: Chip(
                            label: Text(genreItem['title']!,
                                style: TextStyle(
                                    color: AppColors.colorWhiteHighEmp)),
                            avatar: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(genreItem['path']!)),
                            deleteIcon: Icon(Icons.close,
                                size: 20, color: AppColors.colorWhiteHighEmp),
                            onDeleted: () {
                              setModalState(() {
                                _selectedGenres.remove(index);
                              });
                              setState(() {
                                _isBalloonVisible[index] =
                                    true; // Show balloon back on screen
                                _controllers[index]?.reset(); // Reset animation
                                _isExploding[index] = false; // Stop explosion
                              });
                              if (_selectedGenres.isEmpty) {
                                Navigator.of(context).pop();
                              }
                            },
                            backgroundColor: AppColors.colorSecondaryDarkest,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      print(_selectedGenres);
                      List<String> selectedGenreItem = _selectedGenres
                          .map((index) {
                            final genreItem = imagePaths[index];
                            // Check if genreItem is not null before accessing 'id'
                            return genreItem != null
                                ? genreItem['id'] as String
                                : '';
                          })
                          .where(
                              (id) => id.isNotEmpty) // Filter out empty strings
                          .toList();

                      try {
                        await setGenres(selectedIds: selectedGenreItem);
                        print("Genres have been successfully set.");
                        // Optionally navigate to another screen or show a success message here
                      } catch (error) {
                        print("Error setting genres: $error");
                        // Handle error (e.g., show a notification)
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.colorPrimary,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    for (var shakeController in _shakeControllers) {
      shakeController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: AppColors.colorSecondaryDarkest,
          centerTitle: true,
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              // Adjust the padding as needed
              child: Text(
                'Select Genres',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final balloonSize = constraints.maxWidth * 0.27;
                    final padding = constraints.maxWidth * 0.02;
                    final random = Random();

                    return Padding(
                      padding: EdgeInsets.all(padding),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: padding,
                          mainAxisSpacing: padding,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _isBalloonVisible
                            .where((visible) => visible)
                            .length,
                        itemBuilder: (context, visibleIndex) {
                          int actualIndex = -1;
                          int count = -1;

                          for (int i = 0; i < _isBalloonVisible.length; i++) {
                            if (_isBalloonVisible[i]) {
                              count++;
                            }
                            if (count == visibleIndex) {
                              actualIndex = i;
                              break;
                            }
                          }

                          if (actualIndex == -1 ||
                              !_isBalloonVisible[actualIndex]) {
                            return SizedBox.shrink();
                          }

                          final genreItem = imagePaths[actualIndex];

                          final int duration = random.nextInt(700) + 300;

                          // Use the shake controller for this specific index
                          final _shakeController =
                              _shakeControllers[actualIndex];

                          Animation<double> _shakeAnimation =
                              Tween(begin: 20.0, end: 0.0)
                                  .chain(CurveTween(curve: Curves.easeInOut))
                                  .animate(_shakeController!);

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Future.delayed(
                                Duration(milliseconds: random.nextInt(500)),
                                () {
                              if (mounted) {
                                _shakeController.repeat(reverse: true);
                              }
                            });
                          });

                          return GestureDetector(
                            onTap: () {
                              _popBalloon(actualIndex);
                            },
                            child: Column(
                              children: [
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 300),
                                  opacity:
                                      _isExploding[actualIndex] ? 0.0 : 1.0,
                                  child: AnimatedBuilder(
                                    animation: _shakeAnimation,
                                    builder: (context, child) {
                                      return Transform.translate(
                                        offset:
                                            Offset(0, _shakeAnimation.value),
                                        child: child,
                                      );
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      width: balloonSize * 1.1,
                                      height: balloonSize * 2.1,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                            top: -0.8,
                                            left: -1,
                                            right: -1,
                                            child: ClipOval(
                                              child: Image.network(
                                                genreItem['path']!,
                                                fit: BoxFit.cover,
                                                width: balloonSize * 1.1,
                                                height: balloonSize * 1.7,
                                              ),
                                            ),
                                          ),
                                          if (_isExploding[actualIndex])
                                            ScaleTransition(
                                              scale: _animations[actualIndex]!,
                                              child: ClipOval(
                                                child: Image.asset(
                                                  'assets/images/burst1.png',
                                                  fit: BoxFit.cover,
                                                  width: balloonSize * 1.1,
                                                  height: balloonSize * 1.7,
                                                ),
                                              ),
                                            ),
                                          Positioned(
                                            bottom: 20,
                                            child: Text(
                                              genreItem['title']!,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_selectedGenres.length >= 1)
            Positioned(
              bottom: 15,
              right: 6,
              child: GestureDetector(
                onTap: _showSelectedGenresDialog,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.colorError,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.chevron_up,
                    color: AppColors.colorWhiteHighEmp,
                    size: 28,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
