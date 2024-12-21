import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/constant.dart';
import 'splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
   controller.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlue,
      body: GetBuilder(
        init: controller,
        builder: (value) {
          return Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    imgMainNimoSplash,
                    fit: BoxFit.contain,
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0), // Adjust bottom padding
                    child: Text(
                      'Nimo Drive',
                      style: TextStyle(
                        color: Colors.white, // Adjust text color
                        fontSize: 16.0, // Adjust font size
                        fontWeight: FontWeight.bold, // Adjust font weight
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

/* Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlue,
      body: GetBuilder(
        init: controller,
        builder: (value) {
          return  Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(imgMainNimoSplash,
                      fit: BoxFit.fitHeight),
                ),
              ],
            ),
          );;
        },
      ),
    );
  }*/
}
