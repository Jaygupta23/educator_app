import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reelies/routes/routes.dart';
import 'package:reelies/utils/appColors.dart';
import 'package:reelies/utils/primarySwatch.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // Set the status bar color to transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Ensure that the Flutter framework's binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // Initialize notification settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Create notification channel (important for Android)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel name
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    androidImplementation?.createNotificationChannel(channel);

    requestNotificationPermission(); // Request notification permission
  }

  Future<void> requestNotificationPermission() async {
    // Check and request permission using permission_handler for Android
    var status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.notification.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the `flutter_screenutil` package
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Return the main `GetMaterialApp` widget
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // Set the app's primary color based on the `AppColors.colorPrimary` value
            primarySwatch: createMaterialColor(AppColors.colorPrimary),
            // Set the app's default font family to 'Kanit'
            fontFamily: 'Kanit',
          ),
          // Set the initial route of the app to the splash screen
          initialRoute: RoutesClass.getSplashScreenRoute(),
          // Define the app's routes using `Get` package
          getPages: RoutesClass.routes,
          // Set named routes for the app using `Get` package
          routes: const {
            // Your named routes here
          },
        );
      },
    );
  }
}
