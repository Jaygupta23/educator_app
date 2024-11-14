import 'dart:convert';
import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../screens/walletScreens/AllCheckInTask.dart';
import '../../utils/appColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class WatchAds extends StatefulWidget {
  const WatchAds({super.key});

  @override
  _WatchAdsState createState() => _WatchAdsState();
}

class _WatchAdsState extends State<WatchAds> {
  // Variable to keep track of the active button index
  int _activeCheckInIndex = -1;
  List<Map<String, dynamic>> checkInTask = [];
  List<Map<String, dynamic>> last7CheckInTasks = [];
  String apiKey = dotenv.env['API_KEY'] ?? '';
  String taskId = '';
  int points = 0;

  @override
  void initState() {
    super.initState();
    fetchCheckInTask();
  }

  Future<void> UpdatedCheckInTask(id) async {
    print(": $id");
    final String url = 'http://192.168.1.48:8000/user/collectCheckIn/';
    final prefs = await SharedPreferences.getInstance();
    String? storedUserData = prefs.getString('userData');

    if (storedUserData != null) {
      // Decode the stored user data from JSON
      Map<String, dynamic> userData = jsonDecode(storedUserData);
      String userId = userData['_id'];
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'userId': userId,
            'taskId': id,
          }),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          points += (data["allocatedPoints"] as num).toInt();
          await prefs.setInt("point", points);

          setState(() {
            for (var task in checkInTask) {
              if (task['taskId'] == id) {
                task['status'] = 'Completed';
                break;
              }
            }
            for (var task in last7CheckInTasks) {
              if (task['taskId'] == id) {
                task['status'] = 'Completed';
                break;
              }
            }
          });
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    } else {
      print('User data not found in SharedPreferences');
    }
  }

  Future<void> fetchCheckInTask() async {
    final String url = 'http://$apiKey:8000/user/checkInTask/';
    final prefs = await SharedPreferences.getInstance();
    points = prefs.getInt("point") ?? 0;
    String? storedUserData = prefs.getString('userData');

    if (storedUserData != null) {
      // Decode the stored user data from JSON
      Map<String, dynamic> userData = jsonDecode(storedUserData);
      String userId = userData['_id'];
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'userId': userId,
          }),
        );

        if (response.statusCode == 200) {
          // Parse the JSON data
          final data = jsonDecode(response.body);

          // Check if data contains checkInTask and is a list
          if (data['checkInTask'] != null && data['checkInTask'] is List) {
            setState(() {
              checkInTask =
                  List<Map<String, dynamic>>.from(data['checkInTask']);
              last7CheckInTasks = checkInTask.length > 7
                  ? checkInTask.sublist(checkInTask.length - 7)
                  : checkInTask;
            });
          } else {
            print('checkInTask data is not available');
          }
        } else {
          print('Failed to load data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    } else {
      print('User data not found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    int? activeBuyMintsIndex = -1;

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
                                    "${points} ",
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
                height: 240,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Daily Check In",
                                  style: TextStyle(
                                      color: AppColors.colorWhiteHighEmp,
                                      fontSize: 14.sp,
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
                            GestureDetector(
                              onTap: () {
                                Get.offAll(() =>
                                    AllCheckInTask(checkInTask: checkInTask));
                              },
                              child: Text(
                                'Show all',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.colorWhiteHighEmp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
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
                              List.generate(last7CheckInTasks.length, (index) {
                            final task = last7CheckInTasks[index];
                            final task_id = task['taskId'];

                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: task["status"] == 'Pending'
                                    ? () {
                                        setState(() {
                                          _activeCheckInIndex = index;
                                          taskId = task_id;
                                        });
                                        UpdatedCheckInTask(taskId);
                                      }
                                    : null,
                                child: Column(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      // Allows the semicircle to overflow the main container boundaries
                                      children: [
                                        // Main container
                                        Container(
                                          width: 120,
                                          height: 140,
                                          decoration: BoxDecoration(
                                            color: _activeCheckInIndex == index
                                                ? AppColors.colorError
                                                : AppColors.colorWhiteHighEmp,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                offset: Offset(0, 4),
                                                blurRadius: 6,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 65),
                                              // Adjust for spacing from the top
                                              Text(
                                                'Day ${task["Day"]}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: _activeCheckInIndex ==
                                                          index
                                                      ? AppColors
                                                          .colorWhiteHighEmp
                                                      : AppColors
                                                          .colorPrimaryDark,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 21.8,
                                                      vertical: 3),
                                                  decoration: BoxDecoration(
                                                    color: task["status"] ==
                                                            'Pending'
                                                        ? AppColors.colorError
                                                        : AppColors
                                                            .colorWhiteHighEmp,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                  child: Text(
                                                    task["status"] ==
                                                            'Completed'
                                                        ? "Collected"
                                                        : task["status"] ==
                                                                "Pending"
                                                            ? "Collect Now"
                                                            : task["status"] ==
                                                                    "Missed"
                                                                ? "Missed"
                                                                : "Upcoming",
                                                    style: TextStyle(
                                                      color: task["status"] ==
                                                              'Completed'
                                                          ? AppColors
                                                              .colorSuccess
                                                          : task["status"] ==
                                                                  'Missed'
                                                              ? AppColors
                                                                  .colorError
                                                              : task["status"] ==
                                                                      'Alloted'
                                                                  ? Colors.amber[
                                                                      800]
                                                                  : AppColors
                                                                      .colorWhiteHighEmp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Red semicircle positioned at the top of the main container
                                        Positioned(
                                          top: 0,
                                          // Control the overlap; adjust to your needs
                                          left: 5,
                                          // Positioning to center it horizontally
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(110),
                                              bottomRight: Radius.circular(110),
                                            ),
                                            child: Container(
                                              width: 110,
                                              // Width of the semicircle
                                              height: 50,
                                              // Height of the semicircle (half of the width for a true semicircle)
                                              color: Colors.deepPurple[500],
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    '+${task["allocatedPoints"]} ',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .colorWhiteHighEmp,
                                                      height: 1,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Mints',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors
                                                          .colorWhiteHighEmp,
                                                      height: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ));
  }
}
