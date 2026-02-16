import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/components/dashboard_raw.dart';
import 'package:growsfinancial/controllers/dashboard_controller.dart';
import 'package:growsfinancial/screens/files_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const String id = "/DashboardScreen";
  final DashboardController controller = Get.put(DashboardController());

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.showSpinner.value
              ? controller.config.loadingView()
              : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
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

                            // ✅ Individual dynamic
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              child: DashboardRaw(
                                leftIcon: "assets/icons/user-check.png",
                                title: "Individual\nServices",
                                actions: controller.services,
                                onActionTap: (item) {
                                  // open service detail / service list etc.
                                  Get.toNamed(
                                    FilesScreen.id,
                                    arguments: {
                                      "serviceID": item['id'],
                                      "type": item['type'],
                                      "serviceName": item['name'],
                                    },
                                  );
                                },
                              ),
                            ),

                            // ✅ Business static
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              child: DashboardRaw(
                                leftIcon: "assets/icons/shop.png",
                                title: "Business\nServices",
                                actions: [
                                  {
                                    "service_name": "View",
                                    "icon": "assets/icons/view.png",
                                    "action_key": "business_view",
                                  },
                                  {
                                    "service_name": "Add New",
                                    "icon": "assets/icons/add-blue.png",
                                    "action_key": "business_add",
                                  },
                                ],
                                onActionTap: (item) {
                                  if (item["action_key"] == "business_view") {
                                    // open business list screen
                                  } else {
                                    // open add business dialog
                                    controller.config.showCustomDialog(
                                      context,
                                      controller.dialogNewBusinessForm(
                                        MediaQuery.of(context).size.width,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),

                            const Spacer(), // 🔥 pushes illustration down

                            Center(
                              child: Image.asset(
                                "assets/images/dashboard_illustration.png",
                                height: 220,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
