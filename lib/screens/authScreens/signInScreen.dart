import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reelies/models/myBottomNavModel.dart';
import 'package:reelies/models/rememberMeModel.dart';
import 'package:reelies/screens/authScreens/signUpScreen.dart';
import 'package:reelies/screens/interestScreen.dart';
import 'package:get/get.dart';


import '../../utils/appColors.dart';
import '../../utils/constants.dart';
import '../../utils/myButton.dart';
import 'forgotPasswordScreen/forgotPasswordScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // A global key to identify the form and perform validation
  final _formfield = GlobalKey<FormState>();

// Controllers to get values from text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

// A boolean flag to toggle password visibility
  var obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorSecondaryDarkest,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/signIn.png"),
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
                SizedBox(height: 220.h),
                Text(
                  loginTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36.sp,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.colorWhiteHighEmp,
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors
                          .colorGrey, // sets the background color of the container
                      borderRadius: BorderRadius.circular(
                          8), // sets the border radius of the container
                    ),
                    width: 296.w, // sets the width of the container
                    child: TextFormField(
                      controller:
                          emailController, // sets the controller for the text input field
                      validator: (value) {
                        // defines the validation function for the text input field
                        // checks if the input value matches a specific pattern
                        bool emailValid = RegExp(
                                r"^WS{1,2}:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:56789")
                            .hasMatch(value!);
                        if (value.isEmpty) {
                          // checks if the input value is empty
                          return "Enter Email";
                        } else if (emailValid) {
                          // checks if the input value matches the specified pattern
                          return "Enter valid Email";
                        }
                        return null;
                      },
                      style: const TextStyle(
                          color: AppColors
                              .colorDisabled), // sets the text style for the text input field
                      decoration: InputDecoration(
                        hintText:
                            'Email Address', // sets the hint text for the text input field
                        hintStyle: const TextStyle(
                            color: AppColors
                                .colorDisabled), // sets the hint text style for the text input field
                        prefixIcon: const Icon(
                          Icons.send_rounded,
                          color: AppColors.colorDisabled,
                        ), // sets the prefix icon for the text input field
                        contentPadding: const EdgeInsets.fromLTRB(10, 16, 8,
                            16), // sets the padding for the text input field content
                        enabledBorder: OutlineInputBorder(
                          // sets the border for the enabled state of the text input field
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorGrey,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          // sets the border for the focused state of the text input field
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorGrey,
                            width: 1,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          // sets the border for the error state of the text input field
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorError,
                            width: 1,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          // sets the border for the focused error state of the text input field
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
                Center(
                  child: Container(
                    // Set the width of the container to 296 device-independent pixels (dp)
                    width: 296.w,
                    // Set the background color of the container to grey with 8px rounded corners
                    decoration: BoxDecoration(
                        color: AppColors.colorGrey,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                      // If obscureText is true, hide the text being entered (for passwords)
                      obscureText: obscureText,
                      // Assign a controller to the text field for reading the entered text
                      controller: passwordController,
                      // Add validation for the entered text
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        } else if (passwordController.text.length < 6) {
                          return "Password length should be more than 6 characters";
                        }
                        return null;
                      },
                      // Set the style of the text being entered to disabled color
                      style: const TextStyle(color: AppColors.colorDisabled),
                      // Customize the appearance of the text field
                      decoration: InputDecoration(
                        // Add an icon to the left of the input field
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.colorDisabled,
                        ),
                        // Add placeholder text to the input field
                        hintText: 'Password',
                        // Set the style of the placeholder text to disabled color
                        hintStyle:
                            const TextStyle(color: AppColors.colorDisabled),
                        // Add a visibility toggle icon to the right of the input field
                        suffixIcon: GestureDetector(
                          onTap: () {
                            // When the visibility toggle icon is tapped, toggle the value of obscureText
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: obscureText
                              ? const Icon(Icons.visibility_off,
                                  color: AppColors.colorPrimary, size: 20)
                              : const Icon(Icons.visibility_outlined,
                                  color: AppColors.colorPrimary, size: 20),
                        ),
                        // Add padding to the content of the input field
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 16, -12, 16),
                        // Add border to the input field when it is enabled but not focused
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorGrey,
                            width: 1,
                          ),
                        ),
                        // Add border to the input field when it is focused
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorGrey,
                            width: 1,
                          ),
                        ),
                        // Add border to the input field when there is an error
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorError,
                            width: 1,
                          ),
                        ),
                        // Add border to the input field when there is an error and it is focused
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: MyButton(
                      onPressed: () {
                        // Check if the form is valid before logging in
                        if (_formfield.currentState!.validate()) {
                          // Clear the email and password fields
                          emailController.clear();
                          passwordController.clear();
                          // Navigate to the interest screen
                          Get.offAll(const InterestScreen());
                        }
                      },
                      text: "LOGIN"),
                ),
                SizedBox(height: 5.h),
                InkWell(
                  onTap: () {
                    Get.to(() => const ForgotPasswordScreen());
                  },
                  child: Text(
                    forgotPassword,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.colorPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // first row with decorative elements
                    Image.asset('assets/images/Line 1.png',
                        width: 70.w), // image asset with a fixed width
                    SizedBox(width: 10.w), // empty space between the two images
                    Text(continueWith, // text displayed in the center
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors
                              .colorWhiteHighEmp, // white color defined elsewhere
                        )),
                    SizedBox(width: 10.w), // another empty space
                    Image.asset('assets/images/Line 2.png',
                        width: 70.w), // another image asset
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // second row with social media login buttons
                    GestureDetector(
                      onTap: () {
                        Get.offAll(
                            const MyBottomNavModel()); // navigation function to another screen
                      },
                      child: Image.asset('assets/images/facebook.png',
                          height: 32.h,
                          width: 32
                              .w), // Facebook login button image with height and width
                    ),
                    SizedBox(width: 10.w), // empty space between the images
                    GestureDetector(
                      onTap: () {
                        Get.offAll(const MyBottomNavModel());
                      },
                      child: Image.asset('assets/images/google.png',
                          height: 40.h,
                          width: 40
                              .w), // Google login button image with height and width
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(const MyBottomNavModel());
                      },
                      child: Image.asset('assets/images/apple.png',
                          height: 50.h,
                          width: 45
                              .w), // Apple login button image with height and width
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // third row with "Don't have an account?" and sign-up button
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors
                            .colorWhiteHighEmp, // white color defined elsewhere
                      ),
                    ),
                    SizedBox(width: 5.w), // empty space between the two texts
                    InkWell(
                      onTap: () {
                        Get.to(
                            const SignUpScreen()); // navigation function to another screen
                      },
                      child: Text(
                        signUp,
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors
                                .colorPrimary, // primary color defined elsewhere
                            fontWeight: FontWeight.bold), // bold font weight
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
