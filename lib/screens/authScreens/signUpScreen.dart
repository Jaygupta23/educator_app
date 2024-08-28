import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/myBottomNavModel.dart';
import 'package:reelies/models/rememberMeModel.dart';
import 'package:reelies/screens/authScreens/signInScreen.dart';
import 'package:get/get.dart';
import 'package:reelies/screens/onboardingScreen/genreScreen.dart';



import '../../utils/appColors.dart';
import '../../utils/constants.dart';
import '../../utils/myButton.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // This code block defines variables for a form that likely has email and password input fields:
  final _formfield = GlobalKey<
      FormState>(); // GlobalKey to access and manipulate the state of a form
  final emailController =
      TextEditingController(); // Controller for email input field
  final passwordController =
      TextEditingController(); // Controller for password input field
  final passwordController2 =
      TextEditingController(); // Controller for confirming password input field
  var obscureText =
      true; // Flag to indicate whether the password is currently hidden or not
  var obscureText2 =
      true; // Flag to indicate whether the confirm password is currently hidden or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/signUp.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formfield,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 200.h),
                Text(
                  createAccount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36.sp,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorWhiteHighEmp,
                  ),
                ),
                SizedBox(height: 10.h),
                // This code block creates a TextFormField for email input field inside a container with a grey background and a rounded border:
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.colorGrey,
                        borderRadius: BorderRadius.circular(8)),
                    width: 296.w, // width of container
                    child: TextFormField(
                      controller: emailController,
                      // Controller for email input field
                      validator: (value) {
                        bool emailValid = RegExp(
                                r"^WS{1,2}:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:56789")
                            .hasMatch(value!);
                        if (value.isEmpty) {
                          return "Enter Email";
                        } else if (emailValid) {
                          return "Enter valid Email";
                        }
                        return null;
                      },
                      style: const TextStyle(color: AppColors.colorDisabled),
                      // Style for the text entered in the field
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle:
                            const TextStyle(color: AppColors.colorDisabled),
                        // Style for the hint text
                        prefixIcon: const Icon(
                          Icons.send_rounded,
                          color: AppColors.colorDisabled, // Color for the icon
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 16, 8, 16),
                        // Padding for the content
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Border radius of the input field
                          borderSide: const BorderSide(
                            color: AppColors.colorGrey,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          // Border radius of the input field when it is focused
                          borderSide: const BorderSide(
                            color: AppColors.colorGrey,
                            width: 1,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          // Border radius of the input field when there is an error
                          borderSide: const BorderSide(
                            color: AppColors.colorError,
                            // Border color when there is an error
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          // Border radius of the input field when there is an error and it is focused
                          borderSide: const BorderSide(
                            color: AppColors.colorError,
                            // Border color when there is an error and it is focused
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
                    width: 296.w, // width of the container
                    decoration: BoxDecoration(
                        color: AppColors
                            .colorGrey, // background color of the container
                        borderRadius: BorderRadius.circular(
                            8)), // rounded corners of the container
                    child: TextFormField(
                      obscureText: obscureText,
                      // hides the entered text
                      controller: passwordController,
                      // controller for the TextFormField
                      validator: (value) {
                        // validation function for the TextFormField
                        if (value!.isEmpty) {
                          return "Enter Password"; // error message when no value is entered
                        } else if (passwordController.text.length < 6) {
                          return "Password length should be more than 6 characters"; // error message when password is less than 6 characters long
                        }
                        return null;
                      },
                      style: const TextStyle(color: AppColors.colorDisabled),
                      // text style of the entered text
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color:
                              AppColors.colorDisabled, // color of the lock icon
                        ),
                        hintText: 'Enter Password',
                        // hint text for the TextFormField
                        hintStyle:
                            const TextStyle(color: AppColors.colorDisabled),
                        // style for the hint text
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText =
                                  !obscureText; // toggles obscureText value to show/hide password
                            });
                          },
                          child: obscureText
                              ? const Icon(Icons.visibility_off,
                                  color: AppColors.colorPrimary,
                                  size: 20) // eye icon to hide the password
                              : const Icon(Icons.visibility_outlined,
                                  color: AppColors.colorPrimary,
                                  size: 20), // eye icon to show the password
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 16, -12, 16),
                        // padding for the entered text
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // rounded corners of the enabled border
                          borderSide: const BorderSide(
                            color: AppColors
                                .colorGrey, // color of the enabled border
                            width: 1, // width of the enabled border
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // rounded corners of the focused border
                          borderSide: const BorderSide(
                            color: AppColors
                                .colorGrey, // color of the focused border
                            width: 1, // width of the focused border
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // rounded corners of the error border
                          borderSide: const BorderSide(
                            color: AppColors
                                .colorError, // color of the error border
                            width: 1, // width of the error border
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // rounded corners of the focused error border
                          borderSide: const BorderSide(
                            color: AppColors.colorError,
                            // color of the focused error border
                            width: 1, // width of the focused error border
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),
                Center(
                  child: Container(
                    width: 296.w,
                    decoration: BoxDecoration(
                        color: AppColors.colorGrey,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                      obscureText: obscureText2,
                      controller: passwordController2,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        } else if (passwordController2.text.length < 6) {
                          return "Password length should be more than 6 characters";
                        }
                        return null;
                      },
                      style: const TextStyle(color: AppColors.colorDisabled),
                      decoration: InputDecoration(
                        // Icon shown to the left of the input field
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.colorDisabled,
                        ),
                        // Hint text displayed in the input field
                        hintText: 'Confirm Password',
                        hintStyle:
                            const TextStyle(color: AppColors.colorDisabled),
                        // Icon shown to the right of the input field
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText2 = !obscureText2;
                            });
                          },
                          child: obscureText2
                              ? const Icon(Icons.visibility_off,
                                  color: AppColors.colorPrimary, size: 20)
                              : const Icon(Icons.visibility_outlined,
                                  color: AppColors.colorPrimary, size: 20),
                        ),
                        // Padding inside the input field
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 16, -12, 16),
                        // Border configuration for the input field when it's enabled
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorGrey,
                            width: 1,
                          ),
                        ),
                        // Border configuration for the input field when it's focused
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorGrey,
                            width: 1,
                          ),
                        ),
                        // Border configuration for the input field when it has an error
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorError,
                            width: 1,
                          ),
                        ),
                        // Border configuration for the input field when it's focused and has an error
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

                const RememberMeModel(),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: MyButton(
                      onPressed: () {
                        // Validate the form field
                        if (_formfield.currentState!.validate()) {
                          // Clear the email and password fields
                          emailController.clear();
                          passwordController.clear();
                          // Navigate to the MyBottomNavModel screen
                          Get.offAll(() => GenreScreen());
                        }
                      },
                      text: "CREATE ACCOUNT"),
                ),

                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Displays a horizontal line image
                    Image.asset('assets/images/Line 1.png',
                        height: 40.h, width: 70.w),
                    SizedBox(width: 10.w),
                    // Displays text
                    Text(continueWith,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.colorWhiteHighEmp,
                        )),
                    SizedBox(width: 10.w),
                    // Displays another horizontal line image
                    Image.asset(
                      'assets/images/Line 2.png',
                      height: 40.h,
                      width: 70.w,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Displays a Facebook icon which the user can tap to sign up/in with Facebook
                    GestureDetector(
                      onTap: () {
                        Get.offAll(const MyBottomNavModel());
                      },
                      child: Image.asset('assets/images/facebook.png',
                          height: 32.h, width: 32.w),
                    ),
                    SizedBox(width: 10.w),
                    // Displays a Google icon which the user can tap to sign up/in with Google
                    GestureDetector(
                      onTap: () {
                        Get.offAll(const MyBottomNavModel());
                      },
                      child: Image.asset('assets/images/google.png',
                          height: 40.h, width: 40.w),
                    ),
                    // Displays an Apple icon which the user can tap to sign up/in with Apple
                    GestureDetector(
                      onTap: () {
                        Get.offAll(const MyBottomNavModel());
                      },
                      child: Image.asset('assets/images/apple.png',
                          height: 50.h, width: 45.w),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Displays text prompting the user to sign in if they have an account
                    Text(
                      haveAccount,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.colorWhiteHighEmp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    // Displays a "Sign In" button that the user can tap to navigate to the sign in screen
                    InkWell(
                      onTap: () {
                        Get.offAll(const SignInScreen());
                      },
                      child: Text(
                        signIn,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.colorPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
