import 'package:flutter/material.dart';

import '../../utils/appColors.dart';
import 'contactUsScreen.dart';
import 'faqScreen.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: AppColors.colorSecondaryDarkest,
        elevation: 0,
        bottom: TabBar(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          unselectedLabelColor: AppColors.colorWhiteHighEmp,
          labelColor: AppColors.colorWhiteHighEmp,
          controller: tabController,
          tabs: const [
            Tab(
              text: 'FAQ',
            ),
            Tab(
              text: 'Contact Us',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          FaqScreen(),
          ContactUsScreen(),
        ],
      ),
    );
  }
}
