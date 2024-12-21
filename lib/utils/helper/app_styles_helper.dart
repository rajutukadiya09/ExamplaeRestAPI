
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';

class AppStyle {
  TextStyle appBarHeaderTextStyle() {
    return GoogleFonts.roboto(
        fontSize: 18.sp, fontWeight: FontWeight.w500, color: appBlue);
  }

  TextStyle listSubTitleStyle() {
    return GoogleFonts.roboto(
        fontSize: 12.sp, fontWeight: FontWeight.normal, color: Colors.grey);
  }

  TextStyle black17W500() {
    return GoogleFonts.roboto(
      fontSize: 17.sp,
      fontWeight: FontWeight.w500,
      color: appBlue,
    );
  }

  TextStyle buttonText() {
    return GoogleFonts.roboto(
        color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400);
  }

  TextStyle listTitleStyle() {
    return GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.w500);
  }

  TextStyle grey11W400() {
    return GoogleFonts.roboto(
        color: Colors.grey, fontSize: 11.sp, fontWeight: FontWeight.w400);
  }

  TextStyle grey12W400() {
    return GoogleFonts.roboto(
        color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w400);
  }

  TextStyle grey12normal() {
    return GoogleFonts.roboto(
        color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.normal);
  }

  TextStyle black12W500() {
    return GoogleFonts.roboto(
        color: appBlue, fontSize: 12.sp, fontWeight: FontWeight.w500);
  }

  TextStyle black15W500() {
    return GoogleFonts.roboto(
        color: appBlue, fontSize: 15.sp, fontWeight: FontWeight.w500);
  }

  TextStyle black12Normal() {
    return GoogleFonts.roboto(
        color: appBlue, fontSize: 12.sp, fontWeight: FontWeight.normal);
  }

  TextStyle black14Normal() {
    return GoogleFonts.roboto(
        color: appBlue, fontSize: 12.sp, fontWeight: FontWeight.normal);
  }

  TextStyle black16() {
    return GoogleFonts.roboto(color: appBlue, fontSize: 16.sp);
  }

  TextStyle black18() {
    return GoogleFonts.roboto(color: appBlue, fontSize: 18.sp);
  }

  TextStyle black14() {
    return GoogleFonts.roboto(color: appBlue, fontSize: 14.sp);
  }

  TextStyle black54Normal() {
    return GoogleFonts.roboto(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    );
  }

  TextStyle black16W500() {
    return GoogleFonts.roboto(
        color: appBlue, fontSize: 16.sp, fontWeight: FontWeight.w500);
  }

  TextStyle black14W400() {
    return GoogleFonts.roboto(
        color: appBlue, fontSize: 14.sp, fontWeight: FontWeight.w400);
  }

  TextStyle black12W400() {
    return GoogleFonts.roboto(
        color: appBlue, fontSize: 12.sp, fontWeight: FontWeight.w400);
  }

  TextStyle black20W500() {
    return GoogleFonts.roboto(
        color: appBlue, fontSize: 20.sp, fontWeight: FontWeight.w500);
  }

  TextStyle black20W600() {
    return GoogleFonts.roboto(
        color: appBlue, fontSize: 20.sp, fontWeight: FontWeight.w600);
  }

  TextStyle white16W600() {
    return GoogleFonts.roboto(
        color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600);
  }

  TextStyle white14W500() {
    return GoogleFonts.roboto(
        color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500);
  }

  TextStyle white12W500() {
    return GoogleFonts.roboto(
        color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500);
  }
}
