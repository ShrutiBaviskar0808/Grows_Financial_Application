import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/controllers/auth_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = "/ResetPasswordScreen";

  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
      () => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "GROWS",
              style: titleTextStyle.copyWith(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 5,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body:
            controller.showSpinner.value
                ? controller.config.loadingView()
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Change Password".toUpperCase(),
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
                            hintText: "Old Password",
                            textController: controller.oldPasswordController,
                            errorText: controller.oldPasswordError.value,
                            errorColor: Colors.red,
                            onSubmitted: controller.oldPasswordSubmit,
                            password: controller.showOldPassword.value,
                            hintColor: grey2,
                            maxLines: 1,
                            borderRadius: 50.0,
                            keyBoardType: TextInputType.visiblePassword,
                            leadingIcon: Icon(
                              FontAwesomeIcons.key,
                              color: grey2,
                              size: 18,
                            ),
                            suffixIcon: IconButton(
                              onPressed: controller.oldPasswordVisible,
                              icon: Icon(
                                controller.showOldPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          CustomTextField(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 8.0,
                            ),
                            focusedBorderColor: primaryColor,
                            borderColor: grey2,
                            hintText: "New Password",
                            textController: controller.passwordController,
                            errorText: controller.passwordError.value,
                            errorColor: Colors.red,
                            onSubmitted: controller.passwordSubmit,
                            password: controller.showPassword.value,
                            hintColor: grey2,
                            maxLines: 1,
                            borderRadius: 50.0,
                            keyBoardType: TextInputType.visiblePassword,
                            leadingIcon: Icon(
                              FontAwesomeIcons.key,
                              color: grey2,
                              size: 18,
                            ),
                            suffixIcon: IconButton(
                              onPressed: controller.passwordVisible,
                              icon: Icon(
                                controller.showPassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          CustomTextField(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 8.0,
                            ),
                            focusedBorderColor: primaryColor,
                            borderColor: grey2,
                            hintText: "Confirm New Password",
                            password: controller.showConfirmPassword.value,
                            textController:
                                controller.confirmPasswordController,
                            errorText: controller.confirmPasswordError.value,
                            errorColor: Colors.red,
                            onSubmitted: controller.confirmPasswordSubmit,
                            hintColor: grey2,
                            maxLines: 1,
                            borderRadius: 50.0,
                            keyBoardType: TextInputType.visiblePassword,
                            leadingIcon: Icon(
                              FontAwesomeIcons.key,
                              color: grey2,
                              size: 18,
                            ),
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
                              horizontal: 20.0,
                              vertical: 8.0,
                            ),
                            child: CustomTextButton(
                              title: "Change",
                              onTap: controller.updatePassword,
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
