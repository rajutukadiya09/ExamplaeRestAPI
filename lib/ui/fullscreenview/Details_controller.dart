import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../network/api/base_repository.dart';
import '../../utils/api_constant.dart';
import '../../utils/app_pref.dart';
import '../../utils/utility.dart';

enum ViewState {
  initial,
  loading,
  uploadImgLoading,
  error,
  success,
}

class DetailsController extends GetxController {
  var isLoading = false.obs;

  final Rx<ViewState> viewState = ViewState.initial.obs;
  final List<ViewState> historyViewState = <ViewState>[];
  BaseRepository baseRepository = BaseRepository();

  Future<Uint8List>? fetchThumbnail(String? parpath) async {
    try {
      String path = getEncrypteddata(parpath!);
      String authToken = await AppPref().getSeasonToken();

      final response = await http.get(
        Uri.parse("${ApiKeys.baseUrl}/${ApiKeys.loadThumbnailData}"),
        headers: {
          'Authorization': authToken,
          'path': path,
        },
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // Returns Future<Uint8List>
      } else {
        print("Failed to load image: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Failed to load image: $e");
    }
    return Uint8List(0);
  }
  Future<Uint8List>? fetchPDF(String? parpath) async {
    try {
      String path = getEncrypteddata(parpath!);
      String authToken = await AppPref().getSeasonToken();
      final response = await http.get(
        Uri.parse("${ApiKeys.baseUrl}/${ApiKeys.donwloadFile}/${path}"),
        headers: {
          'Authorization': authToken,
        },
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // Returns Future<Uint8List>
      } else {
        print("Failed to load image: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Failed to load image: $e");
    }
    return Uint8List(0);
  }
  /*Future<Uint8List>? downloadFile(String? parpath, String? filename) async {
    try {

      Map<String, dynamic> headers = <String, dynamic>{
        'loc': parpath,
        'UI': "mohit",
        'exp':DateTime.now().millisecondsSinceEpoch,
      };
      String jsonString = json.encode(headers);
      print("jsonString ---> ${jsonString}");
      String path = getEncrypteddata(jsonString);
      String pathBase64 = convertBase64(path);
      print("pathBase64 --->${pathBase64}");
      String authToken = await AppPref().getSeasonToken();

      final response = await http.get(
        Uri.parse("${ApiKeys.baseUrl}/${ApiKeys.donwloadStreamFile}/${pathBase64}"),
        headers: {
          'Authorization': authToken,
        },
      );
      print("------------------->${response.statusCode}");
      PermissionStatus status = await Permission.manageExternalStorage.request();
      if (response.statusCode == 200) {
        if (status.isGranted) {
          final directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          final filePath = '${directory.path}/${filename}';
          File file = File(filePath);
          try {
            await file.writeAsBytes(response.bodyBytes);
            print("File written to: $filePath");
          } catch (e) {
            print("Error writing file: $e");
          }
        } else {
          print("Permission denied.");
        }
        return response.bodyBytes;
      } else {
        print("Failed to load image: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Failed to load image: $e");
    }
    return Uint8List(0);
  }*/



  Future<Directory?> getAppSpecificDownloads() async {
    return await getExternalStorageDirectory(); // Returns app-specific external storage.
  }
  Future<Uint8List>? downloadFile(String? parpath, String? filename) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Initialize the notification plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    try {
      Map<String, dynamic> headers = <String, dynamic>{
        'loc': parpath,
        'UI': "mohit",
        'exp': DateTime.now().millisecondsSinceEpoch,
      };
      String jsonString = json.encode(headers);
      print("jsonString ---> $jsonString");
      String path = getEncrypteddata(jsonString);
      String pathBase64 = convertBase64(path);
      print("pathBase64 ---> $pathBase64");
      String authToken = await AppPref().getSeasonToken();

      final response = await http.get(
        Uri.parse("${ApiKeys.baseUrl}/${ApiKeys.donwloadStreamFile}/${pathBase64}"),
        headers: {
          'Authorization': authToken,
        },
      );

      if (response.statusCode == 200) {
        PermissionStatus status = await Permission.manageExternalStorage.request();
        if (status.isGranted) {
          final directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          final filePath = '${directory.path}/$filename';
          File file = File(filePath);

          final bytes = response.bodyBytes;
          final int totalBytes = bytes.length;
          int bytesWritten = 0;

          const chunkSize = 1024 * 64; // 64 KB chunks
          for (int i = 0; i < totalBytes; i += chunkSize) {
            final end = (i + chunkSize > totalBytes) ? totalBytes : i + chunkSize;
            await file.writeAsBytes(bytes.sublist(i, end), mode: FileMode.append);
            bytesWritten += (end - i);

            // Update notification progress
            final progress = ((bytesWritten / totalBytes) * 100).round();
            final androidPlatformChannelSpecifics = AndroidNotificationDetails(
              'download_channel',
              'File Download',
              channelDescription: 'Shows progress while downloading files',
              importance: Importance.max,
              priority: Priority.high,
              onlyAlertOnce: true,
              showProgress: true,
              maxProgress: 100,
              progress: progress,
            );
            final platformChannelSpecifics = NotificationDetails(
              android: androidPlatformChannelSpecifics,
            );
            await flutterLocalNotificationsPlugin.show(
              0,
              'Downloading $filename',
              'Progress: $progress%',
              platformChannelSpecifics,
            );
          }

          print("File written to: $filePath");
          await triggerMediaScanner(filePath);
        } else {
          print("Permission denied.");
        }
        return response.bodyBytes;
      } else {
        print("Failed to download file: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Failed to download file: $e");
    }

    // Remove the notification after completion
    await flutterLocalNotificationsPlugin.cancel(0);

    return Uint8List(0);
  }

   final MethodChannel _mediaScannerChannel = const MethodChannel('media_scanner_channel');

  Future<void> triggerMediaScanner(String filePath) async {
    try {
      await _mediaScannerChannel.invokeMethod('triggerMediaScanner', {'filePath': filePath});
    } catch (e) {
      print('Error triggering Media Scanner: $e');
    }
  }

  Future<void> checkAndRequestPermissions() async {
    // Check if the permission is granted
    PermissionStatus status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      // Request permission
      status = await Permission.manageExternalStorage.request();
    }

    if (status.isGranted) {
      print("Permission granted");
      // You can now access the external storage
    } else {
      print("Permission denied");
      // Show a message or handle the denial
    }
  }

  Future<void> requestPermissions() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        // Permission already granted
        print("Manage External Storage permission granted");
      } else {
        // Request for Manage External Storage permission
        status = await Permission.manageExternalStorage.request();
        if (status.isGranted) {
          print("Manage External Storage permission granted");
        } else {
          print("Permission denied");
        }
      }
    }

    // Request storage permission (for devices below Android 10)
    if (await Permission.storage.isGranted) {
      print("Storage permission granted");
    } else {
      status = await Permission.storage.request();
      if (status.isGranted) {
        print("Storage permission granted");
      } else {
        print("Storage permission denied");
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  void setState(ViewState state) {
    viewState.value = state;
    historyViewState.add(state);
  }
}
