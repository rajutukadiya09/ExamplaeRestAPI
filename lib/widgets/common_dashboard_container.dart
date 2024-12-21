import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'common_text_label.dart';

/// A customizable container widget for a dashboard item.
/// Displays an image in a circular background and a label below it.
class DashboardContainer extends StatelessWidget {
  /// Creates an instance of [DashboardContainer].
  const DashboardContainer({
    super.key,
    required this.imagePath, // Path to the image asset
    required this.label, // Text to display below the image
    required this.color, // Background color of the container
    required this.circleBgColor, // Background color of the circular avatar
    required this.onContainerTap, // Callback function when the container is tapped
  });

  final String imagePath; // Path to the image asset
  final String label; // Text to display
  final Color color; // Background color of the container
  final Color circleBgColor; // Background color of the circular avatar
  final VoidCallback onContainerTap; // Callback function for tap action

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6, // Elevation for the shadow effect
      borderRadius: BorderRadius.circular(15), // Border radius for the shadow
      child: InkWell(
        onTap: onContainerTap, // Executes the callback when tapped
        borderRadius: BorderRadius.circular(15), // Ensures ripple effect follows border
        child: Container(
          decoration: BoxDecoration(
            color: color, // Background color of the container
            borderRadius: BorderRadius.circular(8), // Rounded corners for the container
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center align children vertically
            children: [
              CircleAvatar(
                radius: 16, // Radius of the circular avatar
                backgroundColor: circleBgColor, // Background color of the avatar
                child: Image.network(imagePath), // Displays the image inside the avatar
              ),
              const SizedBox(height: 12), // Space between image and text
              CommonText(
                label, // Text to display
                textStyle: const TextStyle(
                  fontSize: 14, // Font size for the text
                  fontWeight: FontWeight.w600, // Font weight for the text
                  color: color001928, // Color of the text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}