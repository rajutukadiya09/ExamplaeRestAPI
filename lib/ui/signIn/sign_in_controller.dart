import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../network/api/base_repository.dart';
import '../../network/http_service.dart';
import '../../network/model/dblist_model.dart';
import '../../network/model/result_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_pref.dart';
import '../../utils/constant.dart';
import '../../utils/utility.dart';
import '../splash/splash_controller.dart';

enum ViewState {
  initial,
  loading,
  loadingDashboardData,
  error,
  success,
}

class SignInController extends GetxController {
  var isLoading = false.obs;

  HttpService httpService;
  final Rx<ViewState> viewState = ViewState.initial.obs;
  final List<ViewState> historyViewState = <ViewState>[];
  BaseRepository baseRepository = BaseRepository();
  DbListModel? dbListModel;
  String? token;
  String deviceName = '';
  String errorMsg = '';
  String successMsg = '';
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController pswController = TextEditingController();
  RxBool obSecureText = false.obs;
  final SplashController controller = Get.put(SplashController());
  SignInController({required this.httpService});

  @override
  void onInit() {
    super.onInit();
    //getDeviceInfo();
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    deviceName = allInfo['model'];
    return allInfo;
  }

  Future<void> getDBListApiCall() async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.sluDbLoad,
          request: {"params": {}},
        );
        if (result.success) {
          dbListModel =
              DbListModel.fromJson(result.result as Map<String, dynamic>);
          successMsg = result.message ?? '';
        } else {
          errorMsg = result.message ?? '';
          showCenterFlash(
            message: errorMsg,
            color: red,
            context: Get.context!,
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
    } else {
      errorMsg = msgNoInternet;
      showCenterFlash(
        message: errorMsg,
        color: red,
        context: Get.context!,
      );
    }
  }

  Future<void> loginApiCall(
      { String? email,
       String? password,
      bool navigatePop = false}) async {
    if (await checkNetwork() == 0) {
      try {
        Map<String, String> headers = <String, String>{
          'Content-type': 'application/json',
          'email': email?.trim() ?? '',
          'key': password?.trim() ?? ''
        };
        showLog('REQUEST:: ${headers.toString()}');
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.login, request: headers,rawvalue: '');
        if (result.success) {
          getDecrypted(result.result.data.toString());
          print('Response Headers: ${result.result.headers}');
          final token =
              result.result.headers.value('token'); // Or 'X-Token', etc.
          await AppPref().putAccessToken(token.toString());
          await AppPref().putSeasonToken(result.result.toString());
          await AppPref().putIsLogIn();
          controller.checkLoginStatus();
        } else {
          errorMsg = 'Login failed! Please check email and password ';
          showCenterFlash(
            message: errorMsg,
            color: red,
            context: Get.context!,
          );
        }
      } catch (ex) {
        errorMsg = msgSomethingWentWrong;
        print(ex);

        showCenterFlash(
          message: errorMsg,
          color: red,
          context: Get.context!,
        );
      }
    } else {
      errorMsg = msgNoInternet;
      showCenterFlash(
        message: errorMsg,
        color: red,
        context: Get.context!,
      );
    }
  }

  Future<void> tokenSavedApi({
    required String token,
    required String deviceType,
    required String deviceName,
  }) async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.sendDeviceToken,
          request: {
            "params": {
              "token": token,
              "device_type": deviceType,
              "device_name": deviceName,
            }
          },
        );
        if (result.success) {
          successMsg = result.message ?? '';
          showCenterFlash(
            message: successMsg,
            color: green,
            context: Get.context!,
          );
          Get.offAllNamed(routeDashboard);
        } else {
          errorMsg = result.message ?? '';
          showCenterFlash(
            message: errorMsg,
            color: red,
            context: Get.context!,
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
    } else {
      errorMsg = msgNoInternet;
      showCenterFlash(
        message: errorMsg,
        color: red,
        context: Get.context!,
      );
    }
  }

  void setState(ViewState state) {
    viewState.value = state;
    historyViewState.add(state);
  }
}
