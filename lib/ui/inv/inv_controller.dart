import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


import '../../network/api/base_repository.dart';
import '../../network/model/dispatch_server_action_model.dart';
import '../../network/model/result_model.dart';
import '../../network/model/tow_drivers_model.dart';
import '../../network/model/tow_service_method_model.dart';
import '../../network/model/tow_vehicles_model.dart';
import '../../network/model/towing_account_model.dart';
import '../../network/model/towing_type_model.dart';
import '../../network/model/upload_img_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_pref.dart';
import '../../utils/constant.dart';
import '../../utils/folder_utils.dart';
import '../../utils/utility.dart';
import '../../widgets/custom_camera.dart';

/*
enum ViewState {
  initial,
  loading,
  uploadImgLoading,
  error,
  success,
}

class InvController extends GetxController
    with GetSingleTickerProviderStateMixin {
  String errorMsg = '';
  String successMsg = '';
  BaseRepository baseRepository = BaseRepository();
  final Rx<ViewState> viewState = ViewState.initial.obs;
  final List<ViewState> historyViewState = <ViewState>[];
  var isLoading = false.obs;
  late TabController tabController;
  int? selectedIndex;

  List<String> tabs = ['Vehicle', 'Auth', 'Tow', 'Release', 'Impound'];

  //Vehicle Tab
  Rx<TextEditingController> licensePlateCtn = TextEditingController().obs;
  Rx<TextEditingController> dispatchInstPlateCtn = TextEditingController().obs;
  Rx<TextEditingController> modelCtn = TextEditingController().obs;
  Rx<TextEditingController> makeCtn = TextEditingController().obs;
  Rx<TextEditingController> vinCtn = TextEditingController().obs;
  Rx<TextEditingController> yearCtn = TextEditingController().obs;
  Rx<TextEditingController> colorCtn = TextEditingController().obs;
  Rx<List<TowingTypeModel>> towingTypes = Rx<List<TowingTypeModel>>([]);

  Rx<List<DispatchServerActionModel>> towServerAction = Rx<List<DispatchServerActionModel>>([]);
  RxBool isServerActionListVisible = false.obs;
  DispatchServerActionModel? selectedServerAction;
  Rx<List<ProfileAttachment>> profileAttachments =
      Rx<List<ProfileAttachment>>([]);
  Rx<List<TowAccountFetchModel>> towAccounts =
      Rx<List<TowAccountFetchModel>>([]);
  TowAccountFetchModel? selectedTowAccount;
  TowingTypeModel? selectedTowingType;
  UploadImgModel? uploadImgModel;

  //Auth Tab
  Rx<TextEditingController> authorizingTimeCtn = TextEditingController().obs;
  Rx<TextEditingController> signerTitleCtn = TextEditingController().obs;
  Rx<TextEditingController> signerNumberCtn = TextEditingController().obs;
  Rx<TextEditingController> signerAddressCtn = TextEditingController().obs;

  final RxString authorizingTime = ''.obs;
  RxString savedSignature = ''.obs;
  RxString savedSignatureBase64 = ''.obs;

  HandSignatureControl signatureControl = HandSignatureControl();
  var assetAttachment = Rx<File?>(null); // Reactive file variable
  var assetAttachmentName = RxString(''); // Reactive file name variable
  String? savedSignaturePath;
  var authDocFiles = Rx<List<File>>([]); // Reactive file variable
  var authDocName = RxString(''); // Reactive file name variable

  //Tow Tab

  Rx<List<TowDriversModel>> towDrivers = Rx<List<TowDriversModel>>([]);
  TowDriversModel? selectedTowDriver;
  Rx<List<TowVehiclesModel>> towVehicles = Rx<List<TowVehiclesModel>>([]);
  TowVehiclesModel? selectedTowVehicle;
  Rx<List<TowVehicleClassModel>> towVehiclesClass =
      Rx<List<TowVehicleClassModel>>([]);
  TowVehicleClassModel? selectedTowVehicleClass;
  Rx<List<TowFacilitiesFetchModel>> fetchFacilities =
      Rx<List<TowFacilitiesFetchModel>>([]);
  TowFacilitiesFetchModel? selectedFacilities;
  Rx<List<TowServicesModel>> towServices = Rx<List<TowServicesModel>>([]);
  TowServicesModel? selectedTowServices;
  Rx<List<TowMethodModel>> fetchTowMethod = Rx<List<TowMethodModel>>([]);
  TowMethodModel? selectedTowMethod;

  Rx<List<String>> lockOutMethods =
      Rx<List<String>>(["Brake", "VIN", "Steering Wheel", "Gear"]);
  String? selectedLockOutMethod;

  var selectedValueForEnteredVehicle = ''.obs;
  var selectedValueForVehicleLocked = ''.obs;

  static Future<bool> pickFiles({
    required BuildContext context,
    required Rx<List<File>> assetAttachment, // Reactive file variable to update
    required RxString
        assetAttachmentName, // Reactive file name variable to update
    required Rx<ViewState> viewState, // Reactive view state to update
  }) async {
    try {
      // Open file picker to select any file
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        assetAttachment.value = result.files
            .map(
              (e) => File(e.xFile.path),
            )
            .toList(); // Update the reactive file variable
        // assetAttachmentName.value =
        //     FolderUtils.getFileName(file.path); // Update the file name
        viewState.value = ViewState.success; // Set success state
        return true;
      } else {
        // No file selected, handle the error
        viewState.value = ViewState.error; // Set error state
        _showErrorFlash(context: context, message: "Select File");
        return false;
      }
    } catch (ex) {
      // Catch any error during file picking
      viewState.value = ViewState.error; // Set error state
      _showErrorFlash(context: context, message: msgSomethingWentWrong);
      return false;
    }
  }

  Future<List<String>?> convertFileToBase64(List<File> files) async {
    final List<String> base64Strings = [];
    await Future.forEach<File>(files, (file) async {
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes); //
      base64Strings.add(base64String);
    });

    return base64Strings;
  }

  /// Private helper method to show error messages
  static void _showErrorFlash(
      {required BuildContext context, required String message}) {
    showCenterFlash(
      message: message,
      color: red,
      context: context,
    );

  }

  Future<void> saveSignature() async {
    savedSignature.value = ''; // Clear old value before saving a new signature
    savedSignatureBase64.value = ''; // Clear old base64 value

    // Capture signature as image data
    final ByteData? imageData = await signatureControl.toImage(
      color: Colors.red,
      background: Colors.white,
      fit: true,
    );

    if (imageData != null) {
      // Save the signature as a file
      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);

     // await file.writeAsBytes(imageData.buffer.asUint8List());
      await file.writeAsBytes(imageData.buffer.asUint8List());

      // Update the ValueNotifier with the file path
      savedSignature.value = filePath;

      // Convert image data to Uint8List
      final Uint8List imageBytes = imageData.buffer.asUint8List();

      // Encode Uint8List to base64 string
      savedSignatureBase64.value = base64Encode(imageBytes);
    }
  }

  Future<void> getTowAccountsApiCall() async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.towFetchAccount,
          request: {"params": {}},
        );

        if (result.success) {
          towAccounts.value.clear();
          towAccounts.value = List<TowAccountFetchModel>.from(
            (result.result['data'] as List<dynamic>).map(
              (x) => TowAccountFetchModel.fromJson(x as Map<String, dynamic>),
            ),
          );
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
        errorMsg = ex.toString();
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

  Future<void> getTowDriversApiCall() async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.towDriversFetch,
          request: {"params": {}},
        );
        if (result.success) {
          towDrivers.value.clear();
          // Access 'data' from the result
          towDrivers.value = List<TowDriversModel>.from(
            (result.result['data'] as List<dynamic>).map(
              (x) => TowDriversModel.fromJson(x as Map<String, dynamic>),
            ),
          );
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
        errorMsg = ex.toString();
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

  Future<void> getTowVehiclesApiCall() async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.towVehicleFetch,
          request: {"params": {}},
        );
        if (result.success) {
          towVehicles.value.clear();
          // Access 'data' from the result
          towVehicles.value = List<TowVehiclesModel>.from(
            (result.result['data'] as List<dynamic>).map(
              (x) => TowVehiclesModel.fromJson(x as Map<String, dynamic>),
            ),
          );
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
        errorMsg = ex.toString();
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

  Future<void> getTowFacilitiesApiCall() async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.towFacilitiesFetch,
          request: {"params": {}},
        );
        if (result.success) {
          fetchFacilities.value.clear();
          // Access 'data' from the result
          fetchFacilities.value = List<TowFacilitiesFetchModel>.from(
            (result.result['data'] as List<dynamic>).map(
              (x) =>
                  TowFacilitiesFetchModel.fromJson(x as Map<String, dynamic>),
            ),
          );
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
        errorMsg = ex.toString();
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

  Future<void> getTowServicesApiCall() async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.towingServicesFetch,
          request: {"params": {}},
        );
        if (result.success) {
          towServices.value.clear();
          towServices.value = List<TowServicesModel>.from(
            (result.result['data'] as List<dynamic>).map(
              (x) => TowServicesModel.fromJson(x as Map<String, dynamic>),
            ),
          );
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
        errorMsg = ex.toString();
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

  Future<void> getTowMethodApiCall() async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.towMethodsFetch,
          request: {"params": {}},
        );
        if (result.success) {
          fetchTowMethod.value.clear();
          // Access 'data' from the result
          fetchTowMethod.value = List<TowMethodModel>.from(
            (result.result['data'] as List<dynamic>).map(
              (x) => TowMethodModel.fromJson(x as Map<String, dynamic>),
            ),
          );
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
        errorMsg = ex.toString();
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

  Future<void> getTowingTypesApiCall() async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.towFetchTowingType,
          request: {"params": {}},
        );

        if (result.success) {
          towingTypes.value.clear();
          // Access 'data' from the result
          towingTypes.value = List<TowingTypeModel>.from(
            (result.result as List<dynamic>).map(
              (x) => TowingTypeModel.fromJson(x as Map<String, dynamic>),
            ),
          );
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
        errorMsg = ex.toString();
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

  Future<void> getTowingServerAction() async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.towDispatchServerAction,
          request: {"params": {}},
        );

        if (result.success) {
          print("DATA FEEL SUCESFULLLY");
          towServerAction.value.clear();
          towServerAction.value = List<DispatchServerActionModel>.from(
            (result.result as List<dynamic>).map(
                  (x) => DispatchServerActionModel.fromJson(x as Map<String, dynamic>),
            ),
          );
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
        errorMsg = ex.toString();
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

  Future<void> getTowVehicleClassApiCall() async {
    if (await checkNetwork() == 0) {
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.towVehicleClassFetch,
          request: {"params": {}},
        );

        if (result.success) {
          towVehiclesClass.value.clear();
          // Access 'data' from the result
          towVehiclesClass.value = List<TowVehicleClassModel>.from(
            (result.result as List<dynamic>).map(
              (x) => TowVehicleClassModel.fromJson(x as Map<String, dynamic>),
            ),
          );
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
        errorMsg = ex.toString();
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

  Future<bool> callPickFiles({required BuildContext context}) async {
    try {
      final ImageSource? source = ImageSource.camera;
      // await showDialog(
      //   context: context,
      //   barrierDismissible: true,
      //   builder: (BuildContext context) {
      //     return Dialog(
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(10),
      //       ),
      //       child: Container(
      //         padding: const EdgeInsets.symmetric(vertical: 16),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: <Widget>[
      //             InkWell(
      //               onTap: () {
      //                 Get.back(result: ImageSource.camera);
      //               },
      //               child: Container(
      //                 padding: const EdgeInsets.symmetric(horizontal: 16),
      //                 height: 50,
      //                 alignment: Alignment.centerLeft,
      //                 child: Row(
      //                   children: <Widget>[
      //                     Icon(Icons.camera_alt, color: Colors.blue),
      //                     SizedBox(width: 10),
      //                     Text("Camera", style: TextStyle(color: Colors.blue)),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             SizedBox(height: 10),
      //             InkWell(
      //               onTap: () {
      //                 Get.back(result: ImageSource.gallery);
      //               },
      //               child: Container(
      //                 padding: const EdgeInsets.symmetric(horizontal: 16),
      //                 height: 50,
      //                 alignment: Alignment.centerLeft,
      //                 child: Row(
      //                   children: <Widget>[
      //                     Icon(Icons.photo, color: Colors.blue),
      //                     SizedBox(width: 10),
      //                     Text("Gallery", style: TextStyle(color: Colors.blue)),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // );

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
              // Trigger UI update
              update([invPhotos]);
            }
          }
        } else {
          final ImagePicker picker = ImagePicker();
          final List<XFile>? images =
              await picker.pickMultiImage(imageQuality: 100);

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
              update([invPhotos]);
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
    return false;
  }

  Future<bool> callPickSignature({required BuildContext context}) async {
    try {
      // Open file picker to select any file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        assetAttachment.value = file;
        assetAttachmentName.value = FolderUtils.getFileName(file.path);
        viewState.value = ViewState.success;
        return true;
      } else {
        errorMsg = "Select File";
        viewState.value = ViewState.error; // Update state
        showCenterFlash(
          message: errorMsg,
          color: red,
          context: context,
        );
        return false;
      }
    } catch (ex) {
      errorMsg = msgSomethingWentWrong;
      viewState.value = ViewState.error; // Update state
      showCenterFlash(
        message: errorMsg,
        color: red,
        context: context,
      );
      return false;
    }
  }

  Future<void> uploadImageApiCall({required imgName, required imgFile}) async {
    List<int> certificateInByte = imgFile.readAsBytesSync();
    String certificateInBase64 = base64Encode(certificateInByte);
    setState(ViewState.uploadImgLoading);
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
          uploadImgModel = UploadImgModel.fromJson(result.result);
          int attachmentId = uploadImgModel?.attachmentId ?? 0;

          if (attachmentId != 0) {
            await AppPref().storeAttachmentId(attachmentId);
          }
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

  Future<void> uploadImagesAndCreateRecord() async {
    try {
      for (ProfileAttachment attachment in profileAttachments.value) {
        await uploadImageApiCall(
          imgName: attachment.fileName,
          imgFile: attachment.file,
        );
      }
      await createRecordApiCall();
    } catch (e) {
      // Handle any errors that occur during the upload or record creation process
      print("Error uploading images or creating record: $e");
    }
  }

  Future<void> createRecordApiCall() async {
    List<int> towPhotosAttachmentIds = await AppPref().getStoredAttachmentIds();
    if (viewState.value == ViewState.loading) return;
    setState(ViewState.loading);
    if (await checkNetwork() == 0) {
      var base64DataAuthDoc = await convertFileToBase64(authDocFiles.value);
      try {
        ResultModel result = await baseRepository.baseRepositoryApiCall(
          apiEndPoint: ApiKeys.createRecord,
          request: {
            "params": {
              "license_plate": licensePlateCtn.value.text,
              "model": modelCtn.value.text,
              "make": makeCtn.value.text,
              "vin": vinCtn.value.text,
              "year": yearCtn.value.text,
              "tow_photos": towPhotosAttachmentIds,
              "account_id": selectedTowAccount?.id,
              "type": selectedTowingType?.type,
              "dispatch_notes": dispatchInstPlateCtn.value.text,
              "license_plate": licensePlateCtn.value.text,
              "model": modelCtn.value.text,
              "make": makeCtn.value.text,
              "vin": vinCtn.value.text,
              "signer_signature": savedSignatureBase64.value,
              "signing_date": authorizingTime.value,
              "signer_title": signerTitleCtn.value.text,
              "signer_phone": signerNumberCtn.value.text,
              "signer_address": signerAddressCtn.value.text,
              "authorizing_attachments": base64DataAuthDoc,
              "driver_id": selectedTowDriver?.id,
              "truck_id": selectedTowVehicle?.id,
              "vehicle_class": selectedTowVehicleClass?.type,
              "service_ids": selectedTowServices?.id,
              "tow_method_ids": selectedTowMethod?.id,
              "facility_id": selectedFacilities?.id,
              "entered_vehicle": selectedValueForEnteredVehicle.value,
              "vehicle_locked": selectedValueForVehicleLocked.value.toString(),
              "vehicle_lock_method": selectedLockOutMethod.toString(),
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
          setState(ViewState.success);
          Get.back();
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
        showCenterFlash(
          message: errorMsg,
          color: red,
          context: Get.context!,
        );
        setState(ViewState.error);
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

  void setState(ViewState state) {
    viewState.value = state;
    historyViewState.add(state);
  }
}

class ProfileAttachment {
  final File file;
  final String fileName;

  ProfileAttachment({required this.file, required this.fileName});
}
*/
