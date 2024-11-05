import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/myBottomNavModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/genderDropdownModel.dart';
import '../../utils/appColors.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _genderController;
  String apiKey = dotenv.env['API_KEY'] ?? '';
  File? _imageFile;
  final List<Map<String, String>> genderItems = [
    {'value': 'Not Specified', 'image': 'assets/images/notSpecified.png'},
    {'value': 'Male', 'image': 'assets/images/img4.png'},
    {'value': 'Female', 'image': 'assets/images/img5.png'},
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text:
          (widget.userData['name'] != null && widget.userData['name'] != "null")
              ? widget.userData['name']
              : '',
    );

    _emailController = TextEditingController(
      text: (widget.userData['email'] != null &&
              widget.userData['email'] != "null")
          ? widget.userData['email']
          : '',
    );

    _mobileController = TextEditingController(
      text: (widget.userData['mobile'] != null &&
              widget.userData['mobile'] != "null")
          ? widget.userData['mobile']
          : '',
    );

    _genderController = TextEditingController(
      text: (widget.userData['gender'] != null &&
              widget.userData['gender'] != "null")
          ? widget.userData['gender']
          : '',
    );

    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImagePath');

    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _updateUserDetails() async {
    try {
      final url = Uri.parse("http://$apiKey:8000/user/editUserDetails/");
      final body = jsonEncode({
        'userId': widget.userData['_id'],
        'name': _nameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'gender': _genderController.text,
      });
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);
      if (response.statusCode == 200) {
        Map<String, dynamic> updatedUserData = {
          '_id': widget.userData['_id'],
          'name': _nameController.text,
          'email': _emailController.text,
          'mobile': _mobileController.text,
          'gender': _genderController.text,
          'loggedInBefore': widget.userData['loggedInBefore'],
          'selectedGenre': widget.userData['selectedGenre'],
          'selectedLanguages': widget.userData['selectedLanguages'],
          // Keep existing value
        };

        // Store the updated user data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(updatedUserData));
        Get.offAll(() => const MyBottomNavModel());
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Save the image path to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', pickedFile.path);
    }
  }

  // Future<void> _uploadImage(File imageFile) async {
  //   try {
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse('https://your-api-url.com/upload'),
  //     );
  //
  //     request.files.add(await http.MultipartFile.fromPath(
  //       'file',
  //       imageFile.path,
  //     ));
  //
  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //       print("Image uploaded successfully.");
  //     } else {
  //       print("Image upload failed.");
  //     }
  //   } catch (e) {
  //     print("Error uploading image: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      appBar: AppBar(
        backgroundColor: AppColors.colorSecondaryDarkest,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: AppColors.colorSecondaryLight,
          onPressed: () {
            Get.back(); // This will navigate back using GetX
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: AppColors.colorSecondaryLight),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Center(
                  child: Stack(
                    children: [
                      // Display the selected image or the default avatar
                      SizedBox(
                        height: 86.h,
                        width: 86.w,
                        child: CircleAvatar(
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : const AssetImage('assets/images/blank.webp')
                                  as ImageProvider,
                        ),
                      ),
                      // Edit icon positioned at the bottom right
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey.shade300,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  width: double.infinity,
                  child: TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: AppColors.colorDisabled),
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      hintStyle:
                          const TextStyle(color: AppColors.colorDisabled),
                      prefixIcon: const Icon(
                        Icons.perm_contact_cal_rounded,
                        color: AppColors.colorDisabled,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorGrey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorGrey,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.colorGrey,
                      borderRadius: BorderRadius.circular(8)),
                  width: double.infinity,
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: AppColors.colorDisabled),
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      hintStyle:
                          const TextStyle(color: AppColors.colorDisabled),
                      prefixIcon: const Icon(
                        Icons.send_rounded,
                        color: AppColors.colorDisabled,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorGrey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorGrey,
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorError,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.colorError,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // Center(
              //   child: Container(
              //     decoration: BoxDecoration(
              //         color: AppColors.colorGrey,
              //         borderRadius: BorderRadius.circular(8)),
              //     width: double.infinity,
              //     child: TextFormField(
              //       style: const TextStyle(color: AppColors.colorDisabled),
              //       decoration: InputDecoration(
              //         hintText: 'Nick Name',
              //         hintStyle:
              //             const TextStyle(color: AppColors.colorDisabled),
              //         contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8),
              //           borderSide: const BorderSide(
              //             color: AppColors.colorGrey,
              //             width: 1,
              //           ),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8),
              //           borderSide: const BorderSide(
              //             color: AppColors.colorGrey,
              //             width: 1,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // SizedBox(height: 10.h),
              IntlPhoneField(
                flagsButtonPadding: const EdgeInsets.only(left: 10),
                controller: _mobileController,
                dropdownTextStyle:
                    const TextStyle(color: AppColors.colorWhiteHighEmp),
                dropdownIconPosition: IconPosition.leading,
                dropdownIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.colorWhiteHighEmp,
                ),
                style: const TextStyle(
                  color: AppColors.colorWhiteHighEmp,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.colorGrey,
                  hintText: 'Phone Number',
                  counterStyle:
                      const TextStyle(color: AppColors.colorWhiteHighEmp),
                  hintStyle: const TextStyle(color: AppColors.colorGrey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                initialCountryCode: 'IN',
              ),
              GenderDropdownModel(
                gender: _genderController.text,
                onGenderChanged: (String newGender) {
                  setState(() {
                    _genderController.text = newGender;
                  });
                },
                items: genderItems, // Pass the list of maps
              ),

              SizedBox(height: 70.h),
              InkWell(
                onTap: () async {
                  await _updateUserDetails();
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorWhiteHighEmp,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
