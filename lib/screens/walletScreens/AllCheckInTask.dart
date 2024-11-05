import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:reelies/models/myBottomNavModel.dart';
import 'package:reelies/screens/walletScreens/watchAds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/appColors.dart';

class AllCheckInTask extends StatefulWidget {
  final List<Map<String, dynamic>> checkInTask;

  AllCheckInTask({Key? key, required this.checkInTask}) : super(key: key);

  @override
  State<AllCheckInTask> createState() => _AllCheckInTaskState();
}

class _AllCheckInTaskState extends State<AllCheckInTask> {
  late List<Map<String, dynamic>> allCheckInTask;
  int _activeCheckInIndex = -1;
  int points = 0;

  String taskId = '';
  String apiKey = dotenv.env['API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    allCheckInTask = widget.checkInTask; // Initialize allCheckInTask
    fetchPoints(); // Call the async method to fetch points
  }

  Future<void> fetchPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      points = prefs.getInt("point") ?? 0; // Retrieve points or default to 0
    });
  }

  Future<void> UpdatedCheckInTask(id) async {
    final String url = 'http://192.168.1.48:8000/user/collectCheckIn/';
    final prefs = await SharedPreferences.getInstance();
    String? storedUserData = prefs.getString('userData');
    // Retrieve existing points or default to 0

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
          // Update task status to "Completed" in the checkInTask list
          setState(() {
            for (var task in allCheckInTask) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'All CheckIn Task',
              style: TextStyle(color: AppColors.colorSecondaryLight),
            ),
            Row(
              children: [
                Text(
                  "${points} ",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  width: 1,
                ),
                Image.asset(
                  "assets/images/coin.webp",
                  width: 25,
                  height: 25,
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: AppColors.colorSecondaryLight,
          onPressed: () {
            Get.offAll(() => MyBottomNavModel()); // Navigate back using GetX
          },
        ),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // Number of items per row
                  childAspectRatio: 0.65,
                  // Adjust the height/width ratio of the grid items
                  crossAxisSpacing: 1,
                  // Spacing between columns
                  mainAxisSpacing: 3, // Spacing between rows
                ),
                itemCount: allCheckInTask.length,
                shrinkWrap: true,
                // Allows the GridView to take up only as much space as needed
                physics: NeverScrollableScrollPhysics(),
                // Prevents GridView from scrolling
                itemBuilder: (context, index) {
                  final task = allCheckInTask[index];
                  final task_id = task['taskId'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeCheckInIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Padding(
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
                                      width: 110,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: _activeCheckInIndex == index
                                            ? AppColors.colorSuccess
                                            : AppColors.colorWhiteHighEmp,
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.4),
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
                                          SizedBox(height: 70),
                                          // Adjust for spacing from the top
                                          Text(
                                            'Day ${task["Day"]}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: _activeCheckInIndex ==
                                                      index
                                                  ? AppColors.colorWhiteHighEmp
                                                  : AppColors.colorPrimaryDark,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          GestureDetector(
                                            onTap: task["status"] == 'Pending'
                                                ? () {
                                                    setState(() {
                                                      _activeCheckInIndex =
                                                          index;
                                                      taskId = task_id;
                                                    });
                                                    UpdatedCheckInTask(taskId);
                                                  }
                                                : null,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 14.8,
                                                  vertical: 3),
                                              decoration: BoxDecoration(
                                                color:
                                                    task["status"] == 'Pending'
                                                        ? AppColors.colorError
                                                        : AppColors
                                                            .colorWhiteHighEmp,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Text(
                                                task["status"] == 'Completed'
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
                                                      ? AppColors.colorSuccess
                                                      : task["status"] ==
                                                              'Missed'
                                                          ? AppColors.colorError
                                                          : task["status"] ==
                                                                  'Alloted'
                                                              ? Colors
                                                                  .amber[800]
                                                              : AppColors
                                                                  .colorWhiteHighEmp,
                                                  fontWeight: FontWeight.w600,
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
                                      left: 8,
                                      // Positioning to center it horizontally
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(90),
                                          bottomRight: Radius.circular(90),
                                        ),
                                        child: Container(
                                          width: 90,
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
                                                  fontWeight: FontWeight.bold,
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
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
