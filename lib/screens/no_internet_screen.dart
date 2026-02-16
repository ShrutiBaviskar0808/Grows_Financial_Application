import 'package:growsfinancial/screens/login_screen.dart';
import 'package:growsfinancial/screens/accounts_screen.dart';
import 'package:growsfinancial/utils/config.dart';
import 'package:growsfinancial/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetScreen extends StatefulWidget {
  static const String id = "/NoInternetScreen";

  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  Config config = Config();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/no_internet.png",
                width: 150,
                height: 150,
              ),
              Text("Oops!", style: titleTextStyle.copyWith(fontSize: 30)),
              const SizedBox(height: 5.0),
              Text(
                'No Internet Connection',
                textAlign: TextAlign.center,
                style: subTitleTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBoldFont,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  bool isConnected = await config.checkConnection();
                  if (isConnected) {
                    navigation();
                  } else {
                    config.showToastFailure('No Internet Connection');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    child: Center(
                      child: Icon(Icons.refresh, size: 34, color: Colors.white),
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

  navigation() async {
    bool isLogin = await config.getBooleanSharedPreferences("isLogin");

    if (isLogin) {
      // Navigate and remove all previous screens (NavigationScreen becomes the root)
      Get.offAllNamed(AccountsScreen.id);
    } else {
      // Navigate to StartScreen
      Get.toNamed(LoginScreen.id);
    }
  }
}
