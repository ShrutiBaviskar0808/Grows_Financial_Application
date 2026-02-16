import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/account_raw.dart';
import 'package:growsfinancial/components/custom_button.dart';
import 'package:growsfinancial/controllers/account_controller.dart';
import 'package:growsfinancial/utils/constant.dart';

class AccountsScreen extends StatelessWidget {
  static const String id = "/AccountsScreen";
  final AccountController controller = Get.put(AccountController());

  AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Obx(
      () =>
          controller.showSpinner.value
              ? controller.config.loadingView()
              : Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 18,
                                ),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  height: 28,
                                ),
                              ),
                              controller.accounts.isEmpty
                                  ? controller.config.noDataView(
                                    msg: "No Accounts Found!",
                                  )
                                  : ListView.separated(
                                    itemCount: controller.accounts.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    separatorBuilder:
                                        (context, index) => SizedBox(height: 5),
                                    // spacing here
                                    itemBuilder: (context, index) {
                                      var account = controller.accounts[index];
                                      return AccountRaw(account: account);
                                    },
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 30.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: CustomTextIconButton(
                      title: "Add New Account",
                      onTap: () {
                        controller.config.showCustomDialog(
                          context,
                          controller.dialogNewBusinessForm(width),
                        );
                      },
                      icon: "assets/icons/add-white.png",
                      width: width,
                      height: 46,
                      color: primaryColor,
                      borderRadius: 50,
                      borderColor: primaryColor,
                      iconColor: Colors.white,
                      iconSize: 15,
                      textStyle: titleTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      orientation: "left",
                    ),
                  ),
                ],
              ),
    );
  }
}
