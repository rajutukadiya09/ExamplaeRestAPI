import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nimodrive/network/model/dashboard_data_model.dart';

import '../routes/routes.dart';
import '../widgets/common_text_label.dart';
import '../widgets/components/spacings.dart';
import '../widgets/components/unauthorize_dialog.dart';
import 'app_colors.dart';
import 'app_pref.dart';
import 'constant.dart';

// Check network connectivity by attempting to resolve 'example.com'
// Returns 0 if connected, 1 otherwise
Future<int> checkNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      showLog('connected');
      return 0;
    } else {
      return 1;
    }
  } on SocketException catch (err) {
    showLog('Internet is not connected. SocketException: $err');
    return 1;
  }
}

// Log messages for debugging
void showLog(String value, {String key = 'Result: '}) {
  Logger().d('$key$value');
}

// Clear user login session
Future<void> clearLoginSession() async {
  await AppPref().logout();
}

// Show a dialog indicating unauthorized access
Future<void> unAuthorizedDialog({required BuildContext context}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const UnAuthorizeDialog();
    },
  );
}

// Display a flash message in the center of the screen
void showCenterFlash({
  required String message,
  FlashBehavior style = FlashBehavior.floating,
  required Color color,
  bool isIcon = false,
  int duration = 2,
  GlobalKey? key,
  required BuildContext context,
}) {
  showFlash(
    context: context,
    duration: Duration(seconds: duration),
    builder: (BuildContext _, FlashController<dynamic> controller) {
      return Flash<dynamic>(
        controller: controller,
        position: FlashPosition.top,
        child: SafeArea(
          child: Wrap(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(Spacings.large / 2),
                ),
                padding: const EdgeInsets.all(Spacings.medium),
                margin: const EdgeInsets.all(Spacings.medium),
                child: Row(
                  children: <Widget>[
                    if (isIcon)
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.warning,
                          color: white,
                          size: 18,
                        ),
                      ),
                    Expanded(
                      child: CommonText(
                        message,
                        maxLines: 3,
                        textStyle:  const TextStyle(
                          fontSize: 12,
                          color: white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

String getEncrypteddata( String data)
{
  // Key and IV
  final key = encrypt.Key.fromUtf8(constant_key);  // 16 characters for AES-128
  final iv = encrypt.IV.fromUtf8(constant_iv);    // 16-byte Initialization Vector (IV)

  // Create an encrypter instance with AES algorithm (default uses PKCS7 padding)
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  // Data to encrypt
  final plainText = data;

  // Encrypt the data
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  // Output the encrypted base64 string
  print('Encrypted: ${encrypted.base64}');

  // Convert base64 encrypted string back to Encrypted object for decryption
  final encryptedText = encrypted.base64;
  final encryptedFromBase64 = encrypt.Encrypted.fromBase64(encryptedText);

  // Decrypt the data
  final decrypted = encrypter.decrypt(encryptedFromBase64, iv: iv);

  // Print the decrypted text
  print('Decrypted: $decrypted');
  return encrypted.base64;
}
String convertBase64( String data)
{
  // Convert to Base64
  String base64String = base64Encode(utf8.encode(data));
  return base64String;
}
void getDecrypted( String data)
{
  // Key and IV
  final key = encrypt.Key.fromUtf8(constant_key);  // 16 characters for AES-128
  final iv = encrypt.IV.fromUtf8(constant_iv);    // 16-byte Initialization Vector (IV)

  // Create an encrypter instance with AES algorithm (default uses PKCS7 padding)
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));


  // Convert base64 encrypted string back to Encrypted object for decryption
  final encryptedText = data;
  final encryptedFromBase64 = encrypt.Encrypted.fromBase64(encryptedText);

  // Decrypt the data
  final decrypted = encrypter.decrypt(encryptedFromBase64, iv: iv);

  // Print the decrypted text
  print('Decrypted: $decrypted');

}
String getDecryptedReturn( String data)
{
  // Key and IV
  final key = encrypt.Key.fromUtf8(constant_key);  // 16 characters for AES-128
  final iv = encrypt.IV.fromUtf8(constant_iv);    // 16-byte Initialization Vector (IV)

  // Create an encrypter instance with AES algorithm (default uses PKCS7 padding)
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));


  // Convert base64 encrypted string back to Encrypted object for decryption
  final encryptedText = data;
  final encryptedFromBase64 = encrypt.Encrypted.fromBase64(encryptedText);

  // Decrypt the data
  final decrypted = encrypter.decrypt(encryptedFromBase64, iv: iv);

  // Print the decrypted text
  print('Decrypted: $decrypted');
  return decrypted;

}

String getDecryptedKeyValue(String data)
{
  // Key and IV
  final key = encrypt.Key.fromUtf8(constant_key);  // 16 characters for AES-128
  final iv = encrypt.IV.fromUtf8(constant_iv);    // 16-byte Initialization Vector (IV)

  // Create an encrypter instance with AES algorithm (default uses PKCS7 padding)
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));


  // Convert base64 encrypted string back to Encrypted object for decryption
  final encryptedText = data;
  final encryptedFromBase64 = encrypt.Encrypted.fromBase64(encryptedText);

  // Decrypt the data
  final decrypted = encrypter.decrypt(encryptedFromBase64, iv: iv);

  // Print the decrypted text
  print('Decrypted: $decrypted');

  Map<String, dynamic> jsonObject = jsonDecode(decrypted);

  // Access values
  String keyalue = jsonObject['userid'];

  //print value
  print('userid: $keyalue');

  getEncrypteddata(keyalue);
  getEncrypteddata("/Drive");
 var dataa= Routes.getCurrentPath();
  print('--------------$dataa-----------------');
  Map<String, dynamic> jsonObjectt = {
    "path":Routes.getCurrentPath(),
    "ui": keyalue,
  };
  print('-------------------------------');
  String jsonString = jsonEncode(jsonObjectt);
  print(jsonString);
  print('-------------------------------');
  getEncrypteddata(jsonString);
  print('-------------------------------');
  return getEncrypteddata(jsonString);
}


/*
String getDecryptedKeybase64(String data)
{
  // Key and IV
  final key = encrypt.Key.fromUtf8(constant_key);  // 16 characters for AES-128
  final iv = encrypt.IV.fromUtf8(constant_iv);    // 16-byte Initialization Vector (IV)

  // Create an encrypter instance with AES algorithm (default uses PKCS7 padding)
  final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));


  // Convert base64 encrypted string back to Encrypted object for decryption
  final encryptedText = data;
  final encryptedFromBase64 = encrypt.Encrypted.fromBase64(encryptedText);


  return encryptedFromBase64;
}
*/

String getDecryptedKeyProtectionValue(
    String data, DashboardDataModelRes? itemdata, String password) {
  // Key and IV
  final key = encrypt.Key.fromUtf8(constant_key); // 16 characters for AES-128
  final iv =
      encrypt.IV.fromUtf8(constant_iv); // 16-byte Initialization Vector (IV)

  // Create an encrypter instance with AES algorithm (default uses PKCS7 padding)
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  // Convert base64 encrypted string back to Encrypted object for decryption
  final encryptedText = data;
  final encryptedFromBase64 = encrypt.Encrypted.fromBase64(encryptedText);

  // Decrypt the data
  final decrypted = encrypter.decrypt(encryptedFromBase64, iv: iv);

  // Print the decrypted text
  print('Decrypted: $decrypted');

  Map<String, dynamic> jsonObject = jsonDecode(decrypted);

  // Access values
  String keyalue = jsonObject['userid'];

  //print value
  print('userid: $keyalue');

  getEncrypteddata(keyalue);
  getEncrypteddata("/Drive");
  Map<String, dynamic> jsonObjectItem = {};

  if (itemdata?.dir == true) {
    jsonObjectItem = {
      "name": itemdata?.name?.toString(),
      "path": itemdata?.path?.toString(),
      "par_path": itemdata?.par_path?.toString(),
      "fileSize": itemdata?.fileSize,
      "aTime": itemdata?.aTime,
      "cTime": itemdata?.cTime,
      "dir": itemdata?.dir,
      "color": "black",
      "icon": "",
      "password": itemdata?.password?.isNotEmpty == true ?"": password  ,
      "mTime": itemdata?.mTime,
      "time": DateTime.now().millisecondsSinceEpoch
    };
  } else {
    jsonObjectItem = {
      "name": itemdata?.name?.toString(),
      "path": itemdata?.path?.toString(),
      "par_path": itemdata?.par_path?.toString(),
      "fileSize": itemdata?.fileSize,
      "aTime": itemdata?.aTime,
      "cTime": itemdata?.cTime,
      "dir": itemdata?.dir,
      "password": itemdata?.password?.isNotEmpty == true ?"": password  ,
      "mTime": itemdata?.mTime,
      "time": DateTime.now().millisecondsSinceEpoch
    };
  }

  print('-------------------------------');
  String jsonString = jsonEncode(jsonObjectItem);
  print('------------@@@@@-------------------');
  print(jsonString);
  // Decode jsonString to remove escapes
  Map<String, dynamic> dataObject = jsonDecode(jsonString);
  Map<String, dynamic> jsonObjectmain = {
    "data": dataObject,
    "ui": keyalue,
  };
  print('------------@@@@@-------------------');
  print(jsonObjectmain);
  String jsonStringg = jsonEncode(jsonObjectmain);
  print('dasta $jsonStringg');
  print('-------------------------------');
  getEncrypteddata(jsonStringg);
  print('-------------------------------');
  getEncrypteddata(jsonStringg);
  return getEncrypteddata(jsonStringg);
}
enum FileDashboardType { file, folder, zip, json, image, xl, pdf, mp4 }

class FileUtils {
  static String getIconForFileType(FileDashboardType type) {
    switch (type) {
      case FileDashboardType.image:
        return imgjpg;
      case FileDashboardType.folder:
        return imgFolder;
      case FileDashboardType.zip:
        return imgZip;
      case FileDashboardType.xl:
        return imgxl;
      case FileDashboardType.pdf:
        return imgpdf;
      case FileDashboardType.json:
        return imgJson;
      case FileDashboardType.mp4:
        return imgmp4;
      default:
        return imgJson;
    }
  }

  static String getStringFileType(
    bool dir,
    String name,
  ) {
    if (dir == false) {
      if (["jpg", "jpeg", "png", "gif"]
              .contains(name.split('.').last.toLowerCase()) ==
          true) {
//FileUtils.getIconForFileType(FileDashboardType.image)
        return "jpg";
      } else if (["zip"].contains(name.split('.').last.toLowerCase()) == true) {
        return FileUtils.getIconForFileType(FileDashboardType.zip);
      } else if (["json"].contains(name.split('.').last.toLowerCase()) ==
          true) {
        return FileUtils.getIconForFileType(FileDashboardType.json);
      }else if (["xlsx"].contains(name.split('.').last.toLowerCase()) ==
          true) {
        return FileUtils.getIconForFileType(FileDashboardType.xl);
      }else if (["pdf","Pdf"].contains(name.split('.').last.toLowerCase()) ==
          true) {
        return FileUtils.getIconForFileType(FileDashboardType.pdf);
      }else if (["mp4"].contains(name.split('.').last.toLowerCase()) ==
          true) {
        return FileUtils.getIconForFileType(FileDashboardType.mp4);
      }else {
        return FileUtils.getIconForFileType(FileDashboardType.file);
      }
    } else {
      return FileUtils.getIconForFileType(FileDashboardType.folder);
    }

  }
}
