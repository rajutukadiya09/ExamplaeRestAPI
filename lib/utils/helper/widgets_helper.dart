import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


import '../app_colors.dart';
import '../constant.dart';
import 'app_styles_helper.dart';


enum MediaOption { camera, gallery }

class WidgetsHelper {
  // Private constructor to prevent instantiation from outside
  WidgetsHelper._();

  // WidgetsHelper instance
  static final WidgetsHelper _instance = WidgetsHelper._();

  // Factory method to provide access to the instance
  factory WidgetsHelper() => _instance;

  InputDecoration buildInputDecoration(
      {String labelText = "",
      bool? alignLabelWithHint,
      bool? selectedColor,
      hintText}) {
    return InputDecoration(
      alignLabelWithHint: alignLabelWithHint ?? false,
      contentPadding: EdgeInsets.fromLTRB(16.w, 10.h, 10.w, 10.h),
      counterText: '',
      hintText: hintText,
      errorStyle: AppStyle()
          .black12Normal()
          .copyWith(color: Colors.red, fontSize: 10.sp),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(textFieldCornerRadius.r)),
      errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(textFieldCornerRadius.r)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: black),
          borderRadius: BorderRadius.circular(textFieldCornerRadius.r)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: black),
          borderRadius: BorderRadius.circular(textFieldCornerRadius.r)),
      disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: black),
          borderRadius: BorderRadius.circular(textFieldCornerRadius.r)),
      label: Text(
        labelText,
        style: AppStyle().black16().copyWith(
              fontSize: 14.sp,
              color:
                  selectedColor == true ? appBlue : black,
            ),
      ),
    );
  }

  InputDecoration buildInputDecorationWithCounter(
      {String strLabel = "",
      bool? alignLabelWithHint,
      bool? selectedColor,
      hintText}) {
    return InputDecoration(
      alignLabelWithHint: alignLabelWithHint ?? false,
      contentPadding: EdgeInsets.fromLTRB(16.w, 10.h, 10.w, 10.h),
      hintText: hintText,
      errorStyle: AppStyle()
          .black12Normal()
          .copyWith(color: Colors.red, fontSize: 10.sp),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(textFieldCornerRadius.r)),
      errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(textFieldCornerRadius.r)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: black),
          borderRadius: BorderRadius.circular(textFieldCornerRadius.r)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: black),
          borderRadius: BorderRadius.circular(textFieldCornerRadius.r)),
      disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: black),
          borderRadius: BorderRadius.circular(textFieldCornerRadius.r)),
      label: Text(
        strLabel,
        style: AppStyle().black16().copyWith(
              fontSize: 14.sp,
              color:
                  selectedColor == true ? appBlue : black,
            ),
      ),
    );
  }

  Widget buildSvgDownArrow() {
    return SvgPicture.asset(
      'assets/ic_small_down_arrow.svg',
      colorFilter:
          const ColorFilter.mode(black, BlendMode.srcIn),
    );
  }

  Widget buildDivider({
    double? horizontalPadding,
    Color? customColor,
    double? customThickness,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding?.w ?? 0),
      child: Divider(
        thickness: customThickness ?? 1,
        color: customColor ?? black,
      ),
    );
  }

  Widget buildSvgAddressBook() {
    return SvgPicture.asset(
      'assets/ic_address_book.svg',
      colorFilter:
          const ColorFilter.mode(black, BlendMode.srcIn),
    );
  }

  //Box decoration for text field suffix
  BoxDecoration buildTextFieldSuffix() {
    return BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(textFieldCornerRadius),
          bottomRight: Radius.circular(textFieldCornerRadius),
        ),
        color: black.withOpacity(0.2));
  }

  void snackBar(String type, String message) async {
    Get.snackbar(type, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: type == 'error' ? Colors.red : Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white));
  }

  void showSuccessToast(String title, String message) async {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  Widget emptyListWidget(
      {String? title, String? description, double? paddingHori}) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHori ?? 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset(
                "assets/ic_no_data.svg",
                height: Get.width / 3,
                width: Get.width / 3,
              ),
              Text(
                title?.isNotEmpty == true ? title! : 'No data found',
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.poppins(color: Colors.black, fontSize: 15.sp),
              ),
              Text(
                description?.isNotEmpty == true ? description! : '',
                textAlign: TextAlign.center,
                style:
                    GoogleFonts.poppins(color: Colors.black, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileBadgeWidget(String activityType,
      {double? height, double? width}) {
    double mHeight = height ?? 40.0.h;
    double mWidth = width ?? 40.0.h;
    return Visibility(
      visible: activityType.isNotEmpty,
      child: SvgPicture.asset(
        'assets/ic_badge_$activityType.svg',
        height: mHeight,
        width: mWidth,
      ),
    );
  }

  void showAlertDialog(
    String title,
    String msg,
    Function(bool) callBack, {
    bool isCancel = false,
    bool isSuccess = false,
    String strCancel = "Cancel",
    String strSuccess = "Ok",
  }) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        elevation: 0,
        title: Text(
          title,
          style:
              GoogleFonts.roboto(fontSize: 22.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          msg,
          style: GoogleFonts.roboto(fontSize: 18.sp),
        ),
        actionsPadding: EdgeInsets.all(16 / 2.sp),
        actions: [
          // The "Login" button
          Visibility(
            visible: isCancel,
            child: TextButton(
              onPressed: () {
                // callBack(false);
                Get.back();
              },
              child: Text(
                strCancel,
                style: GoogleFonts.roboto(fontSize: 16.sp),
              ),
            ),
          ),
          Visibility(
            visible: isSuccess,
            child: TextButton(
              onPressed: () {
                callBack(true);
                Get.back();
              },
              child: Text(
                strSuccess,
                style: GoogleFonts.roboto(fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationBadge(int notificationCount) {
    // Display '99+' if notificationCount is greater than 100
    String badgeText = (notificationCount >= 10) ? '9+' : '$notificationCount';

    return Positioned(
      right: 5,
      top: 0,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: appBlue,
          shape: BoxShape.circle,
        ),
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        child: Center(
          child: Text(
            badgeText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: black, width: 1.0),
    );
  }

  AppBar buildCommonAppBar({
    required String title,
    Widget? leadingIcon,
    bool? centreTitle = false,
    List<Widget>? appBarActions,
  }) {
    leadingIcon ??= IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        color: appBlue,
      ),
      onPressed: () {
        Get.back();
      },
    );

    return AppBar(
      titleSpacing: 0,
      elevation: 0,
      backgroundColor: appBlue,
      surfaceTintColor: white,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0.0,
      title: Text(
        title,
        style: AppStyle().appBarHeaderTextStyle(),
      ),
      centerTitle: centreTitle,
      leading: leadingIcon,
      actions: appBarActions,
    );
  }

  Widget buildIconTextRow(String iconPath, String text) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          height: 10.0.h,
          colorFilter: const ColorFilter.mode(
            appBlue,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 12.0.sp,
              fontWeight: FontWeight.normal,
              color: appBlue,
            ),
          ),
        ),
      ],
    );
  }

  Row buildIconWithText({
    String text = '',
    IconData icon = Icons.add,
    Color textColor = Colors.black,
    Color iconColor = Colors.black,
    TextStyle? textStyle,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: REdgeInsets.only(right: 3.0),
          child: Icon(
            icon,
            color: iconColor,
            size: 16,
          ),
        ),
        Text(
          text,
          style: textStyle ??
              AppStyle().listSubTitleStyle().copyWith(color: textColor),
        ),
        const SizedBox(
          width: 5,
        )
      ],
    );
  }
}
