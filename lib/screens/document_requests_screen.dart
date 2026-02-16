import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/custom_appbar.dart';
import 'package:growsfinancial/components/document_request_raw.dart';
import 'package:growsfinancial/controllers/account_controller.dart';
import 'package:growsfinancial/controllers/backdrop_nav_controller.dart';
import 'package:growsfinancial/screens/accounts_screen.dart';
import 'package:growsfinancial/screens/home_screen.dart';
import 'package:growsfinancial/utils/constant.dart';

class DocumentRequestsScreen extends StatelessWidget {
  DocumentRequestsScreen({super.key});

  static const String id = "/DocumentRequestsScreen";
  final AccountController controller = Get.put(AccountController());
  final BackdropNavController nav = Get.put(BackdropNavController());
  @override
  Widget build(BuildContext context) {
    controller.getDocumentRequest();
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          automaticallyImplyLeading: true,
          onTap: () {
            Get.offNamedUntil(HomeScreen.id, ModalRoute.withName(HomeScreen.id));
            nav.openPage(AccountsScreen.id);
          },
        ),
        body:
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
                                Center(
                                  child: Text(
                                    "Document Requests".toUpperCase(),
                                    style: titleTextStyle.copyWith(
                                      fontSize: 18,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                controller.requests.isEmpty
                                    ? controller.config.noDataView(
                                      msg: "No Requests Found!",
                                    )
                                    : ListView.separated(
                                      itemCount: controller.requests.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      separatorBuilder:
                                          (context, index) =>
                                              SizedBox(height: 5),
                                      // spacing here
                                      itemBuilder: (context, index) {
                                        var request =
                                            controller.requests[index];
                                        return DocumentRequestRaw(
                                          request: request,
                                        );
                                      },
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
