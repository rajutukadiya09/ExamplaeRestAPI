import 'dart:async'; // Import to use Timer
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../utils/app_colors.dart';
import 'common_text_label.dart';


class CustomCameraScreen extends StatefulWidget {
  @override
  _CustomCameraScreenState createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<CustomCameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];
  List<File> capturedImages = [];
  int selectedCameraIndex = 0;
  bool _switchValue = true;

  RxString liveDateTime = ''.obs;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startDateTimeTimer(); // Start the timer
  }

  void _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  void _startDateTimeTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      String formattedDateTime = DateFormat('HH:mm:ss').format(DateTime.now());
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String dayOfWeek = _getDayOfWeek(DateTime.now().weekday);

      liveDateTime.value = '$formattedDate / $formattedDateTime\n$dayOfWeek';
    });
  }

  void _switchCamera() {
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    _initializeCamera();
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      print('Camera is not initialized.');
      return;
    }

    try {
      final XFile image = await _cameraController!.takePicture();
      File capturedImage = File(image.path);

      // Overlay date and time if switch is on
      if (_switchValue) {
        capturedImage = await _overlayDateTime(capturedImage);
      }

      setState(() {
        capturedImages.add(capturedImage);
      });
    } catch (e) {
      print('Error capturing photo: $e');
    }
  }

  Future<File> _overlayDateTime(File image) async {
    // Load the image as bytes
    final Uint8List imageBytes = await image.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image bitmap = frameInfo.image;

    // Create a new image with the same size
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromPoints(
        Offset(0, 0),
        Offset(bitmap.width.toDouble(), bitmap.height.toDouble())
    ));

    // Draw the original image onto the canvas
    canvas.drawImage(bitmap, Offset.zero, Paint());

    // Prepare the date and time text
    String overlayText = liveDateTime.value.isNotEmpty
        ? liveDateTime.value
        : 'No Date'; // Fallback if RxString is empty

    // Create a text painter for the overlay
    final textPainter = TextPainter(
      text: TextSpan(
        text: overlayText,
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout(); // Layout the text

    // Define text offset position
    double textX = bitmap.width - textPainter.width - 10; // 10 pixels from the right
    double textY = bitmap.height - textPainter.height - 10; // 10 pixels from the bottom

    // Draw the text on the canvas
    textPainter.paint(canvas, Offset(textX, textY));

    // End the recording and create a new image
    final ui.Image img = await recorder.endRecording().toImage(bitmap.width, bitmap.height);
    final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    // Ensure byteData is not null
    if (byteData == null) {
      throw Exception('Failed to get byte data from the image.');
    }

    // Convert the byte data to Uint8List
    final Uint8List pngBytes = byteData.buffer.asUint8List();

    // Save the new image with text
    final newImagePath = '${image.path}_with_overlay.png'; // Updated path to avoid overwriting
    final newImage = File(newImagePath);

    // Use async write for better performance and error handling
    await newImage.writeAsBytes(pngBytes);

    return newImage;
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }

  void _removePhoto(int index) {
    setState(() {
      capturedImages.removeAt(index);
    });
  }

  void _savePhotos() {
    Navigator.pop(context, capturedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: black,
          height: 105,
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 70,
          ),
          InkWell(
            onTap: _capturePhoto,
            child: Icon(Icons.camera, color: Colors.blue, size: 60),
          ),
          GestureDetector(
            onTap: _savePhotos,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      )),
      appBar: AppBar(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.calendar_badge_plus, color: Colors.green, size: 40),
              Text(
                _switchValue ? 'On' : 'Off',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: white),
              ),
              SizedBox(width: 10),
              CupertinoSwitch(
                value: _switchValue,
                onChanged: (bool value) {
                  setState(() {
                    _switchValue = value;
                  });
                },
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.flip_camera_ios, color: Colors.green, size: 30),
            onPressed: _switchCamera,
          ),
        ],
      ),
      backgroundColor: Colors.black26,
      body: Stack(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
          Container(
            alignment: Alignment.center,
                color: black,
                child: CameraPreview(_cameraController!)),
          Positioned(
            bottom: 0,
            left: 12,
            right: 12,
            child: Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: capturedImages.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullscreenImageScreen(
                              imageFile: capturedImages[index],
                            ),
                          ),
                        );
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                          child: Image.file(
                            capturedImages[index],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 3,
                          child: InkWell(
                            onTap: () => _removePhoto(index),
                            child: Icon(Icons.cancel_sharp, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (_switchValue)
            Positioned(
              bottom: 100,
              right: 18,
              child: Obx(() => CommonText(
                liveDateTime.value,
                textStyle: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
              )),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    timer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }
}

class FullscreenImageScreen extends StatelessWidget {
  final File imageFile;

  FullscreenImageScreen({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    // Get the image name from the file
    String imageName = imageFile.path.split('/').last; // Extracting the filename

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(imageName, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Close the fullscreen view
          },
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the fullscreen view
          },
          child: Image.file(
            imageFile,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

