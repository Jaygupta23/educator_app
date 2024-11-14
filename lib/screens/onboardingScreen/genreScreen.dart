import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../screens/interestScreen.dart';
import '../../screens/profileScreen/EditSelectedContent.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool? loggedInBefore;

  // Track selected genres
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

  List<int> _selectedGenres = [];

  Future<void> fetchGenreItems() async {
    final url = Uri.parse("http://$apiKey:8000/user/genreList/");
    try {
      final response = await http.get(url);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUserData = prefs.getString('userData');
      print("userdata: $storedUserData");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response data: ${data['genreList']}");
        final List genreSliders = data['genreList'];

        // Decode the stored user data from JSON if available
        List<String> selectedGenreIds = [];
        if (storedUserData != null) {
          Map<String, dynamic> userData = jsonDecode(storedUserData);
          loggedInBefore = userData['loggedInBefore'] ?? false;
          if (userData.containsKey('selectedGenre')) {
            selectedGenreIds = (userData['selectedGenre'] as List)
                .map((genre) => genre['_id'] as String)
                .toList();
          }
        }

        setState(() {
          imagePaths = genreSliders.map((slider) {
            String fileLocation = slider['icon']?.toString() ?? '';
            String genreName = slider['name']?.toString() ?? 'Unknown';
            String sliderId = slider['_id']?.toString() ?? '';
            String updatedPath = fileLocation.replaceFirst(
              'uploads/genreImage',
              'http://$apiKey:8765/genreIcon/',
            );
            return {
              'icon': updatedPath,
              'name': genreName,
              '_id': sliderId,
            };
          }).toList();

          // Update the _selectedGenres list based on selectedGenreIds
          _selectedGenres = imagePaths
              .asMap()
              .entries
              .where((entry) => selectedGenreIds.contains(entry.value['_id']))
              .map((entry) => entry.key)
              .toList();

          print("imagePaths: $imagePaths");
          print("_selectedGenres: $_selectedGenres");

          isLoading = false;
          _initializeAnimations();
        });
      } else {
        throw Exception(
            'Failed to load images, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching genre: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

// Filter function to show only non-selected genres
  List<Map<String, dynamic>> getNonSelectedGenres() {
    return imagePaths
        .asMap()
        .entries
        .where((entry) => !_selectedGenres.contains(entry.key))
        .map((entry) => entry.value)
        .toList();
  }

  Future<void> setGenres({required List<String> selectedIds}) async {
    print("selectedIds: $selectedIds");
    final url = Uri.parse("http://$apiKey:8000/user/genreSelector/");
    final loginId = widget.userId;
    final body = {
      'userId': loginId,
      'selectedGenre': selectedIds,
    };
    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Handle successful response
        var responseData = jsonDecode(response.body);
        print(responseData);

        // Store the selected genres in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Retrieve existing user data
        String? userDataString = prefs.getString('userData');
        Map<String, dynamic> userData = userDataString != null
            ? jsonDecode(userDataString)
            : <String, dynamic>{};

        // Filter and collect the selected genre objects from imagePaths
        List<Map<String, dynamic>> selectedGenreObjects = imagePaths
            .where((genre) => selectedIds.contains(genre['_id']))
            .toList();
        print("Selected Genre Objects: $selectedGenreObjects");

        // Update the userData with the selected genres
        userData['selectedGenre'] = selectedGenreObjects;

        // Save the updated userData back to SharedPreferences
        await prefs.setString('userData', jsonEncode(userData));

        // Verify the updated userData
        String? updatedUserDataString = prefs.getString('userData');
        print('Updated userData: $updatedUserDataString');

        if (loggedInBefore == true) {
          Get.to(() => EditSelectedContent(userData: userData));
        } else {
          Get.offAll(() => InterestScreen(userId: userData['_id']));
        }
      } else {
        // Handle error response
        print('Failed to set genres: ${response.statusCode}');
        await showNotification(
          'Try Again',
          'Something went wrong!',
        );
      }
    } catch (e) {
      print('Error setting genres: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  void _initializeAnimations() {
    List<dynamic> nonSelectedGenres = getNonSelectedGenres();

    if (loggedInBefore == true) {
      for (int i = 0; i < imagePaths.length; i++) {
        _controllers.add(AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 500),
        ));
        _animations.add(Tween(begin: 1.0, end: 2.0).animate(_controllers[i]!));

        // Check if the current genre is non-selected
        bool isNonSelected = nonSelectedGenres.any((genre) =>
            genre['_id'] ==
            imagePaths[i]['_id']); // Assuming imagePaths contain genre data

        _isBalloonVisible
            .add(isNonSelected); // true for non-selected, false for selected
        _balloonSizes.add(80.0);
        _isExploding.add(false);
        _shakeControllers.add(AnimationController(
          vsync: this,
          duration: Duration(milliseconds: Random().nextInt(700) + 300),
        ));
      }
    } else {
      for (int i = 0; i < imagePaths.length; i++) {
        _controllers.add(AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 500),
        ));
        _animations.add(Tween(begin: 1.0, end: 2.0).animate(_controllers[i]!));

        // Default initialization for when not logged in before
        _isBalloonVisible.add(true);
        _balloonSizes.add(80.0);
        _isExploding.add(false);
        _shakeControllers.add(AnimationController(
          vsync: this,
          duration: Duration(milliseconds: Random().nextInt(700) + 300),
        ));
      }
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
              height: MediaQuery.of(context).size.height * 0.24,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        Text(
                          'Selected Genres',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 40),
                        Text(
                          "* minimum 3 genres.",
                          style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Wrap(
                          spacing: 5.0,
                          runSpacing: 2.0,
                          children: _selectedGenres.map((index) {
                            final genreItem = imagePaths[index];
                            return Container(
                              width: 110,
                              child: Chip(
                                label: Text(
                                  genreItem['name']!,
                                  style: TextStyle(
                                    color: AppColors.colorWhiteHighEmp,
                                  ),
                                ),
                                avatar: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(genreItem['icon']!),
                                ),
                                deleteIcon: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: AppColors.colorWhiteHighEmp,
                                ),
                                onDeleted: () {
                                  setModalState(() {
                                    _selectedGenres.remove(index);
                                  });
                                  setState(() {
                                    _isBalloonVisible[index] = true;
                                    _controllers[index]?.reset();
                                    _isExploding[index] = false;
                                  });

                                  // If no selected genres, close the dialog
                                  if (_selectedGenres.isEmpty) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                backgroundColor:
                                    AppColors.colorSecondaryDarkest,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: AppColors.colorWhiteHighEmp,
                  ),
                  SizedBox(height: 6),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        print(_selectedGenres);
                        List<String> selectedGenreItem = _selectedGenres
                            .map((index) {
                              final genreItem = imagePaths[index];
                              return genreItem != null
                                  ? genreItem['_id'] as String
                                  : '';
                            })
                            .where((id) => id.isNotEmpty)
                            .toList();

                        try {
                          if (selectedGenreItem.length >= 3) {
                            print("Genres have been successfully set.");
                            await setGenres(selectedIds: selectedGenreItem);
                          }
                        } catch (error) {
                          print("Error setting genres: $error");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.colorPrimary,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                        minimumSize: Size(0, 30),
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
                  SizedBox(height: 5),
                ],
              ),
            );
          },
        );
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
                                                genreItem['icon']!,
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
                                              genreItem['name']!,
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
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print(_selectedGenres);
                        if (_selectedGenres.length >= 1) {
                          _showSelectedGenresDialog();
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            "${_selectedGenres.length} ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " Selected",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        backgroundColor: _selectedGenres.length >= 3
                            ? AppColors.colorSuccess
                            : AppColors.colorPrimary,
                        foregroundColor: AppColors.colorWhiteHighEmp,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    if (_selectedGenres.length >= 3)
                      Row(
                        children: [
                          SizedBox(width: 50),
                          ElevatedButton(
                            onPressed: () async {
                              print(_selectedGenres);
                              List<String> selectedGenreItem = _selectedGenres
                                  .map((index) {
                                    final genreItem = imagePaths[index];
                                    return genreItem != null
                                        ? genreItem['_id'] as String
                                        : '';
                                  })
                                  .where((id) => id.isNotEmpty)
                                  .toList();

                              try {
                                await setGenres(selectedIds: selectedGenreItem);
                                print("Genres have been successfully set.");
                              } catch (error) {
                                print("Error setting genres: $error");
                              }
                            },
                            child: Row(
                              children: [
                                Text("Update", style: TextStyle(fontSize: 20)),
                                SizedBox(width: 8),
                                Icon(Icons.double_arrow_outlined),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              backgroundColor: AppColors.colorWarning,
                              foregroundColor: AppColors.colorWhiteHighEmp,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
