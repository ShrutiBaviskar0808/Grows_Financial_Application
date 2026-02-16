// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:growsfinancial/components/common_safe_area.dart';
import 'package:growsfinancial/screens/login_screen.dart';
import 'package:growsfinancial/screens/no_internet_screen.dart';
import 'package:growsfinancial/utils/config.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "/SplashScreen";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Config config = Config();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => navigation());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: CommonSafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: width,
                    height: height / 1.5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  navigation() async {
    bool isConnected = await config.checkConnection();
    bool isLogin = await config.getBooleanSharedPreferences("isLogin");

    if (isConnected) {
      if (isLogin) {
        // Navigate and remove all previous screens (NavigationScreen becomes the root)
        Get.offAllNamed(HomeScreen.id);
      } else {
        // Navigate to StartScreen
        Get.offAllNamed(LoginScreen.id);
      }
    } else {
      Get.offAllNamed(NoInternetScreen.id);
    }
  }
}
