import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/myBottomNavModel.dart';

class GenreScreen extends StatelessWidget {
  const GenreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: GestureDetector(
        onTap: () {
          Get.offAll(const MyBottomNavModel());
        },
        child: Text("hello"),
      )),
    );
  }
}
