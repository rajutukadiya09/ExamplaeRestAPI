import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

import '../network/model/api_response_model.dart';
import '../network/model/file_model.dart';
import 'api_constant.dart';
import 'utility.dart';

class FolderUtils {
  // Maximum size for a picked file (5MB)
  static const double maxPickedFileSize = 5000000;

  /// Retrieves the directory for file operations based on the platform.
  /// For iOS, it returns the application documents directory if permission is granted.
  /// For Android, it returns the download directory if the API level is lower than 33.
  /// Otherwise, it returns the download directory without requiring explicit permission.
  static Future<Directory?> getLocalDirectory() async {
    if (Platform.isIOS) {
      if (await Permission.storage.request().isGranted) {
        return await getApplicationDocumentsDirectory();
      } else {
        openAppSettings();
        return null;
      }
    } else {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if (info.version.sdkInt < 33) {
        if (await Permission.storage.request().isGranted) {
          return Directory('/storage/emulated/0/Download');
        } else {
          openAppSettings();
          return null;
        }
      } else {
        return Directory('/storage/emulated/0/Download');
      }
    }
  }

  /// Checks if a file exists in the local directory.
  static Future<bool> isFileExists(String fileName) async {
    if (fileName.isNotEmpty) {
      final Directory? dir = await getLocalDirectory();
      if (dir != null) {
        final File file = File('${dir.path}/$fileName');
        return await file.exists();
      }
    }
    return false;
  }

  /// Retrieves a file object from the local directory based on the file name.
  static Future<File?> getFile(String fileName) async {
    final Directory? dir = await getLocalDirectory();
    if (dir != null) {
      return File('${dir.path}/$fileName');
    }
    return null;
  }

  /// Extracts the file name from the file path.
  static String getFileName(String filePath) {
    return filePath.split('/').last;
  }

  /// Captures an image using the camera and compresses it.
  /// Returns a list containing the compressed image file.
  static Future<List<File>> captureAndCompressImages() async {
    final List<File> images = [];
    if (await Permission.camera.request().isGranted) {
      final XFile? imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 30,
      );
      if (imageFile != null) {
        final File compressedFile = await _compressImage(File(imageFile.path));
        images.add(compressedFile);
      }
    } else {
      openAppSettings();
    }
    return images;
  }

  /// Allows the user to select multiple images from the gallery and compresses them.
  /// Returns a list containing the compressed image files.
/*  static Future<List<File>> selectAndCompressImages() async {
    final List<File> images = [];
    if (await Permission.storage.isGranted) {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );
      if (result != null) {
        for (PlatformFile file in result.files) {
          if (file.path != null) {
            final File compressedFile = await _compressImage(File(file.path!));
            images.add(compressedFile);
          }
        }
      }
    } else {
      openAppSettings();
    }
    return images;
  }*/

  /// Captures a single image using the camera.
  static Future<XFile?> captureImage() async {
    return await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
  }

  /// Allows the user to select a file of specific types (JPEG, JPG, PNG, PDF) and compresses it.
  /// Returns the compressed file.
/*  static Future<File?> selectFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: [
          ApiKeys.formatJPEG,
          ApiKeys.formatJPG,
          ApiKeys.formatPNG,
          ApiKeys.formatPDF,
        ],
        type: FileType.custom,
        withData: true,
      );
      if (result != null) {
        final PlatformFile file = result.files.first;
        if (file.path != null) {
          final File targetFile = File(file.path!);
          final File compressedFile = await _compressImage(targetFile);
          return compressedFile;
        }
      }
    } catch (e) {
      showLog('Error selecting file: $e');
    }
    return null;
  }*/

  /// Allows the user to select a PDF file and returns it.
/*  static Future<File?> selectPDF() async {
    try {
      if (await Permission.storage.isGranted) {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowedExtensions: [ApiKeys.formatPDF],
          type: FileType.custom,
          withData: true,
        );
        if (result != null) {
          final PlatformFile file = result.files.first;
          if (file.path != null &&
              getFileExtension(file.path!) == ApiKeys.formatPDF) {
            final Directory dir = await getTemporaryDirectory();
            final File targetFile = File('${dir.path}/${file.name}');
            if (file.bytes != null) {
              await targetFile.writeAsBytes(file.bytes!);
              return targetFile;
            }
          }
        }
      } else {
        openAppSettings();
      }
    } catch (e) {
      showLog('Error selecting PDF: $e');
    }
    return null;
  }*/

  /// Compresses the given image file and returns the compressed file.
  /// If compression is not successful or the compressed file is larger than the original, the original file is returned.
  static Future<File> _compressImage(File file) async {
    final int originalSize = file.lengthSync();
    final Uint8List? result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 75,
    );
    if (result != null) {
      final Directory outputDir = await getTemporaryDirectory();
      final File compressedFile = File(
        '${outputDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.${getFileExtension(file.path)}',
      );
      await compressedFile.writeAsBytes(result);
      return compressedFile.lengthSync() > originalSize ? file : compressedFile;
    }
    return file;
  }

  /// Converts a list of image files to a single PDF document.
  /// Returns the PDF file.
  static Future<File?> convertImagesToPdf(List<FileModel> files) async {
    try {
      final pw.Document pdf = pw.Document();
      for (FileModel fileModel in files) {
        if (fileModel.isImage) {
          final File compressedFile = await _compressImage(fileModel.file);
          final pw.MemoryImage image = pw.MemoryImage(
            compressedFile.readAsBytesSync(),
          );
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Center(
                  child: pw.Image(image),
                );
              },
            ),
          );
        }
      }
      final Directory outputDir = await getTemporaryDirectory();
      final File pdfFile = File('${outputDir.path}/output.pdf');
      await pdfFile.writeAsBytes(await pdf.save());
      return pdfFile;
    } catch (e) {
      showLog('Error converting images to PDF: $e');
      return null;
    }
  }

  /// Gets the file extension from the file path.
  static String getFileExtension(String filePath) {
    return filePath.split('.').last;
  }

  /// Downloads a file from the specified URL and saves it to the local directory.
  /// Returns an ApiResponseModel indicating the success or failure of the operation.
  static Future<ApiResponseModel> downloadFile({
    required String url,
    required String fileName,
  }) async {
    try {
      final Response response = await Dio().get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            showLog('${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
      final Directory? directory = await getLocalDirectory();
      if (directory != null) {
        final File file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.data);
        return ApiResponseModel(success: true, apiResponse: file);
      } else {
        return ApiResponseModel(
            success: false, error: 'Please allow file permission!');
      }
    } catch (e) {
      return ApiResponseModel(success: false, error: e.toString());
    }
  }
}
