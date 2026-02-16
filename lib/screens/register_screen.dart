import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/controllers/auth_controller.dart';
import 'package:growsfinancial/screens/login_screen.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = "/RegisterScreen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController controller = Get.put(AuthController());

  final PageController _pageController = PageController();

  final RxInt step = 0.obs; // 0 = step1, 1 = step2

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goNext() {
    step.value = 1;
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void goBack() {
    step.value = 0;
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Widget titleRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign Up",
            style: titleTextStyle.copyWith(
              fontSize: 30,
              fontWeight: boldFont,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => Get.toNamed(LoginScreen.id),
            child: Row(
              children: [
                Text(
                  "Already registered? ",
                  style: titleTextStyle.copyWith(fontSize: 13, color: grey2),
                ),
                Text(
                  "Sign in",
                  style: titleTextStyle.copyWith(
                    fontSize: 13,
                    color: primaryColor,
                    fontWeight: boldFont,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget stepOne(double width) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 0.0,
            ),
            focusedBorderColor: primaryColor,
            borderColor: primaryColor,
            hintText: "Name as per SIN",
            textController: controller.nameController,
            errorText: controller.nameError.value,
            errorColor: Colors.red,
            onSubmitted: controller.nameSubmit,
            hintColor: grey2,
            maxLines: 1,
            borderRadius: 14.0,

            keyBoardType: TextInputType.name,
            leadingIcon: Icon(FontAwesomeIcons.user, color: grey2, size: 18),
          ),

          const SizedBox(height: 12),

          CustomTextField(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            focusedBorderColor: primaryColor,
            borderColor: primaryColor,
            hintText: "Email",
            textController: controller.emailController,
            errorText: controller.emailError.value,
            errorColor: Colors.red,
            onSubmitted: controller.emailSubmit,
            hintColor: grey2,
            maxLines: 1,
            borderRadius: 14.0,
            keyBoardType: TextInputType.emailAddress,
            leadingIcon: Icon(
              FontAwesomeIcons.envelope,
              color: grey2,
              size: 18,
            ),
          ),

          const SizedBox(height: 12),

          /// Mobile (keeping IntlPhoneField)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            child: IntlPhoneField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                alignLabelWithHint: false,
                hintText: "Mobile Number",
                filled: true,
                fillColor: Colors.white,
                errorText:
                    controller.mobileError.value.isNotEmpty
                        ? controller.mobileError.value
                        : null,
                hintStyle: TextStyle(color: grey2, fontSize: 18),
                // labelText: hintText,
                labelStyle: TextStyle(
                  color: grey2.withValues(alpha: 0.4),
                  fontSize: 18,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(color: primaryColor, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(width: 1.0, color: primaryColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(width: 1.0, color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(width: 1.0, color: Colors.red),
                ),
                counterText: "",
              ),
              onSubmitted: controller.phoneSubmit,
              controller: controller.mobileController,
              countries: countries.where((c) => c.code == 'CA').toList(),
              showDropdownIcon: false,
              initialCountryCode: "CA",
              showCountryFlag: false,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: grey2, fontSize: 18),
              dropdownTextStyle: TextStyle(color: grey2, fontSize: 18),
              dropdownIcon: Icon(Icons.arrow_drop_down, color: grey2),
              onChanged: (phone) {
                controller.mobileController.text = phone.number;
                controller.mobileNumber.value = phone.completeNumber;
                // controller.phoneSubmit(phone.number);
              },
              onCountryChanged: (country) {
                controller.countryCode.value = "+${country.dialCode}";
                controller.update();
              },
              showCursor: true,
            ),
          ),
          const SizedBox(height: 12),

          CustomTextField(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            focusedBorderColor: primaryColor,
            borderColor: primaryColor,
            hintText: "Date of Birth",
            textController: controller.dobController,
            errorText: controller.dobError.value,
            errorColor: Colors.red,
            readOnly: true,
            hintColor: grey2,
            maxLines: 1,
            borderRadius: 14.0,
            keyBoardType: TextInputType.datetime,
            leadingIcon: Icon(
              FontAwesomeIcons.calendarDays,
              color: grey2,
              size: 18,
            ),
            onTap: () {
              controller.handleDatePick(
                context: context,
                controller: controller.dobController,
                value: controller.dob,
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            child: CustomTextIconButton(
              title: "Next",
              onTap: goNext,
              height: 52,
              width: width,
              color: primaryColor,
              borderRadius: 14.0,
              textStyle: titleTextStyle.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: boldFont,
              ),
              icon: "assets/icons/forward.png",
              iconColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget stepTwo(double width) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            focusedBorderColor: primaryColor,
            borderColor: primaryColor,
            hintText: "Social Insurance Number",
            textController: controller.sinController,
            errorText: controller.sinError.value,
            errorColor: Colors.red,
            onSubmitted: controller.sinSubmit,
            hintColor: grey2,
            maxLines: 1,
            borderRadius: 14.0,
            keyBoardType: TextInputType.text,
            leadingIcon: Icon(FontAwesomeIcons.idCard, color: grey2, size: 18),
          ),

          const SizedBox(height: 12),

          CustomTextField(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            focusedBorderColor: primaryColor,
            borderColor: primaryColor,
            hintText: "Password",
            textController: controller.passwordController,
            errorText: controller.passwordError.value,
            errorColor: Colors.red,
            onSubmitted: controller.passwordSubmit,
            password: controller.showPassword.value,
            hintColor: grey2,
            maxLines: 1,
            borderRadius: 14.0,
            keyBoardType: TextInputType.visiblePassword,
            leadingIcon: Icon(FontAwesomeIcons.lock, color: grey2, size: 18),
            suffixIcon: IconButton(
              onPressed: controller.passwordVisible,
              icon: Icon(
                controller.showPassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),

          const SizedBox(height: 12),

          CustomTextField(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            focusedBorderColor: primaryColor,
            borderColor: primaryColor,
            hintText: "Confirm Password",
            password: controller.showConfirmPassword.value,
            textController: controller.confirmPasswordController,
            errorText: controller.confirmPasswordError.value,
            errorColor: Colors.red,
            onSubmitted: controller.confirmPasswordSubmit,
            hintColor: grey2,
            maxLines: 1,
            borderRadius: 14.0,
            keyBoardType: TextInputType.visiblePassword,
            leadingIcon: Icon(FontAwesomeIcons.lock, color: grey2, size: 18),
            suffixIcon: IconButton(
              onPressed: controller.confirmPasswordVisible,
              icon: Icon(
                controller.showConfirmPassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    title: "Back",
                    onTap: goBack,
                    height: 52,
                    width: width,
                    color: Colors.white,
                    borderRadius: 14.0,
                    borderColor: primaryColor,
                    textStyle: titleTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: boldFont,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextIconButton(
                    title: "Create",
                    onTap: controller.register,
                    height: 52,
                    width: width,
                    color: primaryColor,
                    borderRadius: 14.0,
                    textStyle: titleTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: boldFont,
                    ),
                    icon: "assets/icons/forward.png",
                    iconColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body:
            controller.showSpinner.value
                ? controller.config.loadingView()
                : CommonSafeArea(
                  top: true,
                  bottom: false,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: close icon
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 15.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () => Get.back(),
                                        child: Container(
                                          height: 28,
                                          width: 28,
                                          decoration: const BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Title
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Text(
                                    "Welcome !",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Logo
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/logo.png",
                                      height: 40,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                titleRow(),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Image.asset(
                                      "assets/images/signup_illustration.png",
                                      height: 180,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 320,
                                  child: PageView(
                                    controller: _pageController,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [stepOne(width), stepTwo(width)],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
