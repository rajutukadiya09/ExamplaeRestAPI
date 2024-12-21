import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../utils/app_colors.dart';
import '../../utils/constant.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text_label.dart';
import 'Otp_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final OtpController controller = Get.put(OtpController());
  var isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    // Change status bar color to your desired color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: appBlue, // Set the status bar color
      statusBarIconBrightness: Brightness.light, // Set icons to light mode
    ));
    // controller.getDashboardApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray,
      body: getBodyWidget(context: context),
    );
  }

  Widget getBodyWidget({required BuildContext context}) {
    return Stack(
      children: [
        SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 0, right: 0, bottom: 0),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          // Padding around the content
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40,),
                              Image.asset(
                                imgOtp,
                                height: 200,
                                width: 200,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 50,),
                              const CommonText(
                                'Enter the OTP sent to  your Email address',
                                textStyle: TextStyle(
                                    color: color001928,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),

                              const SizedBox(height: 30),
                              // Space between elements
                              // OTP Input Fields
                              OTPTextField(
                                length: 6,
                                // Number of OTP digits
                                width: MediaQuery.of(context).size.width,
                                // Full screen width
                                fieldWidth:
                                    MediaQuery.of(context).size.width / 8,
                                // Dynamically adjust individual field width
                                style: const TextStyle(fontSize: 17),
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.box,
                                onChanged: (pin) {
                                  // Called when the OTP input changes
                                  print("Changed: $pin");
                                },
                                onCompleted: (pin) {
                                  // Called when the OTP input is complete
                                  print("Completed: $pin");
                                },
                              ),
                              const SizedBox(height: 50),
                              // Verify OTP Button
                              PrimaryButton(
                                label: 'Sumbit',
                                textStyles: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
