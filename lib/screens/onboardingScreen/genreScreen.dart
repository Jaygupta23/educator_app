import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reelies/utils/appColors.dart';
import '../../models/myBottomNavModel.dart';

class GenreItem {
  final String title;
  final String imagePath;

  GenreItem({required this.title, required this.imagePath});
}

final List<GenreItem> genreItems = [
  GenreItem(title: 'Action', imagePath: 'assets/images/action.webp'),
  GenreItem(title: 'Romance', imagePath: 'assets/images/romance.png'),
  GenreItem(title: 'Horror', imagePath: 'assets/images/horror.jpg'),
  GenreItem(title: 'Family', imagePath: 'assets/images/family.png'),
  GenreItem(title: 'Adventure', imagePath: 'assets/images/adventure.jpg'),
  GenreItem(title: 'Thriller', imagePath: 'assets/images/thriller.png'),
  GenreItem(title: 'Comedy', imagePath: 'assets/images/comedy.jpg'),
  GenreItem(title: 'Drama', imagePath: 'assets/images/drama.jpg'),
];

class GenreScreen extends StatefulWidget {
  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen>
    with TickerProviderStateMixin {
  List<bool> _isBalloonVisible =
      List.generate(genreItems.length, (index) => true);
  List<double> _balloonSizes =
      List.generate(genreItems.length, (index) => 80.0);
  List<bool> _isExploding = List.generate(genreItems.length, (index) => false);
  List<AnimationController?> _controllers = [];
  List<Animation<double>?> _animations = [];
  List<int> _selectedGenres = []; // Track selected genres
  List<AnimationController?> _shakeControllers = []; // For shaking effect

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < genreItems.length; i++) {
      _controllers.add(AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ));
      _animations.add(Tween(begin: 1.0, end: 2.0).animate(_controllers[i]!));

      // Initialize shake controllers
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
      });
    }

    setState(() {
      _isExploding[index] = true; // Trigger the explosion and fade effect
    });

    _controllers[index]?.forward().then((_) {
      setState(() {
        _balloonSizes[index] = 0.0; // Shrink the balloon after the explosion
        _isBalloonVisible[index] =
            false; // Remove the balloon from the visible list
      });

      if (_selectedGenres.length == 3 ||
          _selectedGenres.length == genreItems.length) {
        _showSelectedGenresDialog(); // Show modal if at least 3 genres are selected
      }
    });
  }

  void _showSelectedGenresDialog() {
    bool allGenresSelected = _selectedGenres.length == genreItems.length;

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
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 5.0,
                        runSpacing: 2.0,
                        children: _selectedGenres.map((index) {
                          final genreItem = genreItems[index];
                          return Container(
                            width: 110,
                            child: Chip(
                              label: Text(
                                genreItem.title,
                                style: TextStyle(
                                    color: AppColors
                                        .colorWhiteHighEmp), // Ensure text is visible
                              ),
                              avatar: CircleAvatar(
                                backgroundImage:
                                    AssetImage(genreItem.imagePath),
                              ),
                              deleteIcon: Icon(Icons.close,
                                  size: 20, color: AppColors.colorWhiteHighEmp),
                              onDeleted: () {
                                setModalState(() {
                                  _selectedGenres.remove(index);
                                });
                                setState(() {
                                  _isBalloonVisible[index] =
                                      true; // Show bubble back on screen
                                  _controllers[index]
                                      ?.reset(); // Reset animation
                                  _isExploding[index] = false; // Stop explosion
                                });
                                if (_selectedGenres.isEmpty) {
                                  Navigator.of(context).pop();
                                }
                              },
                              backgroundColor: AppColors.colorSecondaryDarkest,
                              // Set the background color to transparent
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
                      onPressed: () {
                        Navigator.pop(context);
                        Get.offAll(() => const MyBottomNavModel());
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

                          final genreItem = genreItems[actualIndex];

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
                                              child: Image.asset(
                                                genreItem.imagePath,
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
                                              genreItem.title,
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
