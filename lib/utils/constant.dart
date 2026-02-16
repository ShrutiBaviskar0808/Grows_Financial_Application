import 'package:flutter/material.dart';

const String noInternet = "Check Your Internet Connection..";
const String serviceFailure = "service Failure..";
const String tryAgain = "Try Again Later";
const String noData = "Error While getting Data..";

const String baseUrl = "https://portal.growsfinancial.ca/";
// const String baseUrl = "http://192.168.1.5/growsportal/";
const String apiUrl = "${baseUrl}api/";
const String imageUrl = "${baseUrl}assets/";

const String appVersion = "1.0.0";

const primaryColor = Color(0xff002D4B);
const primaryColorLight = Color(0xFF2D5A78);
const secondaryColor = Color(0xffFB4404);
const backgroundColor = Color(0xffE5EAED);
const cardColor = Color(0xffFFEBCD);
const textColor = Color(0xff333333);
const grey2 = Color(0xFFA7A6B4);

const TextStyle titleTextStyle = TextStyle(
  color: textColor,
  fontWeight: semiBoldFont,
  fontSize: 14,
);
TextStyle subTitleTextStyle = TextStyle(
  color: textColor,
  // fontSize: 8,
  fontWeight: regularFont,
);

const FontWeight regularFont = FontWeight.w400; //: Regular weight text.
const FontWeight mediumFont = FontWeight.w500; //: Medium weight text.
const FontWeight semiBoldFont = FontWeight.w600; //: Semi Bold weight text.
const FontWeight boldFont = FontWeight.bold; //: Bold weight text.
