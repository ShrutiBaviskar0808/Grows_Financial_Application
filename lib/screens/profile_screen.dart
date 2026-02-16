import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/controllers/auth_controller.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = "/ProfileScreen";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    controller.getUser();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Obx(
      () => controller.showSpinner.value
          ? controller.config.loadingView()
          : CommonSafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Edit Profile".toUpperCase(),
                  style: titleTextStyle.copyWith(
                    fontSize: 26,
                    fontWeight: boldFont,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  focusedBorderColor: primaryColor,
                  borderColor: grey2,
                  hintText: "Name as per SIN",
                  textController: controller.nameController,
                  errorText: controller.nameError.value,
                  errorColor: Colors.red,
                  onSubmitted: controller.nameSubmit,
                  hintColor: grey2,
                  maxLines: 1,
                  borderRadius: 50.0,
                  keyBoardType: TextInputType.name,
                  leadingIcon: Icon(
                    FontAwesomeIcons.user,
                    color: grey2,
                    size: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
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
                      hintStyle: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                      ),
                      // labelText: hintText,
                      labelStyle: TextStyle(
                        color: grey2.withValues(alpha: 0.4),
                        fontSize: 18,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          width: 1.0,
                          color: grey2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          width: 1.0,
                          color:
                          controller.mobileError.value.isEmpty
                              ? Colors.transparent
                              : Colors.red,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          width: 1.0,
                          color:
                          controller.mobileError.value.isEmpty
                              ? Colors.transparent
                              : Colors.red,
                        ),
                      ),
                      counterText: "",
                    ),
                    onSubmitted: controller.phoneSubmit,
                    controller: controller.mobileController,
                    countries:
                    countries
                        .where((c) => c.code == 'CA')
                        .toList(),
                    showDropdownIcon: false,
                    initialCountryCode: "CA",
                    showCountryFlag: false,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: grey2, fontSize: 18),
                    dropdownTextStyle: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                    ),
                    dropdownIcon: Icon(
                      Icons.arrow_drop_down,
                      color: primaryColor,
                    ),
                    onChanged: (phone) {
                      controller.mobileController.text = phone.number;
                      controller.mobileNumber.value =
                          phone.completeNumber;
                      // controller.phoneSubmit(phone.number);
                    },
                    onCountryChanged: (country) {
                      controller.countryCode.value =
                      "+${country.dialCode}";
                      controller.update();
                    },
                    showCursor: true,
                  ),
                ),
                CustomTextField(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  focusedBorderColor: primaryColor,
                  borderColor: grey2,
                  hintText: "Email",
                  textController: controller.emailController,
                  errorText: controller.emailError.value,
                  errorColor: Colors.red,
                  onSubmitted: controller.emailSubmit,
                  hintColor: grey2,
                  maxLines: 1,
                  borderRadius: 50.0,
                  keyBoardType: TextInputType.emailAddress,
                  leadingIcon: Icon(
                    FontAwesomeIcons.envelope,
                    color: grey2,
                    size: 18,
                  ),
                ),

                CustomTextField(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  focusedBorderColor: primaryColor,
                  borderColor: grey2,
                  hintText: "Social Insurance Number",
                  textController: controller.sinController,
                  errorText: controller.sinError.value,
                  errorColor: Colors.red,
                  onSubmitted: controller.sinSubmit,
                  hintColor: grey2,
                  maxLines: 1,
                  borderRadius: 50.0,
                  keyBoardType: TextInputType.text,
                  leadingIcon: Icon(
                    FontAwesomeIcons.info,
                    color: grey2,
                    size: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: CustomTextButton(
                    title: "Update",
                    onTap: controller.updateProfile,
                    height: 56,
                    width: width,
                    color: primaryColor,
                    borderRadius: 50.0,
                    textStyle: titleTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
                  ],
                ),
              ),
            ),
    );
  }
}
