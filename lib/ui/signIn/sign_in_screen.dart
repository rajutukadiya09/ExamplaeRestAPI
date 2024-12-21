import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointycastle/paddings/pkcs7.dart';
import 'package:pointycastle/paddings/pkcs7.dart';
import '../../utils/app_colors.dart';
import '../../utils/constant.dart';
import '../../utils/utility.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text_label.dart';
import '../../widgets/common_textfield.dart';
import 'sign_in_controller.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController controller = Get.find();

  var signInFormKey = GlobalKey<FormState>();

  var isLoading = false.obs;


  @override
  void initState() {
    super.initState();
   // controller.getDBListApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlue,
      appBar: PreferredSize(
        preferredSize: const Size(0, 0),
        child: AppBar(
          surfaceTintColor: appBlue,
          backgroundColor: appBlue,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
              top: -100,
              left: 0,
              child: Image.asset(
                imgMaskImage,
                width: Get.width,
                fit: BoxFit.fitWidth,
              )),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: CommonText(
                  'Nimo Drive',
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 28),
                ),
              ),
              const SizedBox(height: 60),
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: Get.height - 235),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                          color: colorFCFCFC,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      width: Get.width,
                      height: Get.height / 1.32,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 45),
                            child: Align(
                                alignment: Alignment.center,
                                child: CommonText(
                                  'Login',
                                  textStyle: TextStyle(
                                      color: color001928,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 28),
                                )),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 32, bottom: 4),
                            child: CommonText('Email/Username',
                                textStyle: TextStyle(
                                    color: color001928,
                                    fontWeight: FontWeight.w500)),
                          ),
                          CustomTextField(
                            controller: controller.userNameController,
                            height: 45,
                            hintText: 'Your email/username',
                            hintTextStyle: const TextStyle(
                                color: color969696, fontSize: 14),
                            prefixIcon: const Icon(
                              Icons.email, // Material Design email icon
                              size: 20.0,   // Optional: Adjust the size
                              color: appBlue, // Optional: Adjust the color
                            ),
                          ),

                          // password field
                          const Padding(
                            padding: EdgeInsets.only(top: 25, bottom: 4),
                            child: CommonText('Password',
                                textStyle: TextStyle(
                                    color: color001928,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Obx(() {
                            return CustomTextField(
                                obscureText: controller.obSecureText.value,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      controller.obSecureText.value =
                                          !controller.obSecureText.value;
                                    },
                                    child: Icon(controller.obSecureText.value
                                        ? CupertinoIcons.eye_slash_fill
                                        : CupertinoIcons.eye)),
                                controller: controller.pswController,
                                height: 45,
                                hintText: 'Password',
                                hintTextStyle: const TextStyle(
                                    color: color969696, fontSize: 14),
                                prefixIcon: const Padding(
                                  padding:
                                      EdgeInsets.only(left: 5, right: 6),
                                  child: Icon(
                                    Icons.password, // Material Design email icon
                                    size: 20.0,   // Optional: Adjust the size
                                    color: appBlue, // Optional: Adjust the color
                                  ),
                                ));
                          }),

                          //Login Button
                          Padding(
                            padding: const EdgeInsets.only(top: 36),
                            child: PrimaryButton(
                              label: 'Login',
                              textStyles: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                              onTap: () {
                                if (controller
                                        .userNameController.text.isEmpty ||
                                    controller.pswController.text.isEmpty) {
                                  if (controller
                                      .userNameController.text.isEmpty) {
                                    showCenterFlash(
                                      message:
                                          'Please enter your email/username',
                                      color: red,
                                      context: Get.context!,
                                    );
                                  } else if (controller
                                      .pswController.text.isEmpty) {
                                    showCenterFlash(
                                      message: 'Please enter your password',
                                      color: red,
                                      context: Get.context!,
                                    );
                                  }
                                } else {
                                 controller.loginApiCall(
                                      email:  getEncrypteddata(controller.userNameController.text),
                                      password: getEncrypteddata(controller.pswController.text));



                                }
                              },
                            ),
                          ),
                        /*  const Padding(
                            padding: EdgeInsets.only(top: 36),
                            child: Align(
                                alignment: Alignment.center,
                                child: CommonText('Forgot your password?')),
                          )*/
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
