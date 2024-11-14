import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/myBottomNavModel.dart';
import '../../models/rememberMeModel.dart';
import '../../screens/authScreens/signInScreen.dart';
import '../../utils/appColors.dart';
import '../../utils/constants.dart';
import '../../utils/myButton.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String apiKey = dotenv.env['API_KEY'] ?? '';
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  var obscureText = true;
  var obscureText2 = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      // Use the same channel ID as defined in main.dart
      'High Importance Notifications',
      channelDescription: 'Channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

  Future<void> createUser() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("http://$apiKey:8000/user/register/");
    final body = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'confirmPassword': passwordController2.text,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      var responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        print("user created ");
        await showNotification(
          'Registration Success',
          'You have successfully registered.',
        );
        emailController.clear();
        nameController.clear();
        passwordController.clear();
        passwordController2.clear();
        Get.offAll(() => const SignInScreen());
      } else {
        print("error in user created api");
        String errorMessage = responseData['message'] ?? 'Registration failed.';
        await showNotification('Registration Failed', errorMessage);
      }
    } catch (e) {
      print("error: $e");
      await showNotification(
        'Error',
        'An error occurred during registration. Please try again.',
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhiteMidEmp,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/e5.png"),
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
                SizedBox(height: MediaQuery.of(context).size.height *0.32),
                Text(
                  createAccount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36.sp,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.colorWhiteLowEmp,
                        borderRadius: BorderRadius.circular(8)),
                    width: 296.w, // width of container
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      // Controller for name input field
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email";
                        }

                        return null;
                      },
                      style: const TextStyle(color: AppColors.colorBlackHighEmp),
                      // Style for the text entered in the field
                      decoration: InputDecoration(
                        hintText: 'Enter Nickname',
                        hintStyle:
                            const TextStyle(color: AppColors.colorBlackHighEmp),
                        // Style for the hint text
                        prefixIcon: const Icon(
                          Icons.perm_contact_cal_rounded,
                          color: AppColors.colorBlackHighEmp, // Color for the icon
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 16, 8, 16),
                        // Padding for the content
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Border radius of the input field
                          borderSide: const BorderSide(
                            color: AppColors.colorWhiteLowEmp,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          // Border radius of the input field when it is focused
                          borderSide: const BorderSide(
                            color: AppColors.colorWhiteLowEmp,
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
                    decoration: BoxDecoration(
                        color: AppColors.colorWhiteLowEmp,
                        borderRadius: BorderRadius.circular(8)),
                    width: 296.w, // width of container
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      // Controller for email input field
                      validator: (value) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value!);
                        if (value.isEmpty) {
                          return "Enter Email";
                        } else if (!emailValid) {
                          return "Enter valid Email";
                        }
                        return null;
                      },
                      style: const TextStyle(color: AppColors.colorBlackHighEmp),
                      // Style for the text entered in the field
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle:
                            const TextStyle(color: AppColors.colorBlackHighEmp),
                        // Style for the hint text
                        prefixIcon: const Icon(
                          Icons.send_rounded,
                          color: AppColors.colorBlackHighEmp, // Color for the icon
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 16, 8, 16),
                        // Padding for the content
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Border radius of the input field
                          borderSide: const BorderSide(
                            color: AppColors.colorWhiteMidEmp,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          // Border radius of the input field when it is focused
                          borderSide: const BorderSide(
                            color: AppColors.colorWhiteMidEmp,
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
                            .colorWhiteLowEmp, // background color of the container
                        borderRadius: BorderRadius.circular(
                            8)), // rounded corners of the container
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscureText,
                      // hides the entered text
                      controller: passwordController,
                      // controller for the TextFormField
                      validator: (value) {
                        // validation function for the TextFormField
                        if (value!.isEmpty) {
                          return "Enter Password"; // error message when no value is entered
                        } else if (passwordController.text.length < 6) {
                          return "Password length should be more than 6 chars..";
                        } else if (passwordController2.text !=
                            passwordController.text) {
                          return "Password and Confirm Password does not Match";
                        }
                        return null;
                      },
                      style: const TextStyle(color: AppColors.colorBlackHighEmp),
                      // text style of the entered text
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color:
                              AppColors.colorBlackHighEmp, // color of the lock icon
                        ),
                        hintText: 'Enter Password',
                        // hint text for the TextFormField
                        hintStyle:
                            const TextStyle(color: AppColors.colorBlackHighEmp),
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
                                  color: AppColors.colorInfo,
                                  size: 20) // eye icon to hide the password
                              : const Icon(Icons.visibility_outlined,
                                  color: AppColors.colorInfo,
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
                                .colorWhiteMidEmp, // color of the enabled border
                            width: 1, // width of the enabled border
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // rounded corners of the focused border
                          borderSide: const BorderSide(
                            color: AppColors
                                .colorWhiteMidEmp, // color of the focused border
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
                        color: AppColors.colorWhiteLowEmp,
                        borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscureText2,
                      controller: passwordController2,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Confirm Password";
                        } else if (passwordController2.text.length < 6) {
                          return "Password length should be more than 6 chars..";
                        } else if (passwordController2.text !=
                            passwordController.text) {
                          return "Password and Confirm Password does not Match";
                        }
                        return null;
                      },
                      style: const TextStyle(color: AppColors.colorBlackHighEmp),
                      decoration: InputDecoration(
                        // Icon shown to the left of the input field
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.colorBlackHighEmp,
                        ),
                        // Hint text displayed in the input field
                        hintText: 'Confirm Password',
                        hintStyle:
                            const TextStyle(color: AppColors.colorBlackHighEmp),
                        // Icon shown to the right of the input field
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText2 = !obscureText2;
                            });
                          },
                          child: obscureText2
                              ? const Icon(Icons.visibility_off,
                                  color: AppColors.colorInfo, size: 20)
                              : const Icon(Icons.visibility_outlined,
                                  color: AppColors.colorInfo, size: 20),
                        ),
                        // Padding inside the input field
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 16, -12, 16),
                        // Border configuration for the input field when it's enabled
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorWhiteMidEmp,
                            width: 1,
                          ),
                        ),
                        // Border configuration for the input field when it's focused
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.colorWhiteMidEmp,
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
                            color: AppColors.colorPrimaryDark,
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
                      onPressed: () async {
                        // Validate the form field
                        if (_formfield.currentState!.validate()) {
                          // Clear the email and password fields
                          FocusScope.of(context).unfocus();
                          await createUser();
                          // Navigate to the MyBottomNavModel screen
                        }
                      },
                      text: isLoading ? "" : "Create account"),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Displays a horizontal line image
                    Image.asset('assets/images/Line 2.png',
                        height: 40.h, width: 70.w),
                    SizedBox(width: 10.w),
                    // Displays text
                    Text(continueWith,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.colorBlackHighEmp,
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
                        // Get.offAll(const MyBottomNavModel());
                      },
                      child: Image.asset('assets/images/facebook.png',
                          height: 32.h, width: 32.w),
                    ),
                    SizedBox(width: 10.w),
                    // Displays a Google icon which the user can tap to sign up/in with Google
                    GestureDetector(
                      onTap: () {
                        // Get.offAll(const MyBottomNavModel());
                      },
                      child: Image.asset('assets/images/google.png',
                          height: 40.h, width: 40.w),
                    ),
                    // Displays an Apple icon which the user can tap to sign up/in with Apple
                    GestureDetector(
                      onTap: () {
                        // Get.offAll(const MyBottomNavModel());
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
                        color: AppColors.colorBlackLowEmp,
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
                            color: AppColors.colorInfo,
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
