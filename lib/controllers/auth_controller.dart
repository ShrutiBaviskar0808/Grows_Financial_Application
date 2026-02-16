import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/screens/accounts_screen.dart';
import 'package:growsfinancial/screens/home_screen.dart';
import 'package:growsfinancial/screens/login_screen.dart';
import 'package:growsfinancial/service/rest_api.dart';
import 'package:growsfinancial/utils/config.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AuthController extends GetxController {
  final Config config = Config();
  final RestApi restApi = RestApi();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController sinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  Widget currentScreen = AccountsScreen();
  final BackdropNavController nav = Get.put(BackdropNavController());

  // Error fields
  final nameError = ''.obs;
  final mobileError = ''.obs;
  final dobError = ''.obs;
  final emailError = ''.obs;
  final sinError = ''.obs;
  final oldPasswordError = ''.obs;
  final passwordError = ''.obs;
  final otpError = ''.obs;
  final confirmPasswordError = ''.obs;

  var showPassword = true.obs,
      showOldPassword = true.obs,
      showConfirmPassword = true.obs,
      showSpinner = false.obs,
      showOtp = false.obs,
      userID = "".obs,
      clientID = "".obs,
      name = "".obs,
      email = "".obs,
      sin = "".obs,
      otp = "".obs,
      password = "".obs,
      dob = "".obs,
      oldPassword = "".obs,
      mobileNumber = "".obs,
      countryCode = "+1".obs,
      userData = {}.obs;
  DateTime currentDate = DateTime.now();

  void handleDatePick({
    required BuildContext context,
    required TextEditingController controller,
    required RxString value,
  }) async {
    DateTime dateTime = await config.pickDate(context, currentDate);
    if (dateTime != currentDate) {
      controller.text = DateFormat.yMMMMd().format(dateTime);
      value.value = DateFormat('yyyy-MM-dd').format(dateTime);
      update();
    }
  }

  bool validateForm(String field) {
    // Reset all errors first
    nameError.value = '';
    mobileError.value = '';
    emailError.value = '';
    dobError.value = '';
    sinError.value = '';
    passwordError.value = '';
    oldPasswordError.value = '';
    confirmPasswordError.value = '';
    otpError.value = '';

    bool isValid = true;

    // Name
    if ((field == "register" || field == "updateProfile" || field == "name") &&
        nameController.text.trim().isEmpty) {
      nameError.value = "Please Enter Name";
      isValid = false;
    } else {
      name.value = nameController.text.trim();
    }

    // Mobile

    // Email
    final emailText = emailController.text.trim();
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if((field == "register" || field == "updateProfile" || field == "email")) {
      if (emailText.isEmpty) {
        emailError.value = "Please Enter Email";
        isValid = false;
      } else if (!emailRegex.hasMatch(emailText)) {
        emailError.value = "Enter a valid email";
        isValid = false;
      } else {

        email.value = emailText;
        if (field == "register") {
          sendOtpToEmail();
        }
      }
    }

    // Dob
    final dobText = dob.trim();

    if ((field == "register" || field == "updateProfile" || field == "dob") &&dobText.isEmpty) {
      dobError.value = "Please Select Date of Birth";
      isValid = false;
    }

    // OTP (only if OTP is shown/sent)
    if (field == "register") {
      if (showOtp.value) {
        if (otpController.text.trim().isEmpty) {
          otpError.value = "Please Enter OTP";
          isValid = false;
        } else if (otpController.text.trim() != otp.value.trim()) {
          otpError.value = "Please Enter correct OTP";
          isValid = false;
        }
      }
    }
    if (field == "register" || field == "updatePassword" || field == "name") {
      if (field == "updatePassword") {
        // Password
        final pass = oldPasswordController.text;
        if (pass.isEmpty) {
          oldPasswordError.value = "Please Enter Old Password";
          isValid = false;
        } else {
          oldPassword.value = pass;
        }
      }
      // Password
      final pass = passwordController.text;
      if (pass.isEmpty) {
        passwordError.value = "Please Enter Password";
        isValid = false;
      } else {
        password.value = pass;
      }
      if (field == "updatePassword") {
        if (password.value == oldPassword.value) {
          passwordError.value = "Old and New Password can not be same";
          isValid = false;
        }
      }

      // Confirm password
      final confirmPass = confirmPasswordController.text;
      if (confirmPass.isEmpty) {
        confirmPasswordError.value = "Please Enter Confirm Password";
        isValid = false;
      } else if (confirmPass != pass) {
        confirmPasswordError.value = "Password Does Not Match";
        isValid = false;
      }
    }
    // Because we’re using Obx with Rx, no need to call update()
    return isValid;
  }

  // Optional: keep these if you want live field validation on submit
  void phoneSubmit(text) => validateForm("phone");

  void emailSubmit(text) => validateForm("email");

  void sinSubmit(String text) => validateForm("sin");

  void passwordSubmit(text) => validateForm("password");

  void oldPasswordSubmit(text) => validateForm("oldPassword");

  void confirmPasswordSubmit(text) => validateForm("confirmPassword");

  void nameSubmit(text) => validateForm("name");

  bool isValidSIN(String sin) {
    if (!RegExp(r'^\d{9}$').hasMatch(sin)) return false;

    final digits = sin.split('').map(int.parse).toList();
    int sum = 0;

    for (int i = 0; i < digits.length; i++) {
      int val = digits[i];
      // Double every second digit (i = 1,3,5,7)
      if (i % 2 == 1) {
        val *= 2;
        if (val > 9) val = val - 9; // same as summing the two digits
      }
      sum += val;
    }
    return sum % 10 == 0;
  }

  void oldPasswordVisible() {
    showOldPassword.value = !showOldPassword.value;
    update();
  }

  void passwordVisible() {
    showPassword.value = !showPassword.value;
    update();
  }

  void confirmPasswordVisible() {
    showConfirmPassword.value = !showConfirmPassword.value;
    update();
  }

  Future<void> register() async {
    if (!validateForm("register")) {
      return;
    }
    showSpinner(true);
    try {
      var response = await restApi.register(
        nameController.text,
        mobileController.text,
        emailController.text,
        passwordController.text,
        dob.value,
        sinController.text,
      );

      if (response != null && response['result'] == 'success') {
        dynamic userData = response['data'];
        userID.value = userData['id'].toString();
        mobileNumber.value = mobileController.text;
        clearForm();
        config.setBooleanSharedPreferences("isLogin", true);
        config.setStringSharedPreferences("id", userData['id'].toString());
        config.setStringSharedPreferences("name", userData['name']);
        Get.offNamedUntil(HomeScreen.id, ModalRoute.withName(HomeScreen.id));
        nav.openPage(AccountsScreen.id);
      } else {
        config.showToastFailure(response['msg']);
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to register");
    } finally {
      showSpinner(false);
    }
  }

  Future<void> sendOtpToEmail() async {
    if (emailController.text.isEmpty) {
      emailError.value = "Please enter Email first";
      return;
    }

    try {
      var response = await restApi.sendOtp(emailController.text.trim());
      log("Response :$response");
      if (response['result'] == 'success') {
        otp.value = response['otp'].toString();
        showOtp(true);
        config.showToastSuccess("OTP sent to your email");
      } else {
        config.showToastFailure(response['msg']);
      }
    } catch (e) {
      config.showToastFailure("Failed to send OTP");
    }
  }

  //Login

  bool validateLoginForm() {
    bool isValid = true;
    if (emailController.text.isEmpty) {
      emailError.value = "Please Enter Email or MobileNumber";
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError.value = "Please Enter Password";
      isValid = false;
    }

    return isValid;
  }

  void login() async {
    if (!validateLoginForm()) return;
    try {
      showSpinner(true);
      FocusScope.of(Get.context!).unfocus();

      String deviceToken = await config.getStringSharedPreferences(
        "deviceToken",
      );

      var response = await restApi.login(
        emailController.text,
        passwordController.text,
        deviceToken,
      );
      if (response != null) {
        if (response['result'] == "success") {
          emailController.text = "";
          passwordController.text = "";
          dynamic userData = response['data'];
          config.setBooleanSharedPreferences("isLogin", true);
          config.setStringSharedPreferences("id", userData['id'].toString());
          config.setStringSharedPreferences(
            "name",
            userData['name'].toString(),
          );
          clearForm();
          Get.offNamedUntil(HomeScreen.id, ModalRoute.withName(HomeScreen.id));
          nav.openPage(AccountsScreen.id);
        } else {
          config.showToastFailure(response['msg']);
        }
      }

      showSpinner(false);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error :: $e");
      }
      showSpinner(false);
    }
  }

  void logout() {
    clearForm();
    config.setBooleanSharedPreferences("isLogin", false);
    config.setStringSharedPreferences("id", "");
    config.setStringSharedPreferences("name", "");
    Get.offNamedUntil(LoginScreen.id, ModalRoute.withName(LoginScreen.id));
  }

  void getUser() async {
    showSpinner(true);
    try {
      clientID.value = await config.getStringSharedPreferences("id");
      if (clientID.value.isNotEmpty) {
        var response = await restApi.getUser(clientID.value);

        if (response != null && response['result'] == 'success') {
          userData.value = response['data'];
          nameController.text = userData['name'];
          mobileController.text = userData['mobile_number'];
          emailController.text = userData['email'];
          sinController.text = userData['sin'];
        } else {
          config.showToastFailure(response['msg']);
        }
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to get Data");
    }
    showSpinner(false);
    update();
  }

  void updateScreen(Widget screen) {
    currentScreen = screen;
  }

  //Update Profile

  Future<void> updateProfile() async {
    if (!validateForm("updateProfile")) {
      return; // errors are already set, UI will react via Obx
    }
    showSpinner(true);
    try {
      var response = await restApi.updateUserProfile(
        clientID.value,
        nameController.text,
        emailController.text,
        mobileController.text,
        sinController.text,
      );

      if (response != null && response['result'] == 'success') {
        clearForm();
        config.showToastSuccess(response['msg']);
        Get.offNamedUntil(HomeScreen.id, ModalRoute.withName(HomeScreen.id));
        nav.openPage(AccountsScreen.id);
      } else {
        config.showToastFailure(response['msg']);
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to register");
    } finally {
      showSpinner(false);
    }
  }

  Future<void> updatePassword() async {
    if (!validateForm("updatePassword")) {
      return; // errors are already set, UI will react via Obx
    }
    showSpinner(true);
    try {
      var response = await restApi.updatePassword(
        clientID.value,
        oldPasswordController.text,
        passwordController.text,
      );

      if (response != null && response['result'] == 'success') {
        clearForm();
        config.showToastSuccess(response['msg']);
        logout();
      } else {
        config.showToastFailure(response['msg']);
      }
    } catch (e) {
      config.debugLog(e.toString());
      config.showToastFailure("Failed to register");
    } finally {
      showSpinner(false);
    }
  }

  void clearForm() {
    // 🔹 Clear text controllers
    nameController.clear();
    mobileController.clear();
    emailController.clear();
    sinController.clear();
    passwordController.clear();
    oldPasswordController.clear();
    confirmPasswordController.clear();
    otpController.clear();

    // 🔹 Clear error messages
    nameError.value = '';
    mobileError.value = '';
    emailError.value = '';
    sinError.value = '';
    passwordError.value = '';
    oldPasswordError.value = '';
    confirmPasswordError.value = '';
    otpError.value = '';

    // 🔹 Reset observable values
    name.value = '';
    email.value = '';
    sin.value = '';
    otp.value = '';
    password.value = '';
    oldPassword.value = '';
    mobileNumber.value = '';
    countryCode.value = '+1';

    // 🔹 UI flags
    showOtp(false);
    showSpinner(false);
    showPassword(true);
    showOldPassword(true);
    showConfirmPassword(true);

    // 🔹 Optional: reset type back to login

    // If you’re using GetBuilder somewhere
    update();
  }
}
