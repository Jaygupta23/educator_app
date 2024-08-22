import 'package:flutter/material.dart';
import 'package:reelies/utils/appColors.dart';

class WatchAds extends StatefulWidget {
  const WatchAds({super.key});

  @override
  _WatchAdsState createState() => _WatchAdsState();
}

class _WatchAdsState extends State<WatchAds> {
  // Variable to keep track of the active button index
  int _activeIndex = 0;
  int _activeCheckInIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rewards = [
      {
        "icon": Icons.live_tv_rounded,
        "reward": "+10",
        "buttonText": "Watch Ad"
      },
      {
        "icon": Icons.live_tv_rounded,
        "reward": "+10",
        "buttonText": "Watch Ad"
      },
      {
        "icon": Icons.live_tv_rounded,
        "reward": "+10",
        "buttonText": "Watch Ad"
      },
      {
        "icon": Icons.live_tv_rounded,
        "reward": "+15",
        "buttonText": "Watch Ad"
      },
      {
        "icon": Icons.live_tv_rounded,
        "reward": "+15",
        "buttonText": "Watch Ad"
      },
      {
        "icon": Icons.live_tv_rounded,
        "reward": "+15",
        "buttonText": "Watch Ad"
      },
      {
        "icon": Icons.live_tv_rounded,
        "reward": "+20",
        "buttonText": "Watch Ad"
      },
      // Add more items here
    ];

    final List<Map<String, dynamic>> dailyCheckIn = [
      {"day": "1", "point": "+10"},
      {"day": "2", "point": "+15"},
      {"day": "3", "point": "+20"},
      {"day": "4", "point": "+25"},
      {"day": "5", "point": "+30"},
      {"day": "6", "point": "+35"},
      {"day": "7", "point": "+40"},
    ];

    return Scaffold(
        backgroundColor: AppColors.colorSecondaryDarkest,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/gift-box.avif",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        Container(
                          color:
                              AppColors.colorSecondaryDarkest.withOpacity(0.2),
                        ),
                        Positioned(
                          top: 45,
                          left: MediaQuery.of(context).size.width * 0.35,
                          child: Center(
                            child: Text(
                              "Earn Rewards",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container that overlaps the image and extends outside
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.3 - 25,
                    left: MediaQuery.of(context).size.width * 0.5 - 150,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: 300,
                      height: 50,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("My Coins ",
                              style: TextStyle(
                                  color: Colors.grey[300], fontSize: 18)),
                          Image.asset("assets/images/Cash.png"),
                          Text(
                            " 60",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 200,
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
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              " CHECK IN",
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
                              child: Container(
                                width: 70,
                                height: 110,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Day ${dailyCheckIn[index]["day"]}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: _activeCheckInIndex == index
                                              ? AppColors.colorWhiteHighEmp
                                              : AppColors.colorPrimaryDark),
                                    ),
                                    Text(
                                      dailyCheckIn[index]['point'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: _activeCheckInIndex == index
                                              ? AppColors.colorWhiteHighEmp
                                              : AppColors.colorPrimaryDark),
                                    ),
                                  ],
                                ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Watch Ads",
                          style: TextStyle(
                              color: AppColors.colorWhiteHighEmp, fontSize: 18),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            Icons.question_mark,
                            size: 16,
                            color: AppColors.colorWhiteHighEmp,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      "You can watch up to 7 ads every day",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.6, // Set your desired height
                      child: Column(
                        children: List.generate(rewards.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      rewards[index]['icon'],
                                      size: 30,
                                      color: AppColors.colorPrimary,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      rewards[index]['reward'],
                                      style: TextStyle(
                                          color: AppColors.colorWhiteHighEmp,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _activeIndex = index;
                                    });
                                  },
                                  child: Text(
                                    rewards[index]['buttonText'],
                                    style: TextStyle(
                                        color: _activeIndex == index
                                            ? Colors.white
                                            : AppColors.colorWhiteHighEmp,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _activeIndex == index
                                        ? Colors.red
                                        : Colors.grey[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 30),
                                    elevation: 5,
                                    shadowColor: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
