import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:reelies/models/myBottomNavModel.dart';
import 'package:reelies/utils/appColors.dart';

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
      List.generate(genreItems.length, (index) => 120.0);
  List<bool> _isExploding = List.generate(genreItems.length, (index) => false);
  List<AnimationController?> _controllers = [];
  List<Animation<double>?> _animations = [];
  List<int> _selectedGenres = []; // Track selected genres

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < genreItems.length; i++) {
      _controllers.add(AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ));
      _animations.add(Tween(begin: 1.0, end: 2.0).animate(_controllers[i]!));
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

      if (_selectedGenres.length >= 3) {
        _showSelectedGenresDialog(); // Show modal if at least 3 genres are selected
      }
    });
  }

  void _showSelectedGenresDialog() {
    bool allGenresSelected = _selectedGenres.length == genreItems.length;

    showModalBottomSheet(
      context: context,
      isDismissible:
          !allGenresSelected, // Prevent dismiss if all genres are selected
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return WillPopScope(
              onWillPop: () async =>
                  !allGenresSelected, // Prevent back button if all genres are selected
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: AppColors.colorSecondaryDarkest,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                height: MediaQuery.of(context).size.height / 3,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Center(
                          child: Text(
                            'Selected Genres',
                            style: TextStyle(
                                fontSize: constraints.maxWidth * 0.07,
                                fontWeight: FontWeight.bold,
                                color: AppColors.colorPrimary),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.1),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: constraints.maxWidth * 0.025,
                              runAlignment: WrapAlignment.spaceAround,
                              children: [
                                ..._selectedGenres.map((index) {
                                  final genreItem = genreItems[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: constraints.maxHeight * 0.02,
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: constraints.maxWidth * 0.31,
                                          height: constraints.maxHeight * 0.15,
                                          decoration: BoxDecoration(
                                              color:
                                                  AppColors.colorWhiteHighEmp,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColors
                                                        .colorSecondaryDarkest,
                                                    spreadRadius: 2,
                                                    blurRadius: 4)
                                              ]),
                                          child: Center(
                                            child: Text(
                                              genreItem.title,
                                              style: TextStyle(
                                                  fontSize:
                                                      constraints.maxWidth *
                                                          0.04,
                                                  color:
                                                      AppColors.colorPrimary),
                                            ),
                                          ),
                                        ),
                                        if (!allGenresSelected) // Only show close icon if not all genres selected
                                          Positioned(
                                            top: -constraints.maxHeight * 0.076,
                                            right:
                                                -constraints.maxWidth * 0.056,
                                            child: IconButton(
                                              icon: Icon(
                                                  CupertinoIcons
                                                      .minus_circle_fill,
                                                  size: constraints.maxWidth *
                                                      0.05,
                                                  color:
                                                      AppColors.colorPrimary),
                                              onPressed: () {
                                                setModalState(() {
                                                  _selectedGenres.remove(index);
                                                });
                                                setState(() {
                                                  _isBalloonVisible[index] =
                                                      true;
                                                  _balloonSizes[index] = 120.0;
                                                  _isExploding[index] = false;
                                                  _controllers[index]?.reset();
                                                });

                                                if (_selectedGenres.isEmpty) {
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.08),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyBottomNavModel()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 5,
                                shadowColor: AppColors.colorPrimary,
                                backgroundColor: AppColors.colorPrimary,
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6))),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.045,
                                color: AppColors.colorWhiteHighEmp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: AppColors.colorSecondaryDarkest,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Center(
            child: Text(
              'Select Genres',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorWhiteHighEmp),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final balloonSize = constraints.maxWidth * 0.35;
                final random = Random();

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _isBalloonVisible.where((visible) => visible).length,
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

                    if (actualIndex == -1 || !_isBalloonVisible[actualIndex]) {
                      return SizedBox.shrink();
                    }

                    final genreItem = genreItems[actualIndex];

                    // Generate a random duration and delay for each container
                    final int duration = random.nextInt(700) + 300; // 300ms to 1000ms

                    // Create an AnimationController with random duration
                    AnimationController _shakeController = AnimationController(
                      duration: Duration(milliseconds: duration),
                      vsync: this,
                    );

                    // Create a Tween for the vertical shaking effect (y-axis)
                    Animation<double> _shakeAnimation = Tween(begin: -15.0, end: 10.0)
                        .chain(CurveTween(curve: Curves.easeIn))
                        .animate(_shakeController);

                    // Start the animation with a random delay
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Future.delayed(Duration(milliseconds: random.nextInt(500)), () {
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
                            opacity: _isExploding[actualIndex] ? 0.0 : 1.0,
                            child: AnimatedBuilder(
                              animation: _shakeAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _shakeAnimation.value), // Vertical movement
                                  child: child,
                                );
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: balloonSize,
                                height: balloonSize * 1.25,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Image.asset(
                                    //   'assets/images/balloon.png',
                                    //   fit: BoxFit.cover,
                                    //   width: balloonSize,
                                    //   height: balloonSize * 1.25,
                                    // ),
                                    Positioned(
                                      top: -0.8,
                                      left: -1,
                                      right: -1,
                                      child: ClipOval(
                                        child: Image.asset(
                                          genreItem.imagePath,
                                          fit: BoxFit.cover,
                                          width: balloonSize,
                                          height: balloonSize * 1.25,
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
                                            width: balloonSize,
                                            height: balloonSize * 1.25,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            genreItem.title,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.colorWhiteHighEmp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
