import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../network/http_service.dart';
import '../ui/signIn/sign_in_controller.dart';
import '../utils/constant.dart';

// Class responsible for dependency injection and binding
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Register Logger instance for dependency injection
    Get.put(Logger());

    // Initialize and register HttpService with a specific tag
    Get.put(HttpService().init(), tag: tagHttpService);

    // Register SignInController with dependency on HttpService
    Get.put(
      SignInController(
        httpService: Get.find(tag: tagHttpService),
      ),
    );
  }
}
