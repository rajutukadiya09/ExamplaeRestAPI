import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../network/api/base_repository.dart';
import '../../network/model/dashboard_data_model.dart';
import '../../network/model/result_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_pref.dart';
import '../../utils/constant.dart';
import '../../utils/folder_utils.dart';
import '../../utils/utility.dart';
import '../../widgets/custom_camera.dart';
import '../inv/inv_controller.dart';

enum ViewState {
  initial,
  loading,
  loadingDashboardData,
  error,
  success,
}

class DashboardController extends GetxController {
  // Observable for loading state
  var isLoading = false.obs;
  final Rx<ViewState> viewState = ViewState.initial.obs;
  final List<ViewState> historyViewState = <ViewState>[];
/*  Rx<List<ProfileAttachment>> profileAttachments =
  Rx<List<ProfileAttachment>>([]);*/
  late Uint8List imageBytes;
  // Repository for API calls
  final BaseRepository baseRepository = BaseRepository();
  List<String> items = [];
  String dropdownvalue = '/Drives';
  // Error and success messages
  String errorMsg = '';
  String successMsg = '';

  // List to hold dashboard data
  Rx<List<DashboardDataModelRes>> dashboardDataModelRes =
      Rx<List<DashboardDataModelRes>>([]);
  Rx<List<DashboardDataModelRes>> dashboardDataModelResroot =
      Rx<List<DashboardDataModelRes>>([]);
  Root dashboradModelResroot =
      Root();

  Future<void> getJsonData() async {
    try {
      String jsondata = await AppPref().getSeasonToken();
      String tokendata = await AppPref().getAccessToken();
      print('tokendata: $tokendata');
      getDecryptedKeyValue(jsondata);
    } catch (ex){
      print(ex);
    }
  }

