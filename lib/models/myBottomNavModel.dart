// Import necessary packages and screens
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/screens/homeScreen/homeScreen.dart';
import 'package:reelies/screens/reels/VideoScreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:reelies/screens/walletScreens/watchAds.dart';
import '../screens/profileScreen/profileScreen.dart';
import '../screens/searchScreen/searchScreen.dart';
import '../utils/appColors.dart';

// Define the class for the bottom navigation model
class MyBottomNavModel extends StatefulWidget {
  const MyBottomNavModel({super.key});

  @override
  State<MyBottomNavModel> createState() => _MyBottomNavModelState();
}

// Define the state of the bottom navigation model
class _MyBottomNavModelState extends State<MyBottomNavModel> {
  int _selectedIndex = 1;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    // DownloadScreen(),
    VideoScreen(),
    SearchScreen(),
    // MyListScreen(),
    WatchAds(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.colorGrey,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              rippleColor: AppColors.colorWhiteHighEmp,
              hoverColor: AppColors.colorPrimary,
              gap: 8,
              activeColor: AppColors.colorWhiteHighEmp,
              iconSize: 25,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.colorPrimary,
              color: AppColors.colorWhiteHighEmp,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                // GButton(
                //   icon: Icons.download,
                //   text: 'Download',
                // ),
                GButton(
                  icon: Icons.smart_display_outlined,
                  text: 'Reels',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.wallet_giftcard_rounded,
                  text: 'Wallet',
                ),
                GButton(
                  icon: Icons.account_circle_outlined,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
