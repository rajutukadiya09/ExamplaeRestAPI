import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'common_text_label.dart';

/// A custom container widget that displays an image and text side by side.
class CustomContainer extends StatelessWidget {
  /// Creates an instance of [CustomContainer].
  const CustomContainer({
    super.key,
    required this.imageString, // Path to the image asset
    required this.text, // Text to display alongside the image
    this.width = 155.0, // Width of the container
    this.height = 60.0, // Height of the container
    this.borderRadius = 12.0, // Radius for the container's corners
    this.elevation = 4.0, // Elevation for the shadow effect
    this.fontColor = black, // Color for the text
    this.imgHeight = 25, // Height of the image
    this.imgWidth = 22, // Width of the image
  });

  final String imageString; // Path to the image asset
  final String text; // Text to display
  final double width; // Width of the container
  final double height; // Height of the container
  final double imgHeight; // Height of the image
  final double imgWidth; // Width of the image
  final double borderRadius; // Radius for the container's corners
  final double elevation; // Elevation for the shadow effect
  final Color fontColor; // Color for the text

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Set the width of the container
      height: height, // Set the height of the container
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius), // Apply rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            spreadRadius: 1, // Spread radius of the shadow
            blurRadius: elevation, // Blur radius of the shadow
            offset: const Offset(0, 3), // Offset position of the shadow
          ),
        ],
        color: white, // Background color of the container
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center align items horizontally
        crossAxisAlignment: CrossAxisAlignment.center, // Center align items vertically
        children: [
          Image.asset(
            alignment: Alignment.center, // Align image in the center
            imageString, // Path to the image asset
            width: imgWidth, // Set the width of the image
            height: imgHeight, // Set the height of the image
            fit: BoxFit.contain, // Fit image within its container while maintaining aspect ratio
          ),
          const SizedBox(width: 14), // Add space between the image and text
          CommonText(
            text, // Text to display
            textStyle: const TextStyle(
              fontSize: 15, // Font size for the text
              fontWeight: FontWeight.w500, // Font weight for the text
              color: black, // Color of the text
            ),
          ),
        ],
      ),
    );
  }
}
