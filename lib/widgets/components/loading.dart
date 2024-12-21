

// Define the ProgressBar widget
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/app_colors.dart';


class ProgressBar extends StatelessWidget {
  ProgressBar({
    super.key,
    this.message = '',
    this.isCard = true,
    this.isCurve = false,
    this.color = Colors.transparent,
    this.isOpacity = false,
    this.height,
    this.width,
    this.backgroundColor,
  });

  String message;
  bool isCard;
  Color color;
  bool isOpacity;
  bool isCurve;
  double? height;
  double? width;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SpinKitFadingCube(
                  color: appBlue,
                  size: 40,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
