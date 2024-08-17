import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screens/authScreens/signInScreen.dart';
import '../screens/authScreens/signUpScreen.dart';
import '../screens/onboardingScreen/onboardingScreen.dart';
import '../screens/onboardingScreen/splashScreen.dart';

class RoutesClass {
  static String splashScreen = "/";

  static String getSplashScreenRoute() => splashScreen;
  static String onBoardingScreen = "/onBoarding";

  static String getOnBoardingScreenRoute() => onBoardingScreen;
  static String signInScreen = "/signIn";

  static String getSignInScreenRoute() => signInScreen;
  static String signUpScreen = "/signUp";

  static String getSignUpScreenRoute() => signUpScreen;

  // ---- Routes ---- //
  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: onBoardingScreen, page: () => const OnBoardingScreen()),
    GetPage(name: signInScreen, page: () => const SignInScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen()),
  ];
}
