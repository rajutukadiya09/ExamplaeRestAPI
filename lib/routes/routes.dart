import 'package:get/get.dart';
import 'package:nimodrive/ui/fullscreenview/Details_screen.dart';

import '../network/model/webview_page.dart';
import '../ui/dashboard/dashboard_screen.dart';
import '../ui/otp/Otp_Screen.dart';
import '../ui/settings/Settings_Screen.dart';
import '../ui/signIn/sign_in_screen.dart';
import '../ui/splash/splash_screen.dart';
import '../ui/tags/tags_screen.dart';
import '../utils/constant.dart';

class Routes {
  // Define a list of application routes
  static final routes = [
    // Route for the Sign In screen
    GetPage(
      name: routeSignIn,
      page: () => const SignInScreen(),
    ),
    // Route for the Splash screen
    GetPage(
      name: routeSplash,
      page: () => const SplashScreen(),
    ),
    // Route for the Dashboard screen
    GetPage(
      name: routeDashboard,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: routeDetailsScreen,
      page: () => const DetailsScreen(),
    ),
    // Route for the Tags screen
    GetPage(
      name: routeTagsScreen,
      page: () => const TagsScreen(),
    ),
    // Route for the Inventory screen
    GetPage(
      name: routeInvScreen,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: routeWebViewScreen,
      page: () => const WebViewPage(),
    ),
    GetPage(
      name: routeMainScreen,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: routeSettingsScreen,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: routeOTPScreen,
      page: () => const OtpScreen(),
    ),
  ];

  // Stack to manage the open screens with routeName and path
  static final List<Map<String, String>> openScreenStack = [];

  // Navigate to a screen and add it to the stack with routeName and path
  static void navigateTo(String routeName, String path) {
    // Check if the screen is already in the stack
    openScreenStack.add({
      "routeName": routeName,
      "path": path,
    });

    print(openScreenStack.length.toString());
    // Navigate to the screen with a unique parameter
    Get.offAndToNamed(routeName, arguments: {"path": path, "timestamp": DateTime.now().millisecondsSinceEpoch});
  }
  static void navigateToStack(String routeName, String path, String fileName) {
    print("--------->${fileName}");
    // Check if the screen is already in the stack
    openScreenStack.add({
      "routeName": routeName,
      "path": path,

    });

    print(openScreenStack.length.toString());
    // Navigate to the screen with a unique parameter
    Get.toNamed(routeName, arguments: {"path": path, "timestamp": DateTime.now().millisecondsSinceEpoch, "name": fileName,});
  }

  // Navigate back and remove the top screen from the stack
  static void goBack() {
    if (openScreenStack.isNotEmpty) {
      openScreenStack.removeLast();
    }
    Get.back();
  }

  // Get the current screen's path
  static String? getCurrentPath() {
    if (openScreenStack.isNotEmpty) {
      return openScreenStack.last["path"];
    } else {
      return getCurrentSelectedPath();
    }

     return null;
  }

  static String selectedPath = "/Drive";

  static String? getCurrentSelectedPath() {
    return selectedPath;
  }

  static void setCurrentSelectedPath(String selectedpath) {
    selectedPath = selectedpath;
  }

  // Debugging helper to print the stack
  static void printStack() {
    print("Open Screen Stack:");
    for (var screen in openScreenStack) {
      print("Route: ${screen['routeName']}, Path: ${screen['path']}");
    }
  }
}
