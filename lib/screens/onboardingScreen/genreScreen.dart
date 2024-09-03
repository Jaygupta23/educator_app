import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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
      List.generate(genreItems.length, (index) => 80.0);
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

      if (_selectedGenres.length == 3) {
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
              onWillPop: () async => !allGenresSelected,
              // Prevent back button if all genres are selected
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
                              Get.offAll(const MyBottomNavModel());
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

                          AnimationController _shakeController =
                              AnimationController(
                            duration: Duration(milliseconds: duration),
                            vsync: this,
                          );

                          Animation<double> _shakeAnimation =
                              Tween(begin: 20.0, end: 0.0)
                                  .chain(CurveTween(curve: Curves.easeInOut))
                                  .animate(_shakeController);

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
              bottom: 30,
              right: 10,
              child: GestureDetector(
                onTap: _showSelectedGenresDialog,
                child: Container(
                  padding: EdgeInsets.all(10),
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
                    Icons.queue,
                    color: Colors.white,
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