  Future<void> getDashboardApiCall() async {
    dashboardDataModelRes.value.clear();
    setState(ViewState.loadingDashboardData);
    if (await checkNetwork() == 0) {
      try {
        String tokendata = await AppPref().getAccessToken();
        String jsondata = await AppPref().getSeasonToken();
        print("@@@@-----------------$jsondata");
        String rawdata = getDecryptedKeyValue(jsondata);
        print("-----------------");
        Map<String, String> headers = <String, String>{
          'Content-type': 'text/plain',
          'Authorization': tokendata,
          'Content-Length': rawdata.toString(), // Add Content-Length
        };
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.loadDashboardData,
          request: headers,
          rawvalue: rawdata,
        );

        if (result.success) {
          Map<String, dynamic> parsedMap =
              json.decode(getDecryptedReturn(result.result));
          //dashboardDataModelResroot.value[0].lines?[0].used=parsedMap['root']['used'];

          // Now, we access the 'Root' key and parse it into a Root object
          dashboradModelResroot = Root.fromJson(parsedMap['Root']);
          print(dashboradModelResroot.free.toString());

          //------------------------------ Drive list ------------------------------------
          if (parsedMap['Drive_list'] != null)
            {
              final drive = (parsedMap['Drive_list'] as List)
                  .map((json) => DashboardDataModelRes.fromJson(json))
                  .toList();
              for (var recentItem in drive) {
                items.add("Drive ${recentItem.name.toString()}");
                print("---->"+recentItem.name.toString());
              }
            }

          //------------------------------ folder check with starred-------------------
          // Parse the 'recent' folders
          if (parsedMap['Folders'] != null &&
              parsedMap['Starred']['Folders'] != null) {
            final folders = (parsedMap['Folders'] as List)
                .map((json) => DashboardDataModelRes.fromJson(json))
                .toList();
            // Parse the 'trashed' folders
            final trashedFolders = (parsedMap['Starred']['Folders'] as List)
                .map((json) => DashboardDataModelRes.fromJson(json))
                .toList();
            // Compare 'recent' folders with 'trashed' folders and update fields
            for (var recentItem in folders) {
              if (trashedFolders.any((trashedItem) =>
                  recentItem.name?.trim() == trashedItem.name?.trim())) {
                final matchedTrashedItem = trashedFolders.firstWhere(
                  (trashedItem) =>
                      recentItem.name?.trim() == trashedItem.name?.trim(),
                );

                recentItem.isstarred = true;
              }
            }
            dashboardDataModelRes.value.addAll(folders);
          }

          ///-------------------------------End------------------------------------------
          if (parsedMap['recent']['Folders'] != null) {
            dashboardDataModelRes.value.addAll(
              (parsedMap['recent']['Folders'] as List)
                  .map((json) => DashboardDataModelRes.fromJson(json))
                  .toList(),
            );
          }
          //------------------------------ File check with starred-------------------
          // Parse the 'recent' folders
          if (parsedMap['Files'] != null &&
              parsedMap['Starred']['Files'] != null) {
            final files = (parsedMap['Files'] as List)
                .map((json) => DashboardDataModelRes.fromJson(json))
                .toList();
            // Parse the 'trashed' folders
            final trashedFiles = (parsedMap['Starred']['Files'] as List)
                .map((json) => DashboardDataModelRes.fromJson(json))
                .toList();
            // Compare 'recent' folders with 'trashed' folders and update fields
            for (var recentItem in files) {
              if (trashedFiles.any((trashedItem) =>
                  recentItem.name?.trim() == trashedItem.name?.trim())) {
                final matchedTrashedItem = trashedFiles.firstWhere(
                  (trashedItem) =>
                      recentItem.name?.trim() == trashedItem.name?.trim(),
                );

                recentItem.isstarred = true;
              }
            }
            dashboardDataModelRes.value.addAll(files);
          }

          ///-------------------------------End------------------------------------------

          if (parsedMap['recent']['Files'] != null) {
            dashboardDataModelRes.value.addAll(
              (parsedMap['recent']['Files'] as List)
                  .map((json) => DashboardDataModelRes.fromJson(json))
                  .toList(),
            );
          }


          print('-->' + dashboardDataModelRes.value.length.toString());
          setState(ViewState.success);
        } else {
          errorMsg = result.message ?? '';
          setState(ViewState.error);
          showCenterFlash(
            message: errorMsg,
            color: red,
            context: Get.context!,
          );
        }
      } catch (ex) {
        errorMsg = ex.toString();
        setState(ViewState.error);
        showCenterFlash(
          message: errorMsg,
          color: red,
          context: Get.context!,
        );
      }
    } else {
      errorMsg = 'No Internet';
      setState(ViewState.error);
      showCenterFlash(
        message: errorMsg,
        color: red,
        context: Get.context!,
      );
    }
  }



  Future<void> getStoragePermission() async {
    if (Platform.isIOS) {
      bool storage = await Permission.storage.status.isGranted;
      if (storage) {
        // Awesome
      } else {
        // Crap
      }
    } else {
      bool storage = true;
      bool videos = true;
      bool photos = true;

      // Only check for storage < Android 13
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        videos = await Permission.videos.status.isGranted;
        photos = await Permission.photos.status.isGranted;
      } else {
        storage = await Permission.storage.status.isGranted;
      }

      if (storage && videos && photos) {
        // Awesome
      } else {
        // Crap
      }
    }
  }

  Future<Uint8List> fetchThumbnail(String? parpath) async {
    print("----------$parpath");

    String path = getEncrypteddata(parpath!);
    String authToken = await AppPref().getSeasonToken();

    try {
      final response = await http.get(
        Uri.parse("${ApiKeys.baseUrl}/${ApiKeys.loadThumbnailData}"),
        headers: {
          'Authorization': authToken,
          'path': path,
        },
      );

      if (response.statusCode == 200) {
        imageBytes = response.bodyBytes; // Binary data from the response
        return imageBytes;

      } else {
        print("Failed to load image: ${response.reasonPhrase}");
      }
    } catch (e) {
      /* setState(() {
        errorMessage = "Error: $e";
      });*/
      print("Failed to load image: ${e}");
    }
    return imageBytes;
  }

  Future<Uint8List> blobToBytesFromFile(String filePath) async {
    File file = File(filePath);
    Uint8List bytes = await file.readAsBytes();
    print(bytes);
    return bytes;
  }

  Future<void> getProtectionApiCall(
      DashboardDataModelRes? itemdata,
      String password,
      BuildContext context,
      DashboardController controller) async {
    setState(ViewState.loadingDashboardData);
    if (await checkNetwork() == 0) {
      try {
        String tokendata = await AppPref().getAccessToken();
        String jsondata = await AppPref().getSeasonToken();
        String rawdata =
            getDecryptedKeyProtectionValue(jsondata, itemdata, password);

        print("-----------------");
        Map<String, String> headers = <String, String>{
          'Content-type': 'text/plain',
          'Authorization': tokendata,
          'Content-Length': rawdata.toString(), // Add Content-Length
        };
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.loadprotecation,
          request: headers,
          rawvalue: rawdata,
        );
        print('----------start-------------------');
        print(result.message);
        print('-----------end------------------');

        if (result.success) {
          Navigator.pop(context);
          setState(ViewState.success);
          controller.getDashboardApiCall();
          var message = "";
          if (itemdata?.password?.isEmpty == true) {
            if (itemdata?.dir == true) {
              var name = itemdata?.name.toString();
              message = 'Folder "$name" is Locked';
            } else {
              var name = itemdata?.name.toString();
              message = 'File "$name" is Locked';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          } else {
            if (itemdata?.dir == true) {
              var name = itemdata?.name.toString();
              message = 'Folder "$name" is unlock';
            } else {
              var name = itemdata?.name.toString();
              message = 'File "$name" is unlock';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        } else {
          errorMsg = result.message ?? '';
          setState(ViewState.error);
          showCenterFlash(
            message: errorMsg,
            color: red,
            context: Get.context!,
          );
        }
      } catch (ex) {
        errorMsg = ex.toString();
        setState(ViewState.error);
        showCenterFlash(
          message: errorMsg,
          color: red,
          context: Get.context!,
        );
      }
    } else {
      errorMsg = 'No Internet';
      setState(ViewState.error);
      showCenterFlash(
        message: errorMsg,
        color: red,
        context: Get.context!,
      );
    }
  }

  /*Future<bool> callPickFiles({required BuildContext context}) async {
    try {
      final ImageSource? source = ImageSource.camera;

      if (source != null) {
        if (source == ImageSource.camera) {
          // Navigate to the CustomCameraScreen and capture images
          final List<File>? capturedImages = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomCameraScreen()),
          );

          // Check if images were captured
          if (capturedImages != null && capturedImages.isNotEmpty) {
            for (File cameraFile in capturedImages) {
              profileAttachments.value.add(ProfileAttachment(
                file: cameraFile,
                fileName: FolderUtils.getFileName(cameraFile.path),
              ));

              await uploadImageApiCall(imgName: cameraFile.path, imgFile: cameraFile);
            }
          }
        } else {
          final ImagePicker picker = ImagePicker();
          final List<XFile>? images = await picker.pickMultiImage(imageQuality: 100);

          if (images != null && images.isNotEmpty) {
            for (XFile image in images) {
              final unit8Bytes = await image.readAsBytes();
              final tempDir = await getTemporaryDirectory();
              final tempFile = File('${tempDir.path}/${image.name}');
              await tempFile.writeAsBytes(unit8Bytes);
              profileAttachments.value.add(ProfileAttachment(
                file: tempFile,
                fileName: FolderUtils.getFileName(tempFile.path),
              ));

              // Upload each selected image
              await uploadImageApiCall(imgName: tempFile.path, imgFile: tempFile);
            }
          } else {
            errorMsg = msgPleaseSelectImage;
            showCenterFlash(
              message: errorMsg,
              color: Colors.red,
              context: Get.context!,
            );
            return false;
          }
        }
      }
    } catch (ex) {
      errorMsg = msgSomethingWentWrong;
      showCenterFlash(
        message: errorMsg,
        color: Colors.red,
        context: Get.context!,
      );
      return false;
    }
    return true; // Return true if images are successfully picked and uploaded
  }*/

  Future<void> uploadImageApiCall({required imgName, required imgFile}) async {
    List<int> certificateInByte = imgFile.readAsBytesSync();
    String certificateInBase64 = base64Encode(certificateInByte);
    setState(ViewState.loading);
    if (await checkNetwork() == 0) {
      try {
        // Call API to upload image
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.uploadImage,
          request: {
            "params": {"image_name": imgName, "image": certificateInBase64}
          },
        );

        if (result.success) {
          successMsg = result.message ?? '';
          setState(ViewState.success);
        } else {
          errorMsg = result.message ?? '';
          showCenterFlash(
            message: errorMsg,
            color: red,
            context: Get.context!,
          );
          setState(ViewState.error);
        }
      } catch (ex) {
        errorMsg = msgSomethingWentWrong;
        setState(ViewState.error);
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
      setState(ViewState.error);
    }
  }

  Future<void> getLogOutAc() async {
    if (viewState.value == ViewState.loading) return;
    setState(ViewState.loading);
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.loggedOut,
          request: {"params": {}},
        );
        if (result.success) {
          successMsg = result.message ?? '';
          await AppPref().logout();
          Get.offAllNamed(
            routeSignIn,
          );
          setState(ViewState.success);
          showCenterFlash(
            message: successMsg,
            color: red,
            context: Get.context!,
          );
        } else {
          errorMsg = result.message ?? '';
          setState(ViewState.error);
          showCenterFlash(
            message: errorMsg,
            color: red,
            context: Get.context!,
          );
        }
      } catch (ex) {
        errorMsg = msgSomethingWentWrong;
        setState(ViewState.error);
        showCenterFlash(
          message: errorMsg,
          color: red,
          context: Get.context!,
        );
      }
    } else {
      errorMsg = msgNoInternet;
      setState(ViewState.error);
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
