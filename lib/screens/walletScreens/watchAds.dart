import 'package:flutter/material.dart';
import 'package:reelies/utils/appColors.dart';

class WatchAds extends StatefulWidget {
  const WatchAds({super.key});

  @override
  _WatchAdsState createState() => _WatchAdsState();
}

class _WatchAdsState extends State<WatchAds> {
  // Variable to keep track of the active button index
  int _activeCheckInIndex = 0;

  @override
  Widget build(BuildContext context) {
    int? activeBuyMintsIndex = -1;
    // final List<Map<String, dynamic>> rewards = [
    //   {
    //     "icon": Icons.live_tv_rounded,
    //     "reward": "+10",
    //     "buttonText": "Watch Ad"
    //   },
    //   {
    //     "icon": Icons.live_tv_rounded,
    //     "reward": "+10",
    //     "buttonText": "Watch Ad"
    //   },
    //   {
    //     "icon": Icons.live_tv_rounded,
    //     "reward": "+10",
    //     "buttonText": "Watch Ad"
    //   },
    //   {
    //     "icon": Icons.live_tv_rounded,
    //     "reward": "+15",
    //     "buttonText": "Watch Ad"
    //   },
    //   {
    //     "icon": Icons.live_tv_rounded,
    //     "reward": "+15",
    //     "buttonText": "Watch Ad"
    //   },
    //   {
    //     "icon": Icons.live_tv_rounded,
    //     "reward": "+15",
    //     "buttonText": "Watch Ad"
    //   },
    //   {
    //     "icon": Icons.live_tv_rounded,
    //     "reward": "+20",
    //     "buttonText": "Watch Ad"
    //   },
    //   // Add more items here
    // ];

    final List<Map<String, dynamic>> dailyCheckIn = [
      {"day": "1", "point": "+10"},
      {"day": "2", "point": "+15"},
      {"day": "3", "point": "+20"},
      {"day": "4", "point": "+25"},
      {"day": "5", "point": "+30"},
      {"day": "6", "point": "+35"},
      {"day": "7", "point": "+40"},
    ];

    final List<Map<String, dynamic>> buyMins = [
      {"mints": "+1 mints", "price": "INR 10"},
      {"mints": "+2 mints", "price": "INR 20"},
      {"mints": "+3 mints", "price": "INR 30"},
      {"mints": "+4 mints", "price": "INR 50"},
      {"mints": "+5 mints", "price": "INR 50"},
    ];

    return Scaffold(
        backgroundColor: AppColors.colorSecondaryDarkest,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: AppColors.colorSecondaryDarkest,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/gift-box.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.38,
                        ),
                        Container(
                          color:
                              AppColors.colorSecondaryDarkest.withOpacity(0.2),
                        ),
                        Positioned(
                          top: 25,
                          left: MediaQuery.of(context).size.width * 0.3,
                          child: Center(
                            child: Text(
                              "Earn Rewards",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container that overlaps the image and extends outside
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.3,
                    left: MediaQuery.of(context).size.width * 0.5 - 150,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: 300,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[600],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: const Offset(5.0, 5.0),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text("My Mints ",
                                        style: TextStyle(
                                            color: AppColors.colorWhiteHighEmp,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    " 60",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    "assets/images/coin.webp",
                                    width: 40,
                                    height: 40,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.all(16),
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorSecondaryDarkest,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white38,
                                          offset: const Offset(5.0, 5.0),
                                          blurRadius: 10.0,
                                          spreadRadius: 2.0,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Buy Mints',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors
                                                      .colorWhiteHighEmp,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.access_time_filled,
                                                size: 28,
                                                color:
                                                    AppColors.colorWhiteHighEmp,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 30),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: List.generate(
                                                  buyMins.length, (index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      activeBuyMintsIndex =
                                                          index;
                                                    });
                                                  },
                                                  child: Card(
                                                    elevation: 5,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),

                                                    // Change color based on active index
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Stack(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: 50),
                                                              Image.asset(
                                                                "assets/images/coin.webp",
                                                                width: 120,
                                                                height: 80,
                                                              ),
                                                              SizedBox(
                                                                  height: 50),
                                                            ],
                                                          ),
                                                          Positioned(
                                                            top: -27,
                                                            left: -32,
                                                            child: Transform
                                                                .rotate(
                                                              angle: -0.5,
                                                              child: Container(
                                                                width: 180,
                                                                height: 40,
                                                                color: activeBuyMintsIndex ==
                                                                        index
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .redAccent,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 20.0,
                                                                      left: 24),
                                                                  child: Text(
                                                                    buyMins[index]
                                                                        [
                                                                        "mints"],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: -20,
                                                            right: 0,
                                                            child: Container(
                                                              height: 60,
                                                              width: 130,
                                                              color: activeBuyMintsIndex ==
                                                                      index
                                                                  ? Colors.green
                                                                  : Colors
                                                                      .redAccent,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10,
                                                                      left: 45),
                                                              child: Text(
                                                                buyMins[index]
                                                                    ["price"],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
                              backgroundColor: Colors.white,
                              elevation: 5,
                              shadowColor: Colors.black.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Buy Mints",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Image.asset(
                                    "assets/images/coin.webp",
                                    width: 40,
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 235,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              " Check In",
                              style: TextStyle(
                                  color: AppColors.colorWhiteHighEmp,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.check_box_rounded,
                              color: AppColors.colorWhiteHighEmp,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children:
                                List.generate(dailyCheckIn.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _activeCheckInIndex = index;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: _activeCheckInIndex == index
                                          ? AppColors.colorError
                                          : AppColors.colorWhiteHighEmp,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          // Shadow color
                                          offset: Offset(0, 4),
                                          // Offset of the shadow
                                          blurRadius: 6,
                                          // Blur radius of the shadow
                                          spreadRadius:
                                              1, // Spread radius of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _activeCheckInIndex == index
                                              ? Icons.lock_open_rounded
                                              : Icons.lock_rounded,
                                          size: 20,
                                          color: _activeCheckInIndex == index
                                              ? AppColors.colorWhiteHighEmp
                                              : AppColors.colorError,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          dailyCheckIn[index]['point'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: _activeCheckInIndex ==
                                                      index
                                                  ? AppColors.colorWhiteHighEmp
                                                  : AppColors.colorPrimaryDark),
                                        ),
                                        Image.asset(
                                          "assets/images/coin.webp",
                                          width: 30,
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Day ${dailyCheckIn[index]["day"]}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.colorWhiteHighEmp)),
                                ],
                              ),
                            ),
                          );
                        })),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Text(
              //             "Watch Ads",
              //             style: TextStyle(
              //               color: AppColors.colorWhiteHighEmp,
              //               fontSize: 18,
              //             ),
              //           ),
              //           SizedBox(width: 8),
              //           Container(
              //             padding: EdgeInsets.all(2),
              //             decoration: BoxDecoration(
              //               color: Colors.grey[800],
              //               borderRadius: BorderRadius.circular(20),
              //             ),
              //             child: Icon(
              //               Icons.question_mark,
              //               size: 16,
              //               color: AppColors.colorWhiteHighEmp,
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 4),
              //       Text(
              //         "You can watch up to 7 ads every day",
              //         style: TextStyle(color: Colors.white54, fontSize: 12),
              //       ),
              //       SizedBox(height: 20),
              //       Container(
              //         height: MediaQuery.of(context).size.height * 0.64,
              //         child: Column(
              //           children: List.generate(rewards.length, (index) {
              //             return Padding(
              //               padding: const EdgeInsets.symmetric(vertical: 10.0),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Row(
              //                     children: [
              //                       Padding(
              //                         padding:
              //                             const EdgeInsets.only(bottom: 8.0),
              //                         child: Icon(
              //                           rewards[index]['icon'],
              //                           size: 30,
              //                           color: AppColors.colorError,
              //                         ),
              //                       ),
              //                       SizedBox(width: 10),
              //                       Image.asset(
              //                         "assets/images/coin.png",
              //                         width: 25,
              //                         height: 20,
              //                       ),
              //                       Text(
              //                         rewards[index]['reward'],
              //                         style: TextStyle(
              //                           color: AppColors.colorWhiteHighEmp,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.bold,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   ElevatedButton(
              //                     onPressed: () {
              //                       setState(() {
              //                         _activeIndex = index;
              //                       });
              //                     },
              //                     child: Row(
              //                       children: [
              //                         Icon(
              //                           Icons.video_camera_back_outlined,
              //                           color: Colors.white,
              //                           size: 18,
              //                         ),
              //                         SizedBox(width: 4),
              //                         Text(
              //                           rewards[index]['buttonText'],
              //                           style: TextStyle(
              //                             color: AppColors.colorWhiteHighEmp,
              //                             fontSize: 12,
              //                             fontWeight: FontWeight.w700,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     style: ElevatedButton.styleFrom(
              //                       backgroundColor: _activeIndex == index
              //                           ? AppColors.colorError
              //                           : Colors.grey[900],
              //                       shape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(5),
              //                       ),
              //                       padding:
              //                           EdgeInsets.symmetric(horizontal: 20),
              //                       elevation: 5,
              //                       shadowColor: Colors.black.withOpacity(0.5),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             );
              //           }),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ));
  }
}
