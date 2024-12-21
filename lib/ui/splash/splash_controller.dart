import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_pref.dart';
import '../../utils/constant.dart';
import '../../utils/utility.dart';

class SplashController extends GetxController {
  String errorMsg = '';
  String successMsg = '';

  Future<void> checkLoginStatus() async {
    try {
      bool isLogin = await AppPref().getIsLogIn();
      if (isLogin) {
        Future.delayed(const Duration(seconds: 2)).then(
          (value) => Get.offAllNamed(
            routeDashboard,
             // routeOTPScreen,
            // (route) => false,
          ),
        );
      } else {
        Future.delayed(const Duration(seconds: 2)).then(
          (value) => Get.offAllNamed(
            routeSignIn,
          ),
        );
      }
    } catch (ex) {
      errorMsg = msgSomethingWentWrong;
      showCenterFlash(
        message: errorMsg,
        color: red,
        context: Get.context!,
      );
    }
  }
}
