import 'dart:io';

/// A model class representing a file and its type (image or not)
class FileModel {
  /// The file being represented
  File file;

  /// A flag to indicate if the file is an image
  bool isImage;

  /// Constructor for creating a FileModel object
  FileModel({
    required this.file,
    required this.isImage,
  });
}
