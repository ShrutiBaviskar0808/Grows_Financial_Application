import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class Config {
  Future<bool> setStringSharedPreferences(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(key, value);
  }

  Future<String> getStringSharedPreferences(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? "";
  }

  Future<bool> setIntSharedPreferences(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt(key, value);
  }

  Future<int> getIntSharedPreferences(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key) ?? 0;
  }

  Future<bool> setBooleanSharedPreferences(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(key, value);
  }

  Future<bool> getBooleanSharedPreferences(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) ?? false;
  }

  void showToastFailure(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void showToastSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  String formatTime(String dateString) {
    // Convert the UTC time to local time
    String utcDateTimeString = "${dateString}Z";

    DateTime utcDateTime = DateTime.parse(utcDateTimeString);
    DateTime localTime = utcDateTime.toLocal();
    String formattedTime = DateFormat('h:mm a').format(localTime);
    // Append the timezone abbreviation
    String timezoneAbbreviation = localTime.timeZoneName;
    return '$formattedTime $timezoneAbbreviation';
  }

  String convertDate(String date) {
    final dt = DateFormat("yyyy-MM-dd HH:mm:ss").parseUtc(date).toLocal();
    final now = DateTime.now();

    final diff = now.difference(dt); // past time

    // Future safety (if API sends future time)
    if (diff.isNegative) {
      return "just now";
    }

    // Older than 7 days → show date
    if (diff.inDays >= 7) {
      return DateFormat("d MMM").format(dt); // 12 Jan
    }

    // Days ago
    if (diff.inDays >= 1) {
      return '${diff.inDays} d ago';
    }

    // Hours ago
    if (diff.inHours >= 1) {
      return '${diff.inHours} h ago';
    }

    // Minutes ago
    if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} m ago';
    }

    // Seconds ago
    return '${diff.inSeconds} sec ago';
  }

  String convertDateToString(String date) {
    var newDateTimeObj2 = DateFormat("yyyy-MM-dd").parse(date, true).toLocal();
    return DateFormat("MM-dd-yyyy").format(newDateTimeObj2);
  }

  String convertTime(String date) {
    var newDateTimeObj2 =
        DateFormat("yyyy-MM-dd HH:mm:ssZ").parse(date, true).toLocal();
    String formattedTime = DateFormat('hh:mm a').format(newDateTimeObj2);
    String timeZone = newDateTimeObj2.timeZoneName;
    return '$formattedTime $timeZone';
  }

  String calculateTimeDifferenceBetween({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final difference = endDate.difference(startDate);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} second${difference.inSeconds == 1 ? '' : 's'}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    } else {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    }
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  String generateOrderNumber() {
    DateTime now = DateTime.now();
    Random random = Random();
    int randomDigits =
        random.nextInt(900) +
        100; // Generates a random number between 100 and 999

    String formattedDate = now.toString().replaceAll(RegExp(r'[-: .]'), '');
    return '$formattedDate$randomDigits';
  }

  String generateRandomString(int length) {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  List<DropdownMenuItem<T>> buildDropDownMenuItems<T>(
    List listItems, {
    String valueKey = 'value',
    String labelKey = 'text',
  }) {
    return listItems.map<DropdownMenuItem<T>>((item) {
      // If item is a String (or primitive), use as both value and label
      if (item is String || item is num) {
        return DropdownMenuItem<T>(
          value: item as T,
          child: Text(item.toString()),
        );
      }
      // If item is a Map or Object
      if (item is Map) {
        return DropdownMenuItem<T>(
          value: item[valueKey] as T,
          child: Text(item[labelKey]?.toString() ?? ''),
        );
      }
      // Fallback (for custom types)
      return DropdownMenuItem<T>(
        value: item as T,
        child: Text(item.toString()),
      );
    }).toList();
  }

  Future<DateTime> pickDate(BuildContext context, DateTime pickedDate) async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
      initialDate: pickedDate,
    );
    return date!;
  }

  Future<TimeOfDay> pickTime(BuildContext context, TimeOfDay time) async {
    TimeOfDay? t = await showTimePicker(context: context, initialTime: time);
    return t!;
  }

  //Mask Phone Number
  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 3) {
      return phoneNumber; // Not enough characters to mask
    }

    // Get the first and last characters
    String firstChar = phoneNumber[0];
    String lastChar = phoneNumber[phoneNumber.length - 1];

    // Replace middle characters with asterisks
    String middleMasked = '*' * (phoneNumber.length - 2);

    // Combine the parts
    return '$firstChar$middleMasked$lastChar';
  }

  //ItemCount

  int getItemCount(int length) {
    return length > 3 ? length - 1 : length;
  }

  // Progress indicator widget to show loading.
  Widget loadingView() => const Center(
    child: SizedBox(
      height: 50,
      width: 50,
      child: LoadingIndicator(
        indicatorType: Indicator.ballZigZagDeflect,
        colors: [primaryColor],
      ),
    ),
  );

  // View to empty data message
  Widget noDataView({String msg = "", Color color = textColor}) => Center(
    child: Text(
      msg,
      style: titleTextStyle.copyWith(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  Widget retryView(
    String msg,
    GestureTapCallback onTap,
    BuildContext context,
  ) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      noDataView(msg: msg),
      const SizedBox(height: 10.0),
      CustomTextButton(
        title: 'Retry',
        onTap: onTap,
        color: primaryColor,
        borderRadius: 10.0,
        height: 40,
        width: (MediaQuery.of(context).size.width) / 3,
        textStyle: const TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        splashColor: Colors.white,
        borderColor: Colors.black,
      ),
    ],
  );

  void infoDialog(BuildContext context, String content, Function onTap) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text("Information"),
          content: Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("Okay"),
              onPressed: () {
                onTap();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  void showCustomDialog(BuildContext context, Widget content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 0.0,
          child: content,
        );
      },
    );
  }

  void logoutDialog(BuildContext context, GestureTapCallback onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text("Are you sure you want to logout ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              onPressed: () {
                Get.back();
                onPressed();
              },
              child: const Text("Yes"),
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  void imageChoiceDialog(
    BuildContext context,
    Function openGallery,
    Function openCamera,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Select Image Source",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // usually buttons at the bottom of the dialog
                InkWell(
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(FontAwesomeIcons.photoFilm, size: 36),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    openGallery();
                    Get.back();
                  },
                ),
                const SizedBox(height: 30),
                InkWell(
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(FontAwesomeIcons.camera, size: 36),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    openCamera();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void exitAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Are you sure you want to exit ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(onPressed: () => exitApp(), child: Text('Yes')),
            ],
          ),
    );
  }

  void showCustomBottomSheet(
    BuildContext context,
    Widget content,
    double height,
  ) {
    // flutter defined function
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return FractionallySizedBox(
          heightFactor: height, // Sets the height to 80% of the screen height
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: SingleChildScrollView(child: content),
          ),
        );
      },
    );
  }

  Future<bool> checkConnection() async {
    ConnectivityResult connectivityResult =
        (await (Connectivity().checkConnectivity())).single;
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<bool> isPermissionGranted() async {
    bool storagePermission = await Permission.storage.status.isDenied;
    bool cameraPermission = await Permission.camera.status.isDenied;
    bool notificationPermission = await Permission.notification.status.isDenied;
    if (storagePermission || cameraPermission || notificationPermission) {
      requestPermission();
      return false;
    } else {
      return true;
    }
  }

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await [
        Permission.camera,
        Permission.photos,
        Permission.notification,
      ].request();
    } else {
      await [
        Permission.storage,
        Permission.photos,
        Permission.camera,
        Permission.notification,
      ].request();
    }
  }

  String detectCardType(String cardNumber) {
    if (RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$').hasMatch(cardNumber)) {
      return "Visa";
    } else if (RegExp(r'^5[1-5][0-9]{14}$').hasMatch(cardNumber)) {
      return "MasterCard";
    } else if (RegExp(r'^3[47][0-9]{13}$').hasMatch(cardNumber)) {
      return "AmericanExpress";
    } else {
      return "blank";
    }
  }

  // Function to mask the card number
  String maskDetails(String details) {
    if (details.length > 3) {
      return '**** ${details.substring(details.length - 3)}';
    } else {
      return details;
    }
  }

  advancedStatusCheck(BuildContext context) async {
    final newVersion = NewVersionPlus(
      iOSId: 'com.ca.growsfinancial',
      androidId: 'com.ca.growsfinancial',
    );
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      if (status.canUpdate) {
        String lastAccess = await getStringSharedPreferences("lastAccess");
        DateTime lastDate;
        if (lastAccess.isNotEmpty) {
          lastDate = DateTime.parse(lastAccess);

          debugPrint("lastAccess::$lastDate");
          if (DateTime.now().isAfter(lastDate) && context.mounted) {
            newVersion.showUpdateDialog(
              context: context,
              versionStatus: status,
              allowDismissal: true,
              dialogText:
                  'Please Update Your App for future usage and Re-Login after update..',
              dismissAction: () {
                var date = DateTime.now();
                debugPrint("Current Date::$date");
                var newDate = DateTime(date.year, date.month, date.day + 5);
                debugPrint("New Date::$newDate");

                setStringSharedPreferences("lastAccess", newDate.toString());
              },
            );
          }
        } else {
          if (context.mounted) {
            newVersion.showUpdateDialog(
              context: context,
              versionStatus: status,
              allowDismissal: true,
              dialogText: 'Please Update Your App for future usage.',
              dismissAction: () {
                Get.back(closeOverlays: true);
                var date = DateTime.now();
                debugPrint("Current Date::$date");
                var newDate = DateTime(date.year, date.month, date.day + 5);
                debugPrint("New Date::$newDate");

                setStringSharedPreferences("lastAccess", newDate.toString());
              },
            );
          }
        }
      }
    }
  }

  void openMailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'fantasycricket0011@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Feedback on Cricket Whiz',
        'body': 'I would like to provide the following feedback:',
      }),
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error :: $e");
      }
    }
  }

  Future<void> launchURL(String urlString) async {
    final Uri uri = Uri.parse(urlString);

    // Optional: quick guard
    if (!['http', 'https'].contains(uri.scheme)) {
      throw 'Unsupported URL scheme: ${uri.scheme}';
    }

    final bool canLaunch = await canLaunchUrl(uri);
    if (!canLaunch) {
      // Try forcing external application
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw 'Could not launch $urlString';
      }
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      throw 'Could not launch $urlString';
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  void exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  /*void backHome(value, data) {
    Future.delayed(Duration(milliseconds: 300), () {
      // Perform navigation after a short delay
      Get.offNamed(NavigationScreen.id, arguments: {
        "index": 0,
        "screen": HomeScreen(),
        "page": "Home",
        "pageTitle": "Home",
      });
    });
  }*/

  double truncateToTwoDecimals(double value) {
    return (value * 100).truncateToDouble() / 100;
  }

  String updateTimeDisplay({
    required DateTime targetDateTime,
    String status = "",
  }) {
    DateTime now = DateTime.now();
    String timeDisplay = "";
    if (targetDateTime.year == now.year &&
        targetDateTime.month == now.month &&
        targetDateTime.day == now.day) {
      // Calculate the time difference
      Duration difference = targetDateTime.difference(now);
      if (difference.isNegative) {
        timeDisplay = '0 sec';
      } else if (difference.inHours > 0) {
        timeDisplay = '${difference.inHours} h ${difference.inMinutes % 60} m';
      } else if (difference.inMinutes > 0) {
        timeDisplay =
            '${difference.inMinutes} m ${difference.inSeconds % 60} s';
      } else {
        timeDisplay = '${difference.inSeconds} sec';
      }
      if (status == "live") {
        timeDisplay = "Live";
      }
    } else {
      timeDisplay = "";
    }
    return timeDisplay;
  }

  void debugLog(String stack) {
    if (kDebugMode) {
      developer.log(stack);
    }
  }
}
