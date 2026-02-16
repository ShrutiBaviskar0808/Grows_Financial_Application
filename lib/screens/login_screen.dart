import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/components/custom_text_field.dart';
import 'package:growsfinancial/controllers/auth_controller.dart';
import 'package:growsfinancial/screens/register_screen.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  static const String id = "/LoginScreen";

  LoginScreen({super.key});

  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
                      /// Top Blue Space
                      const SizedBox(height: 20),

                      /// White Container
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
                                /// Welcome
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 56.0,
                                    left: 35.0,
                                  ),
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
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/logo.png",
                                      height: 28,
                                    ),
                                  ),
                                ),

                                /// Illustration
                                Center(
                                  child: Image.asset(
                                    "assets/images/login_illustration.png",
                                    height: 250,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                /// Email Field
                                CustomTextField(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 8.0,
                                  ),
                                  focusedBorderColor: primaryColor,
                                  borderColor: grey2,
                                  hintText: "Email",
                                  textController: controller.emailController,
                                  hintColor: grey2,
                                  borderRadius: 20.0,
                                  maxLines: 1,
                                  keyBoardType: TextInputType.emailAddress,
                                  leadingIcon: Icon(
                                    FontAwesomeIcons.envelope,
                                    color: grey2,
                                    size: 18,
                                  ),
                                  errorText: controller.emailError.value,
                                  errorColor: Colors.red,
                                  onSubmitted: controller.emailSubmit,
                                ),
                                CustomTextField(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 8.0,
                                  ),
                                  focusedBorderColor: primaryColor,
                                  borderColor: grey2,
                                  hintText: "Password",
                                  textController: controller.passwordController,
                                  hintColor: grey2,
                                  maxLines: 1,
                                  borderRadius: 20.0,
                                  keyBoardType: TextInputType.visiblePassword,
                                  leadingIcon: Icon(
                                    FontAwesomeIcons.key,
                                    color: grey2,
                                    size: 18,
                                  ),
                                  errorText: controller.passwordError.value,
                                  errorColor: Colors.red,
                                  onSubmitted: controller.passwordSubmit,
                                  password: controller.showPassword.value,
                                  suffixIcon: IconButton(
                                    onPressed: controller.passwordVisible,
                                    icon: Icon(
                                      controller.showPassword.value
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
                                  child: CustomTextIconButton(
                                    title: "Login",
                                    onTap: controller.login,
                                    height: 56,
                                    width: width,
                                    color: primaryColor,
                                    borderRadius: 20.0,
                                    textStyle: titleTextStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                    icon: "assets/icons/forward.png",
                                    iconColor: Colors.white,
                                    iconSize: 18,
                                  ),
                                ),

                                /// Forgot Password
                                Center(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),

                                /// Sign Up
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(RegisterScreen.id);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Don't have account? "),
                                      const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
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
